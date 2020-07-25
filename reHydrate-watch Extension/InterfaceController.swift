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
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    
    var today = Day(date: Date(), goalAmount: Drink(typeOfDrink: "water", amountOfDrink: 3), consumedAmount: Drink())
    var days: [Day] = []
    var smallDrink  = Drink(typeOfDrink: "water", amountOfDrink: 300)
    var mediumDrink = Drink(typeOfDrink: "water", amountOfDrink: 500)
    var largeDrink  = Drink(typeOfDrink: "water", amountOfDrink: 750)
    var metric = true
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE - dd/MM/yy"
        return dateFormatter
    }()
    
    @IBOutlet weak var summaryLable: WKInterfaceLabel!
    
    @IBAction func smallButton() {
        let small = Measurement(value: Double(smallDrink.amount), unit: UnitVolume.milliliters)
        today.consumed.amount += Float(small.converted(to: .liters).value)
        updateSummary()
    }
    
    @IBAction func mediumButton() {
        let medium = Measurement(value: Double(mediumDrink.amount), unit: UnitVolume.milliliters)
        today.consumed.amount += Float(medium.converted(to: .liters).value)
        updateSummary()
    }
    
    @IBAction func largeButton() {
        let large = Measurement(value: Double(largeDrink.amount), unit: UnitVolume.milliliters)
        today.consumed.amount += Float(large.converted(to: .liters).value)
        updateSummary()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        days = Day.loadDays()
        //ask the phone for the goal and the consumed amount.
        
        today = days.updateToday()
        
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
        
        today = days.updateToday()
        
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            if session.activationState != .activated {
                session.activate()
            }
        }
        let delegate  = WKExtension.shared().delegate as! ExtensionDelegate
        delegate.days = days
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach({ (complication) in
            server.reloadTimeline(for: complication)
        })
        updateSummary()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        let delegate = WKExtension.shared().delegate as! ExtensionDelegate
        delegate.days = days
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach({ (complication) in
            server.reloadTimeline(for: complication)
        })
    }
    
    func updateSummary(){
        days.insertDay(today)
        let consumedAmount = Measurement(value: Double(today.consumed.amount), unit: UnitVolume.liters)
        let goalAmount = Measurement(value: Double(today.goal.amount), unit: UnitVolume.liters)
        if metric {
            summaryLable.setText("\(Float(consumedAmount.converted(to: .liters).value).clean)/\(Float(goalAmount.converted(to: .liters).value).clean)L")
        } else {
            summaryLable.setText("\(Float(consumedAmount.converted(to: .imperialPints).value).clean)/\(Float(goalAmount.converted(to: .imperialPints).value).clean)pt")
        }
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach({ (complication) in
            server.reloadTimeline(for: complication)
        })
        Day.saveDays(days)
        let consumed = String(today.consumed.amount)
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
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("sent data with transferUserInfo")
        print(String(describing: userInfo["phoneDate"]!))
        print(String(describing: userInfo["phoneGoal"]!))
        print(String(describing: userInfo["phoneConsumed"]!))
        formatter.dateFormat = "EEEE - dd/MM/yy"
        today = days.updateToday()
        if formatter.string(from: today.date) == userInfo["phoneDate"] as! String {
            let messageConsumed = userInfo["phoneConsumed"]!
            let numberFormatter = NumberFormatter()
            let consumed = numberFormatter.number(from: messageConsumed as! String)!.floatValue
            today.consumed.amount = consumed
            let messageGoal = userInfo["phoneGoal"]!
            let goal = numberFormatter.number(from: messageGoal as! String)!.floatValue
            today.goal.amount = goal
            
            let delegate = WKExtension.shared().delegate as! ExtensionDelegate
            delegate.days = self.days
            let server = CLKComplicationServer.sharedInstance()
            guard let activeComplications = server.activeComplications else { return }
            for complication in activeComplications {
                server.reloadTimeline(for: complication)
            }
            
            print("todays amount was updated with user info")
            DispatchQueue.main.async {
                self.days.insertDay(self.today)
                Day.saveDays(self.days)
                self.updateSummary()
            }
        }
    }
}

extension UIColor {
    /**
     Will convert an string of a hex color code to **UIColor**
     
     - parameter hex: - A **String** whit the hex color code.
     
     # Notes: #
     1. This will need an **String** in a hex coded style.
     
     # Example #
     ```
     let color: UIColor = hexStringToUIColor ("#212121")
     ```
     */
    func hexStringToUIColor(_ hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIImage {
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension Float {
    
    /**
     Will clean up a **Float** so that it has a maximum of 1 desimal
     
     - returns: the number as a **String** but cleand up
     
     # Example #
     ```
     let number1 = 3.122
     number1.clean // returns 3.1
     
     let number2 = 3.001
     number2.clean // returns 3
     ```
     */
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
