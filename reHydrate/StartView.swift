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

class StartView: UIViewController {
    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var optionsStack: UIStackView!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var smallStack: UIStackView!
    @IBOutlet weak var mediumStack: UIStackView!
    @IBOutlet weak var largeStack: UIStackView!
    @IBOutlet weak var consumedAmount: UILabel!
    @IBOutlet weak var goalAmount: UILabel!
    @IBOutlet weak var smallOption: UIButton!
    @IBOutlet weak var mediumOption: UIButton!
    @IBOutlet weak var largeOption: UIButton!
    
    let defaults = UserDefaults.standard
    var today = Day.init()
    
    
    @IBAction func about(_ sender: Any) {
        let alert = UIAlertController(title: "error", message: "This option is not implemented yet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func history(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let calendarScreen = storyboard.instantiateViewController(withIdentifier: "calendar")
        calendarScreen.modalPresentationStyle = .fullScreen
        self.present(calendarScreen, animated: true, completion: nil)
    }
    
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
            default:
                break
            }
            updateConsumtion(drink)
        }
    }
    
    @objc func appMovedToBackground(){
        defaults.set(Date.init(), forKey: "date")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationsCenter = NotificationCenter.default
        notificationsCenter.addObserver(self, selector: #selector(appMovedToBackground),
                                        name: UIApplication.willEnterForegroundNotification, object: nil)
        setUpButtons()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd/mm/yy"
        let dateSaved = defaults.value(forKey: "date") as? Date ?? Date.init()
        if formatter.string(from: Date.init()) == formatter.string(from: dateSaved) {
            today.loadDay()
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
        
        //adding the gesture recognizer for each option.
        smallOption.addGestureRecognizer(smallOptionTapGesture)
        mediumOption.addGestureRecognizer(mediumOptionTapGesture)
        largeOption.addGestureRecognizer(largeOptionTapGesture)

        smallOption.addGestureRecognizer(smallOptionLongGesture)
        mediumOption.addGestureRecognizer(mediumOptionLongGesture)
        largeOption.addGestureRecognizer(largeOptionLongGesture)
        
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
    
    func convertToL(_ milliliters: Double) -> Float {
        var measurment = Measurement(value: milliliters, unit: UnitVolume.milliliters)
        measurment.convert(to: UnitVolume.liters)
        return Float(measurment.value)
    }
    
    func updateConsumtion(_ drinkConsumed: Drink) {
        var consumedL = Double(consumedAmount.text!)!
        consumedL = Double(drinkConsumed.amountOfDrink) + Double(consumedAmount.text!)!
        drinkConsumed.amountOfDrink = Float(consumedL)
        today.consumedAmount = drinkConsumed
        updateUI()
    }
    
    func updateUI(){
        today.saveDay()
        if today.consumedAmount.amountOfDrink <= 0 {
            consumedAmount.text = "0"
        } else{
            consumedAmount.text = String(format: "%.1f",today.consumedAmount.amountOfDrink)
        }
    }
}
