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
                saveDays()
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
