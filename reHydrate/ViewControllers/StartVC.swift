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
    @IBOutlet weak var mediumOption: UIButton!
    @IBOutlet weak var largeOption: UIButton!
    
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
                let drinkAmount = -getDrinkAmount(sender.view?.superview as! UIStackView)
                let drinkType = "water"
                drink.amountOfDrink = drinkAmount
                drink.typeOfDrink = drinkType
            case mediumOption:
                print("medium long-press")
                let drinkAmount = -getDrinkAmount(sender.view?.superview as! UIStackView)
                let drinkType = "water"
                drink.amountOfDrink = drinkAmount
                drink.typeOfDrink = drinkType
            case largeOption:
                print("large long-press")
                let drinkAmount = -getDrinkAmount(sender.view?.superview as! UIStackView)
                let drinkType = "water"
                drink.amountOfDrink = drinkAmount
                drink.typeOfDrink = drinkType
            case goalAmount:
                let alert = UIAlertController(title: "Change goal", message: "Can you enter the amount you want as a goal in liters?", preferredStyle: .alert)
                alert.addTextField(configurationHandler: {(_ textField: UITextField) in
                    textField.attributedPlaceholder = NSAttributedString(string: "Enter new value", attributes:[ NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    textField.keyboardType = .decimalPad
                    textField.textAlignment = .center
                    textField.font = UIFont(name: "American typewriter", size: 18)
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
            updateConsumtion(drink)
        }
    }
    
    @IBAction func about(_ sender: Any) {
        let alert = UIAlertController(title: "error - about screen", message: "This option is not implemented yet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func history(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let calendarScreen = storyboard.instantiateViewController(withIdentifier: "calendar")
        calendarScreen.modalPresentationStyle = .fullScreen
        self.present(calendarScreen, animated: true, completion: nil)
    }
    
    /**
     This function will be called if the user press the done button and are finiched entering a value.
     
     # Notes: #
     it will call for handleInput and this will check for any updates in any of the text feilds.
     */
    @objc func doneClicked(){
        view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        
        //        Too clean the UserDate use the code commented out
        
        //        let domain = Bundle.main.bundleIdentifier!
        //        UserDefaults.standard.removePersistentDomain(forName: domain)
        //        UserDefaults.standard.synchronize()
        
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
        
        
        //giving the buttons the aperients
        historyButton.layer.cornerRadius = 20
        historyButton.layer.borderWidth = 3
        historyButton.layer.borderColor = UIColor.darkGray.cgColor
        historyButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        aboutButton.layer.cornerRadius = 20
        aboutButton.layer.borderWidth = 3
        aboutButton.layer.borderColor = UIColor.darkGray.cgColor
        aboutButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
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
        var consumedL = Double(consumedAmount.text!)!
        consumedL = Double(drinkConsumed.amountOfDrink) + Double(consumedAmount.text!)!
        drinkConsumed.amountOfDrink = Float(consumedL)
        today.consumedAmount = drinkConsumed
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
            goalAmount.text = String(format: "%.1f", today.goalAmount.amountOfDrink)
        }
        if today.consumedAmount.amountOfDrink <= 0 {
            consumedAmount.text = String(format: "%.0f", 0)
            today.consumedAmount.amountOfDrink = 0
        } else{
            if (today.consumedAmount.amountOfDrink.rounded(.up) == today.consumedAmount.amountOfDrink.rounded(.down)){
                consumedAmount.text = String(format: "%.0f",today.consumedAmount.amountOfDrink)
            } else {
                consumedAmount.text = String(format: "%.1f", today.consumedAmount.amountOfDrink)
            }
        }
    }
}
