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
    let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    var days: [Day] = []
    var smallDrink  = Double(300)
    var mediumDrink = Double(500)
    var largeDrink  = Double(750)
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE - dd/MM/yy"
        return dateFormatter
    }()
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter
    }()
    
    @IBOutlet weak var summaryLable: WKInterfaceLabel!
    @IBAction func smallButton() {
        let small = Measurement(value: smallDrink, unit: UnitVolume.milliliters)
        let today = fetchToday()
        today.consumed += small.converted(to: .liters).value
        updateSummary()
    }
    @IBAction func mediumButton() {
        let medium = Measurement(value: mediumDrink, unit: UnitVolume.milliliters)
        let today = fetchToday()
        today.consumed += medium.converted(to: .liters).value
        updateSummary()
    }
    @IBAction func largeButton() {
        let large = Measurement(value: largeDrink, unit: UnitVolume.milliliters)
        let today = fetchToday()
        today.consumed += large.converted(to: .liters).value
        updateSummary()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        days = fetchAllDays()
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            if session.activationState != .activated {
                session.activate()
            }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let today = fetchToday()
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            if session.activationState != .activated {
                session.activate()
            }
        }
        let delegate  = WKExtension.shared().delegate as! ExtensionDelegate
        delegate.todayConsumed = today.consumed
        delegate.todayGoal = today.goal
        delegate.todayDate = today.date
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach({ (complication) in
            server.reloadTimeline(for: complication)
        })
        updateSummary()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        let today = fetchToday()
        let delegate = WKExtension.shared().delegate as! ExtensionDelegate
        delegate.todayConsumed = today.consumed
        delegate.todayGoal = today.goal
        delegate.todayDate = today.date
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach({ (complication) in
            server.reloadTimeline(for: complication)
        })
    }
    
    func updateSummary(){
        let today = fetchToday()
        let consumedAmount = Measurement(value: Double(today.consumed), unit: UnitVolume.liters)
        let goalAmount = Measurement(value: Double(today.goal), unit: UnitVolume.liters)
        if metric {
            summaryLable.setText("\(consumedAmount.converted(to: .liters).value.clean)/\(goalAmount.converted(to: .liters).value.clean)L")
        } else {
            summaryLable.setText("\(consumedAmount.converted(to: .imperialPints).value.clean)/\(goalAmount.converted(to: .imperialPints).value.clean)pt")
        }
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach({ (complication) in
            server.reloadTimeline(for: complication)
        })
        saveDays()
        let consumed = String(today.consumed)
        let message = ["date": formatter.string(from: today.date),
                       "time": timeFormatter.string(from: today.date),
                       "metric": String(metric),
                       "consumed": consumed] as [String : String]
        print(message)
        if WCSession.default.isReachable {
            //send the updated date to the phone instantly.
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { (error) in
                print(error.localizedDescription)
                WCSession.default.transferUserInfo(message)
            })
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
            var days = try context.fetch(Day.fetchRequest()) as! [Day]
            days.sort {$0.date < $1.date}
            #if DEBUG
            days.forEach({$0.toPrint()})
            #endif
            return days
        } catch {
            #if DEBUG
            print("can't fetch days")
            print(error.localizedDescription)
            #endif
            return [Day(context: context)]
        }
    }

    /// Remove a specific day
    /// - Parameter day: The day you want to remove
    public func removeDay(day : Day){
        context.delete(day)
    }
    
    /// Will get a day representing data for the current day. It will also set the goal to be the same as the goal from the previous day.
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
            let loadedDays = try context.fetch(request)
            #if DEBUG
            loadedDays.forEach({$0.toPrint()})
            #endif
            // If today wasn't found it will create a new day.
            guard let today = loadedDays.first else {
                #if DEBUG
                print("can't today")
                #endif
                let allDays = fetchAllDays()
                let previousDay = allDays.last
                let today = Day(context: context)
                today.date = Date()
                today.goal = previousDay?.goal ?? 3
                return today
            }
            return today
        } catch {
            #if DEBUG
            print("can't featch day")
            print(error.localizedDescription)
            #endif
            // If the loading of data fails, we create a new day
            let today = Day(context: context)
            today.date = Date()
            today.goal = 3
            return today
        }
    }

    /// Will featch and return a spesific day or reurn nill if day can't be found for the date.
    /// - Parameter date: The date for the spesific day you wan't
    /// - Returns: returns *Day* if found else nil
    public func fetchDay(_ date: Date) -> Day? {
        do {
            let request = Day.fetchRequest() as NSFetchRequest
            // Get day's beginning & tomorrows beginning time
            let startTime = Calendar.current.startOfDay(for: date)
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startTime)
            // Sets conditions for date to be within day
            let fromPredicate = NSPredicate(format: "date >= %@", startTime as NSDate)
            let toPredicate = NSPredicate(format: "date < %@", nextDay! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request.predicate = datePredicate
            request.fetchLimit = 1
            // tries to get the day out of the array.
            let loadedDays = try context.fetch(request)
            #if DEBUG
            loadedDays.forEach({$0.toPrint()})
            #endif
            let day = loadedDays.first
            return day
        } catch {
            print("can't fetch day")
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Tries to save all days created in context
    public func saveDays() {
        do {
            try context.save()
        } catch {
            #if DEBUG
            print("can't save days")
            print(error.localizedDescription)
            #endif
        }
    }

}

extension InterfaceController: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("Connection established")
        } else {
            print(error?.localizedDescription ?? "unknown error")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        let today = fetchToday()
        print("resived message")
        print(message)
        let response = ["date": formatter.string(from: today.date),
                        "time": timeFormatter.string(from: today.date),
                        "metric": String(metric),
                        "consumed": String(today.consumed)] as [String : String]
        replyHandler(response)
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        let today = fetchToday()
        print("sent data with transferUserInfo")
        let phoneDate     = String(describing: userInfo["phoneDate"] ?? "")
        let phoneGoal     = String(describing: userInfo["phoneGoal"] ?? "")
        let phoneConsumed = String(describing: userInfo["phoneConsumed"] ?? "")
        let phoneDrinks   = String(describing: userInfo["phoneDrinks"] ?? "")
        
        let drinkOptions = phoneDrinks.components(separatedBy: ",")
        self.smallDrink  = Double(drinkOptions[0]) ?? Double(300)
        self.mediumDrink = Double(drinkOptions[1]) ?? Double(500)
        self.largeDrink  = Double(drinkOptions[2]) ?? Double(750)
        formatter.dateFormat = "EEEE - dd/MM/yy"
        if formatter.string(from: today.date) == phoneDate {
            guard let consumed = Double(phoneConsumed) else {
                print("error can't extract number from string")
                return
            }
            today.consumed = consumed
            guard let goal = Double(phoneGoal) else {
                print("error can't extract number from string")
                return
            }
            today.goal = goal
            print("todays amount was updated with user info")
            DispatchQueue.main.async {
                self.saveDays()
                self.updateSummary()
                
                let delegate = WKExtension.shared().delegate as! ExtensionDelegate
                delegate.todayConsumed = today.consumed
                delegate.todayGoal = today.goal
                delegate.todayDate = today.date
                let server = CLKComplicationServer.sharedInstance()
                guard let activeComplications = server.activeComplications else { return }
                for complication in activeComplications {
                    server.reloadTimeline(for: complication)
                }
            }
        }
    }
}
