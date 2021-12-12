//
//  InterfaceController.swift
//  reHydrate-watch Extension
//
//  Created by Petter vang Brakalsvålet on 07/07/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import WatchKit
import ClockKit
import CoreData
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    var metric  = true
    let context = (WKExtension.shared().delegate as? ExtensionDelegate)?.persistentContainer.viewContext
    var smallDrink: Double = 300
    var mediumDrink: Double = 500
    var largeDrink: Double  = 750
    var today: Day?
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE - dd MMM"
        return dateFormatter
    }()

    @IBOutlet weak var summaryLable: WKInterfaceLabel!
    @IBAction func smallButton() {
        let small = Measurement(value: smallDrink, unit: UnitVolume.milliliters)
        today?.consumed += small.converted(to: .liters).value
        updateSummary()
    }
    @IBAction func mediumButton() {
        let medium = Measurement(value: mediumDrink, unit: UnitVolume.milliliters)
        today?.consumed += medium.converted(to: .liters).value
        updateSummary()
    }
    @IBAction func largeButton() {
        let large = Measurement(value: largeDrink, unit: UnitVolume.milliliters)
        today?.consumed += large.converted(to: .liters).value
        updateSummary()
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        today = fetchToday()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            if session.activationState != .activated {
                session.activate()
            }
        }
        let delegate  = WKExtension.shared().delegate as? ExtensionDelegate
        if let today = today {
            delegate?.todayConsumed = today.consumed
            delegate?.todayGoal = today.goal
            delegate?.todayDate = today.date
        }
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach({ (complication) in
            server.reloadTimeline(for: complication)
        })
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        let delegate = WKExtension.shared().delegate as? ExtensionDelegate
        if let today = today {
            delegate?.todayConsumed = today.consumed
            delegate?.todayGoal = today.goal
            delegate?.todayDate = today.date
        }
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach({ (complication) in
            server.reloadTimeline(for: complication)
        })
    }

    private func updateSummary() {
        updateLabel()
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach({ (complication) in
            server.reloadTimeline(for: complication)
        })
        saveDays()
        export()
    }

    private func updateLabel() {
        guard let today = today else { return }
        let consumedAmount = Measurement(value: today.consumed, unit: UnitVolume.liters)
        let goalAmount = Measurement(value: Double(today.goal), unit: UnitVolume.liters)
        if metric {
            summaryLable.setText("\(consumedAmount.converted(to: .liters).value.clean)/" +
                                 "\(goalAmount.converted(to: .liters).value.clean)L")
        } else {
            summaryLable.setText("\(consumedAmount.converted(to: .imperialPints).value.clean)/" +
                                 "\(goalAmount.converted(to: .imperialPints).value.clean)pt")
        }
    }

    private func export() {
        guard let today = today else { return }
        let message = ["date": formatter.string(from: today.date),
                       "metric": String(metric),
                       "consumed": String(today.consumed)] as [String: String]
        print(message)
        if WCSession.default.isReachable {
            // send the updated date to the phone instantly.
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
        } else {
            // if the watch isn't connected this message will be sent with a long term time out.
            WCSession.default.transferUserInfo(message)
        }
    }
}

// MARK: - Load and Save days
extension InterfaceController {
    /// Loading all days saved to core data.
    /// - Returns: *[Day]* an array off days loaded
    public func fetchAllDays() -> [Day] {
        do {
            var days = try context?.fetch(Day.fetchRequest())
            days?.sort { $0.date < $1.date }
            print("Fetching all saved days")
            _ = days?.map { $0.toPrint() }
            return days ?? []
        } catch {
            print("can't fetch days")
            print(error.localizedDescription)
            return [Day(context: context!)]
        }
    }

    /// Will get a day representing data for the current day.
    ///  It will also set the goal to be the same as the goal from the previous day.
    /// - Returns: The day found to be equal to todays date.
    public func fetchToday() -> Day {
        do {
            let request = Day.fetchRequest() as NSFetchRequest
            // Get today's beginning & tomorrows beginning time
            let todaysStart = Calendar.current.startOfDay(for: Date())
            let tomorrowsStart = Calendar.current.date(byAdding: .day, value: 1, to: todaysStart)
            // Sets conditions for date to be within today
            let fromPredicate = NSPredicate(format: "date >= %@", todaysStart as NSDate)
            let toPredicate = NSPredicate(format: "date < %@", tomorrowsStart! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request.fetchLimit = 1
            request.predicate = datePredicate
            // tries to get the day out of the array.
            let loadedDays = try context?.fetch(request)
            print("Fetching today")
            loadedDays?.forEach { $0.toPrint() }
            // If today wasn't found it will create a new day.
            if let today = loadedDays?.first {
                DispatchQueue.main.async {
                    self.updateLabel()
                }
                return today
            } else {
                print("can't load today")
                let allDays = fetchAllDays()
                let previousDay = allDays.last
                let today = Day(context: context!)
                today.date = Date()
                today.goal = previousDay?.goal ?? 3
                return today
            }
        } catch {
            print("can't featch day")
            print(error.localizedDescription)
            // If the loading of data fails, we create a new day
            let today = Day(context: context!)
            today.date = Date()
            today.goal = 3
            return today
        }
    }

    /// Tries to save all days created in context
    public func saveDays() {
        do {
            try context?.save()
        } catch {
            print("can't save days")
            print(error.localizedDescription)
        }
    }

}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if activationState == .activated {
            print("Connection established")
        } else {
            print(error?.localizedDescription ?? "unknown error")
            print("Can't connect")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("Recived message from phone")
        handlePhone(message)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        print("Recived userInfo from phone")
        handlePhone(userInfo)
    }

    private func handlePhone(_ data: [String: Any]) {
        let date = data["phoneDate"] as? String ?? ""
        let goal = data["phoneGoal"] as? String ?? ""
        let consumed = data["phoneConsumed"] as? String ?? ""

        if let drinkOptions = data["phoneDrinks"] as? String {
            let drinks = drinkOptions.components(separatedBy: ",")
            self.smallDrink  = Double(drinks[0]) ?? 300.0
            self.mediumDrink = Double(drinks[1]) ?? 500.0
            self.largeDrink  = Double(drinks[2]) ?? 750.0
        }

        let today = fetchToday()
        guard formatter.string(from: today.date) == date else { return }
        print("todays amount was updated with user info")
        DispatchQueue.main.async {
            if let consumed = Double(consumed), today.consumed != consumed {
                today.consumed = consumed
            }
            if let goal = Double(goal), today.goal != goal {
                today.goal = goal
            }
            self.saveDays()
            self.updateSummary()
        }
        let delegate = WKExtension.shared().delegate as? ExtensionDelegate
        delegate?.todayConsumed = today.consumed
        delegate?.todayGoal = today.goal
        delegate?.todayDate = today.date

        let server = CLKComplicationServer.sharedInstance()
        guard let activeComplications = server.activeComplications else { return }
        for complication in activeComplications {
            server.reloadTimeline(for: complication)
        }
    }
}
