//
//  InterfaceController.swift
//  reHydrate-watch Extension
//
//  Created by Petter vang Brakalsvålet on 07/07/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    
    var today = Day(date: Date(), goalAmount: Drink(typeOfDrink: "water", amountOfDrink: 3), consumedAmount: Drink())
    var days: [Day] = []
    var smallDrink  = Drink(typeOfDrink: "water", amountOfDrink: 300)
    var mediumDrink = Drink(typeOfDrink: "water", amountOfDrink: 500)
    var largeDrink  = Drink(typeOfDrink: "water", amountOfDrink: 750)
    var metric = true
    let formatter = DateFormatter()
    
    @IBOutlet weak var summaryLable: WKInterfaceLabel!
    
    @IBAction func smallButton() {
        let small = Measurement(value: Double(smallDrink.amountOfDrink), unit: UnitVolume.milliliters)
        today.consumed.amountOfDrink += Float(small.converted(to: .liters).value)
        updateSummary()
    }
    
    @IBAction func mediumButton() {
        let medium = Measurement(value: Double(mediumDrink.amountOfDrink), unit: UnitVolume.milliliters)
        today.consumed.amountOfDrink += Float(medium.converted(to: .liters).value)
        updateSummary()
    }
    
    @IBAction func largeButton() {
        let large = Measurement(value: Double(largeDrink.amountOfDrink), unit: UnitVolume.milliliters)
        today.consumed.amountOfDrink += Float(large.converted(to: .liters).value)
        updateSummary()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        days = Day.loadDays()
        //ask the phone for the goal and the consumed amount.
        
        updateToday()
        
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        updateToday()
        
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    /**
     Will check if the correct day is loaded and is being changed, if not it will change to that day.
     
     # Example #
     ```
     isToday()
     ```
     */
    func updateToday(){
        formatter.dateFormat = "EEEE - dd/MM/yy"
        if days.contains(where: {formatter.string(from: $0.date) == formatter.string(from: Date.init())}){
            today = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: Date.init())})!
        } else {
            today = Day.init()
            insertDay(today)
        }
        updateSummary()
    }
    
    /**
     Adds or updates the day in an array of days
     
     - parameter dayToInsert: -  An day to insert in an array.
     
     # Notes: #
     1. Parameters must be of type Day
     
     # Example #
     ```
     insertDay(today)
     ```
     */
    func insertDay(_ dayToInsert: Day){
        if days.isEmpty {
            days.append(dayToInsert)
        } else {
            if days.contains(where: {formatter.string(from: $0.date) ==
                formatter.string(from: dayToInsert.date) }) {
                days[days.firstIndex(of: dayToInsert) ?? days.count - 1] = dayToInsert
            } else {
                days.append(dayToInsert)
            }
        }
    }
    
    func updateSummary(){
        insertDay(today)
        let consumedAmount = Measurement(value: Double(today.consumed.amountOfDrink), unit: UnitVolume.liters)
        let goalAmount = Measurement(value: Double(today.goal.amountOfDrink), unit: UnitVolume.liters)
        if metric {
            summaryLable.setText("\(String(format: "%.1f", consumedAmount.converted(to: .liters).value))/\(String(format: "%.1f", goalAmount.converted(to: .liters).value))L")
        } else {
            summaryLable.setText("\(String(format: "%.1f", consumedAmount.converted(to: .imperialPints).value))/\(String(format: "%.1f", goalAmount.converted(to: .imperialPints).value))pt")
        }
        Day.saveDays(days)
        let consumed = String(today.consumed.amountOfDrink)
        let message = ["date": formatter.string(from: today.date),
                       "metric": String(metric),
                       "consumed": consumed] as [String : String]
        if WCSession.default.activationState == .activated {
            //send the updated date to the phone instantly.
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { (error) in
                print(error.localizedDescription)
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
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("sent data with sendMessage")
        print(String(describing: message["phoneDate"]!))
        print(String(describing: message["phoneConsumed"]!))
        print(String(describing: message["phoneConsumed"]!))
        if formatter.string(from: today.date) == message["phoneDate"] as! String {
            let messageConsumed = message["phoneConsumed"]!
            let numberFormatter = NumberFormatter()
            let consumed = numberFormatter.number(from: messageConsumed as! String)!.floatValue
            today.consumed.amountOfDrink = consumed
            let messageGoal = message["phoneGoal"]!
            let goal = numberFormatter.number(from: messageGoal as! String)!.floatValue
            today.goal.amountOfDrink = goal
            print("todays amount was updated by message")
            DispatchQueue.main.async {
                self.insertDay(self.today)
                Day.saveDays(self.days)
                self.updateSummary()
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("sent data with transferUserInfo")
        print(String(describing: userInfo["phoneDate"]!))
        print(String(describing: userInfo["phoneConsumed"]!))
        print(String(describing: userInfo["phoneConsumed"]!))
        if formatter.string(from: today.date) == userInfo["phoneDate"] as! String {
            let messageConsumed = userInfo["phoneConsumed"]!
            let numberFormatter = NumberFormatter()
            let consumed = numberFormatter.number(from: messageConsumed as! String)!.floatValue
            today.consumed.amountOfDrink = consumed
            let messageGoal = userInfo["phoneGoal"]!
            let goal = numberFormatter.number(from: messageGoal as! String)!.floatValue
            today.goal.amountOfDrink = goal
            print("todays amount was updated with user info")
            DispatchQueue.main.async {
                self.insertDay(self.today)
                Day.saveDays(self.days)
                self.updateSummary()
            }
        }
    }
}
