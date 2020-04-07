//
//  ViewController.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import FSCalendar

class StartView: UIViewController {

    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var optionsStack: UIStackView!
    @IBOutlet weak var smallStack: UIStackView!
    @IBOutlet weak var mediumStack: UIStackView!
    @IBOutlet weak var largeStack: UIStackView!
    @IBOutlet weak var sumaryAndGoal: UIStackView!
    @IBOutlet weak var smallOption: UIButton!
    @IBOutlet weak var mediumOption: UIButton!
    @IBOutlet weak var largeOption: UIButton!
    
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
        switch sender.view {
        case smallOption:
            print("small short-press")
            let drinkAmount = getDrinkAmount(sender.view?.superview as! UIStackView)
            let drinkType = "water"
            let date = Date.init()
            let drink = Drink.init(drinkType, drinkAmount, date)
            updateConsumtion(drink)
        case mediumOption:
            print("medium short-press")
            let drinkAmount = getDrinkAmount(sender.view?.superview as! UIStackView)
            let drinkType = "water"
            let date = Date.init()
            let drink = Drink.init(drinkType, drinkAmount, date)
            updateConsumtion(drink)
        case largeOption:
            print("large short-press")
            let drinkAmount = getDrinkAmount(sender.view?.superview as! UIStackView)
            let drinkType = "water"
            let date = Date.init()
            let drink = Drink.init(drinkType, drinkAmount, date)
            updateConsumtion(drink)
        default:
            break
        }
    }
    
    @objc func long(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            switch sender.view {
            case smallOption:
                print("small long-press")
            case mediumOption:
                print("medium long-press")
            case largeOption:
                print("large long-press")
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd/MM/yy"
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
        
        settingsButton.layer.cornerRadius = 20
        settingsButton.layer.borderWidth = 3
        settingsButton.layer.borderColor = UIColor.darkGray.cgColor
        settingsButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func getDrinkAmount(_ optionStack: UIStackView)-> Int {
        var amount = Int.init()
        for view in optionStack.subviews {
            if view is UILabel{
                let label = view as! UILabel
                var stringAmount = label.text
                _ = stringAmount?.popLast()
                _ = stringAmount?.popLast()
                amount = Int(stringAmount!)!
            }
        }
        return amount
    }
    
    func updateConsumtion(_ consumedDrink: Drink) {
        for view in sumaryAndGoal.subviews {
            let label = view as! UILabel
            if label.tag == 1{
                var consumed = Double(label.text!)!
                let amount = Measurement(value: Double(consumedDrink.amountOfDrink), unit: UnitVolume.milliliters)
                consumed = amount.converted(to: UnitVolume.liters).value + Double(label.text!)!
                label.text = String(format: "%.1f", consumed)
            }
        }
    }

}

