//
//  ViewController.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import CoreData
import FSCalendar

class StartVC: UIViewController {
    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var optionsStack: UIStackView!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var smallStack: UIStackView!
    @IBOutlet weak var mediumStack: UIStackView!
    @IBOutlet weak var largeStack: UIStackView!
    @IBOutlet weak var goalAmount: UILabel!
    @IBOutlet weak var consumedAmount: UILabel!
    @IBOutlet weak var smallOption: UIButton!
    @IBOutlet weak var smallOptionLabel: UILabel!
    @IBOutlet weak var mediumOption: UIButton!
    @IBOutlet weak var mediumOptionLabel: UILabel!
    @IBOutlet weak var largeOption: UIButton!
    @IBOutlet weak var largeOptionLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var days: [Day] = []
    var today = Day.init()
    let formatter = DateFormatter()
    
    @objc func tap(_ sender: UIGestureRecognizer){
        let drink = Drink.init()
        switch sender.view {
        case smallOption:
            print("small short-press")
            let drinkAmount = getDrinkAmount(sender.view?.superview as! UIStackView)
            let drinkType = "water"
            drink.amountOfDrink = drinkAmount
            drink.typeOfDrink = drinkType
        case mediumOption:
            print("medium short-press")
            let drinkAmount = getDrinkAmount(sender.view?.superview as! UIStackView)
            let drinkType = "water"
            drink.amountOfDrink = drinkAmount
            drink.typeOfDrink = drinkType
        case largeOption:
            print("large short-press")
            let drinkAmount = getDrinkAmount(sender.view?.superview as! UIStackView)
            let drinkType = "water"
            drink.amountOfDrink = drinkAmount
            drink.typeOfDrink = drinkType
        default:
            break
        }
        updateConsumtion(drink)
    }
    
    @objc func long(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            let drink = Drink.init()
            switch sender.view {
            case smallOption:
                print("small long-press")
                popUpOptions(sender, drink, smallOptionLabel)
            case mediumOption:
                print("medium long-press")
                popUpOptions(sender, drink, mediumOptionLabel)
            case largeOption:
                print("large long-press")
                popUpOptions(sender, drink, largeOptionLabel)
            case goalAmount:
                let alert = UIAlertController(title: "Change goal", message: "Can you enter the amount you want as a goal in liters?", preferredStyle: .alert)
                alert.addTextField(configurationHandler: {(_ textField: UITextField) in
                    textField.attributedPlaceholder = NSAttributedString(string: "Enter new value", attributes:[ NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    textField.font = UIFont(name: "American typewriter", size: 18)
                    textField.keyboardType = .decimalPad
                    textField.textAlignment = .center
                })
                let doneButton = UIAlertAction(title: "done" , style: .default) {_ in
                    let newGoal = (alert.textFields?.first!.text!)! as NSString
                    if newGoal != "" {
                        self.today.goalAmount.amountOfDrink = newGoal.floatValue
                        self.updateUI()
                    }
                }
                alert.addAction(doneButton)
                self.present(alert, animated: true, completion: nil)
                
            default:
                break
            }
        }
    }
    
    @IBAction func about(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let aboutScreen = storyboard.instantiateViewController(withIdentifier: "about")
        aboutScreen.modalPresentationStyle = .fullScreen
        self.present(aboutScreen, animated: true, completion: nil)
    }
    
    @IBAction func history(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let calendarScreen = storyboard.instantiateViewController(withIdentifier: "calendar")
        calendarScreen.modalPresentationStyle = .fullScreen
        self.present(calendarScreen, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        if UIApplication.isFirstLaunch() {
            print("first time to launch this app")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let aboutScreen = storyboard.instantiateViewController(withIdentifier: "about")
            aboutScreen.modalPresentationStyle = .fullScreen
            self.present(aboutScreen, animated: true, completion: nil)
        } else {
        }
        
        //Too clean the UserDate use the code commented out
        
        //let domain = Bundle.main.bundleIdentifier!
        //UserDefaults.standard.removePersistentDomain(forName: domain)
        //UserDefaults.standard.synchronize()
        
        today.goalAmount.amountOfDrink = 3
        formatter.dateFormat = "EEEE - dd/MM/yy"
        days = Day.loadDay()
        for day in days {
            if formatter.string(from: day.date) == formatter.string(from: Date.init()){
                today = day
            }
        }
        updateUI()
        currentDay.text = formatter.string(from: Date.init())
        Thread.sleep(forTimeInterval: 0.5)
    }
    
    /**
     Setting upp the listeners and aperients of the buttons.
     
     # Example #
     ```
     override func viewDidLoad() {
     super.viewDidLoad()
     setUpButtons()
     }
     ```
     */
    func setUpButtons(){
        //setting up an gesture recognizer for each button.
        let smallOptionTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let smallOptionLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        smallOptionLongGesture.minimumPressDuration = 0.5
        
        let mediumOptionTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let mediumOptionLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        mediumOptionLongGesture.minimumPressDuration = 0.5
        
        let largeOptionTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let largeOptionLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        largeOptionLongGesture.minimumPressDuration = 0.5
        
        let changeGoalLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        changeGoalLongGesture.minimumPressDuration = 0.2
        
        //adding the gesture recognizer for each option.
        smallOption.addGestureRecognizer(smallOptionTapGesture)
        mediumOption.addGestureRecognizer(mediumOptionTapGesture)
        largeOption.addGestureRecognizer(largeOptionTapGesture)
        
        smallOption.addGestureRecognizer(smallOptionLongGesture)
        mediumOption.addGestureRecognizer(mediumOptionLongGesture)
        largeOption.addGestureRecognizer(largeOptionLongGesture)
        goalAmount.addGestureRecognizer(changeGoalLongGesture)
    }
    
    /**
     will return the amount off drink
     
     - parameter optionStack: - **UIStackView** containg the button and the label under the button.
     - returns: A **Float** with the amount.
     
     # Notes: #
     1. paramenters the **UIStackView** containg the button clicked on and the label describing the value of the button.
     
     # Example #
     ```
     let drinkAmount = getDrinkAmount(sender.view?.superview as! UIStackView)
     ```
     */
    func getDrinkAmount(_ optionStack: UIStackView)-> Float {
        var amount = Float.init()
        for view in optionStack.subviews {
            if view is UILabel{
                let label = view as! UILabel
                var stringAmount = label.text
                _ = stringAmount?.popLast()
                _ = stringAmount?.popLast()
                amount = Float(stringAmount!)!
            }
        }
        amount = convertToL(Double(amount))
        return amount
    }
    
    /**
     Converts an value parst inn of type **milliliters**
     
     - parameter milliliters: - An value in milliliters.
     - returns: A **Float** of the amount in liters
     
     # Notes: #
     1. Paramenters must be milliters. It will only convert from millilters to liters.
     
     # Example #
     ```
     amount = convertToL(Double(amount))
     ```
     */
    func convertToL(_ milliliters: Double) -> Float {
        var measurment = Measurement(value: milliliters, unit: UnitVolume.milliliters)
        measurment.convert(to: UnitVolume.liters)
        return Float(measurment.value)
    }
    
    /**
     Updates the amount consumed in the Day
     
     - parameter drinkConsumed: - The drink the user chose.
     
     # Notes: #
     1. Parameters Must be the drink being added to the day
     
     # Example #
     ```
     updateConsumtion(drink)
     ```
     */
    func updateConsumtion(_ drinkConsumed: Drink) {
        var consumedL = Float(consumedAmount.text!)!
        consumedL += Float(drinkConsumed.amountOfDrink)
        drinkConsumed.amountOfDrink = consumedL
        today.consumedAmount = drinkConsumed
        if today.consumedAmount.amountOfDrink <= 0.0{
            today.consumedAmount.amountOfDrink = 0
        }
        insertDay(today)
        updateUI()
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
        formatter.dateFormat = "EEEE - dd/MM/yy"
        if days.isEmpty {
            days.append(dayToInsert)
        } else {
            if days.contains(where: {formatter.string(from: $0.date) ==
                formatter.string(from: dayToInsert.date) }) {
                days[days.firstIndex(of: dayToInsert)!] = dayToInsert
            } else {
                days.append(dayToInsert)
            }
        }
    }
    
    /**
     Updates the consumed amount in the UI
     
     # Notes: #
     1. Should be called when the amount off drinks has been changed
     
     # Example #
     ```
     updateUI()
     ```
     */
    func updateUI(){
        Day.saveDay(days)
        if (today.goalAmount.amountOfDrink.rounded(.up) == today.goalAmount.amountOfDrink.rounded(.down)){
            goalAmount.text = String(format: "%.0f", today.goalAmount.amountOfDrink)
        } else {
            let stringFormatGoal = getStringFormat(today.goalAmount.amountOfDrink)
            goalAmount.text = String(format: stringFormatGoal, today.goalAmount.amountOfDrink)
        }
        let stringFormatConsumed = getStringFormat(today.consumedAmount.amountOfDrink)
        consumedAmount.text = String(format: stringFormatConsumed, today.consumedAmount.amountOfDrink)
    }
    
    func popUpOptions(_ sender: UIGestureRecognizer, _ drink: Drink, _ optionLabel: UILabel) {
        let alerContorller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let editOption = UIAlertAction(title: "Edit option", style: .default) {_ in
            let editAlert = UIAlertController(title: "Change drink amount", message: nil, preferredStyle: .alert)
            editAlert.addTextField(configurationHandler: {(_ textField: UITextField) in
                textField.attributedPlaceholder = NSAttributedString(string: "Enter new value", attributes:[ NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                textField.font = UIFont(name: "American typewriter", size: 18)
                textField.keyboardType = .decimalPad
                textField.textAlignment = .center
            })
            let done = UIAlertAction(title: "done", style: .default) {_ in
                let newValue = (editAlert.textFields?.first!.text!)! as NSString
                if newValue != "" {
                    optionLabel.text = (editAlert.textFields?.first!.text!)! as String
                    optionLabel.text?.append("ml")
                }
            }
            editAlert.addAction(done)
            self.present(editAlert, animated: true, completion: nil)
        }
        let removeAmount = UIAlertAction(title: "Remove drink", style: .default) {_ in
            let drinkAmount = -self.getDrinkAmount(sender.view?.superview as! UIStackView)
            let drinkType = "water"
            drink.amountOfDrink = drinkAmount
            drink.typeOfDrink = drinkType
            self.updateConsumtion(drink)
        }
        alerContorller.addAction(editOption)
        alerContorller.addAction(removeAmount)
        alerContorller.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alerContorller, animated: true, completion: nil)
    }
    
    func getNumberOfDecimalDigits(_ number: Float)-> Int {
        var stringOfNumber = number.description
        if stringOfNumber.contains("."){
            while stringOfNumber.removeFirst() != "." {
                let numberOfDigits = stringOfNumber.count - 1
                return numberOfDigits
            }
        }
        return 0
    }
    
    func getStringFormat(_ number: Float)-> String{
        return "%.\(String(getNumberOfDecimalDigits(number)))f"
    }
}

extension UIApplication {
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "firstTimeLaunched") {
            UserDefaults.standard.set(true, forKey: "firstTimeLaunched")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}
