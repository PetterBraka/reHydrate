//
//  ViewController.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import HealthKit
import CoreData
import FSCalendar

class StartVC: UIViewController {
    @IBOutlet var lables: [UILabel]!
    @IBOutlet weak var currentDay: 			UILabel!
    @IBOutlet weak var historyButton: 		UIButton!
    @IBOutlet weak var optionsStack: 		UIStackView!
    @IBOutlet weak var aboutButton: 		UIButton!
    @IBOutlet weak var smallStack: 			UIStackView!
    @IBOutlet weak var mediumStack: 		UIStackView!
    @IBOutlet weak var largeStack: 			UIStackView!
    @IBOutlet weak var goalAmount: 			UILabel!
    @IBOutlet weak var consumedAmount: 		UILabel!
    @IBOutlet weak var smallOption: 		UIButton!
    @IBOutlet weak var smallOptionLabel: 	UILabel!
    @IBOutlet weak var mediumOption: 		UIButton!
    @IBOutlet weak var mediumOptionLabel: 	UILabel!
    @IBOutlet weak var largeOption: 		UIButton!
    @IBOutlet weak var largeOptionLabel: 	UILabel!
    
    let defaults 			= UserDefaults.standard
    var days: [Day] 		= []
    var today 				= Day.init()
    let formatter 			= DateFormatter()
    var darkMode			= Bool()
    
    var healthStore: 		HKHealthStore?
    var typesToShare: 		Set<HKSampleType> {
        let waterType 		= HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        return [waterType]
    }
    
    
    /**
     Will check which view that called this function
     
     - parameter sender: - **View** that called this function.
     
     */
    @objc func tap(_ sender: UIGestureRecognizer){
        let drink = Drink.init()
        switch sender.view {
        case smallOption:
            print("small short-press")
            let drinkAmount 		= getDrinkAmount(sender.view?.superview as! UIStackView)
            let drinkType 			= "water"
            drink.amountOfDrink 	= drinkAmount
            drink.typeOfDrink 		= drinkType
        case mediumOption:
            print("medium short-press")
            let drinkAmount 		= getDrinkAmount(sender.view?.superview as! UIStackView)
            let drinkType 			= "water"
            drink.amountOfDrink 	= drinkAmount
            drink.typeOfDrink 		= drinkType
        case largeOption:
            print("large short-press")
            let drinkAmount 		= getDrinkAmount(sender.view?.superview as! UIStackView)
            let drinkType 			= "water"
            drink.amountOfDrink 	= drinkAmount
            drink.typeOfDrink 		= drinkType
        default:
            break
        }
        updateConsumtion(drink)
    }
    
    /**
     Will check which button view that called the function.
     
     - parameter sender: - **view** that called this function.
     */
    @objc func long(_ sender: UIGestureRecognizer){
        if sender.state 	== .began {
            let drink 		= Drink.init()
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
                    textField.attributedPlaceholder 	= NSAttributedString(string: "Enter new value", attributes:[ NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    textField.font 						= UIFont(name: "American typewriter", size: 18)
                    textField.keyboardType 				= .decimalPad
                    textField.textAlignment 			= .center
                })
                let doneButton 							= UIAlertAction(title: "done" , style: .default) {_ in
                    let newGoal 						= (alert.textFields?.first!.text!)! as NSString
                    if newGoal 							!= "" {
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
    
    /**
     Will sett day to this day and if the day  is saved and then update UI.
     */
    @objc func didMoveToForground(){
        print("app enterd forground")
        changeAppearance()
        today = days.first(where: { formatter.string(from: $0.date) == formatter.string(from: Date.init()) }) ?? Day.init()
        if days.count 			< 0{
            today.goalAmount 	= days[days.count - 1].goalAmount
        } else {
            today.goalAmount 	= Drink.init(typeOfDrink: "water", amountOfDrink: 3)
        }
        loadDrinkOptions()
        updateUI()
        currentDay.text = formatter.string(from: Date.init())
    }
    
    /**
     Will open the settings page in full screen.
     
     - parameter sender: - **view** that called this function.
     
     # Notes: #
     1. This will only be called when the user click the settings button.
     
     */
    @IBAction func about(_ sender: UIButton) {
        let storyboard 							= UIStoryboard(name: "Main", bundle: nil)
        let aboutScreen 						= storyboard.instantiateViewController(withIdentifier: "about")
        aboutScreen.modalPresentationStyle 		= .fullScreen
        self.present(aboutScreen, animated: true, completion: nil)
    }
    
    /**
     Will open the calendar page in full screen.
     
     - parameter sender: - **view** that called this function.
  
     # Notes: #
     1. This will only be called when the user click the history button.
     
     */
    @IBAction func history(_ sender: UIButton) {
        let storyboard 							= UIStoryboard(name: "Main", bundle: nil)
        let calendarScreen 						= storyboard.instantiateViewController(withIdentifier: "calendar")
        calendarScreen.modalPresentationStyle 	= .fullScreen
        self.present(calendarScreen, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        
        //  Request access to write dietaryWater data to HealthStore
        self.healthStore?.requestAuthorization(toShare: typesToShare, read: nil, completion: { (success, error) in
            if (!success) {
                print("Was not authorization by the user")
                return
            }
        })
        changeAppearance()
        if UIApplication.isFirstLaunch() {
            print("first time to launch this app")
            let storyboard 						= UIStoryboard(name: "Main", bundle: nil)
            let aboutScreen 					= storyboard.instantiateViewController(withIdentifier: "about")
            aboutScreen.modalPresentationStyle 	= .fullScreen
            self.present(aboutScreen, animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didMoveToForground), name: UIApplication.willEnterForegroundNotification, object: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        changeAppearance()
    }
    
    func changeAppearance() {
        darkMode = UserDefaults.standard.bool(forKey: "darkMode")
        if darkMode == true {
            self.view.backgroundColor = hexStringToUIColor(hex: "#212121")
            aboutButton.tintColor = .lightGray
            historyButton.tintColor = .lightGray
            for lable in lables {
                lable.textColor = .white
            }
        } else {
            self.view.backgroundColor = .white
            historyButton.tintColor = .black
            aboutButton.tintColor = .black
            for lable in lables {
                lable.textColor = .black
            }
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
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
        let smallOptionTapGesture 		= UITapGestureRecognizer(target: self, action: #selector(tap))
        let smallOptionLongGesture 		= UILongPressGestureRecognizer(target: self, action: #selector(long))
        let mediumOptionTapGesture 		= UITapGestureRecognizer(target: self, action: #selector(tap))
        let mediumOptionLongGesture 	= UILongPressGestureRecognizer(target: self, action: #selector(long))
        let largeOptionTapGesture 		= UITapGestureRecognizer(target: self, action: #selector(tap))
        let largeOptionLongGesture 		= UILongPressGestureRecognizer(target: self, action: #selector(long))
        let changeGoalLongGesture 		= UILongPressGestureRecognizer(target: self, action: #selector(long))
        
        smallOptionLongGesture.minimumPressDuration 	= 0.2
        mediumOptionLongGesture.minimumPressDuration 	= 0.2
        largeOptionLongGesture.minimumPressDuration		= 0.2
        changeGoalLongGesture.minimumPressDuration 		= 0.2
        
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
                let label 			= view as! UILabel
                var stringAmount 	= label.text
                _ 					= stringAmount?.popLast()
                _ 					= stringAmount?.popLast()
                amount 				= Float(stringAmount!)!
            }
        }
        return convertToL(Double(amount))
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
        exportDrinkToHealth(Double(drinkConsumed.amountOfDrink), Date.init())
        var consumedL 								= Float(consumedAmount.text!)!
        consumedL 									+= Float(drinkConsumed.amountOfDrink)
        today.consumedAmount.amountOfDrink 			= consumedL
        if today.consumedAmount.amountOfDrink 		<= 0.0{
            today.consumedAmount.amountOfDrink 		= 0
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
     Updates the  in the UI
     
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
            goalAmount.text 		= String(format: "%.0f", today.goalAmount.amountOfDrink)
        } else {
            let stringFormatGoal 	= getStringFormat(today.goalAmount.amountOfDrink)
            goalAmount.text 		= String(format: stringFormatGoal, today.goalAmount.amountOfDrink)
        }
        let stringFormatConsumed 	= getStringFormat(today.consumedAmount.amountOfDrink)
        consumedAmount.text 		= String(format: stringFormatConsumed, today.consumedAmount.amountOfDrink)
    }
    
    /**
     Will create a popup window that will remove a drink or open a new popup window were you can edit a drink option. This function will update the labels.
     
     - parameter sender: -The **View** that called this function.
     - parameter drink: -The **Drink** you want to edit or remove.
     - parameter optionLabel: -The **UILable** corresponding to the drink.
     
     # Notes: #
     1. This should only be called when you want to give the user the option to edit or remove an drink.
     
     # Example #
     ```
     popUpOptions(sender, drink, mediumOptionLabel)
     ```
     */
    func popUpOptions(_ sender: UIGestureRecognizer, _ drink: Drink, _ optionLabel: UILabel) {
        let alerContorller 		= UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let editOption 			= UIAlertAction(title: "Edit option", style: .default) {_ in
            let editAlert 		= UIAlertController(title: "Change drink amount", message: nil, preferredStyle: .alert)
            editAlert.addTextField(configurationHandler: {(_ textField: UITextField) in
                textField.attributedPlaceholder = NSAttributedString(string: "Enter new value", attributes:[ NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                textField.font 				= UIFont(name: "American typewriter", size: 18)
                textField.keyboardType 		= .decimalPad
                textField.textAlignment 	= .center
            })
            let done = UIAlertAction(title: "done", style: .default) {_ in
                let newValue = (editAlert.textFields?.first!.text!)! as NSString
                if newValue != "" {
                    optionLabel.text = (editAlert.textFields?.first!.text!)! as String
                    optionLabel.text?.append("ml")
                    self.saveDrinkOptions()
                }
            }
            editAlert.addAction(done)
            self.present(editAlert, animated: true, completion: nil)
        }
        let removeAmount 			= UIAlertAction(title: "Remove drink", style: .default) {_ in
            let drinkAmount 		= -self.getDrinkAmount(sender.view?.superview as! UIStackView)
            let drinkType 			= "water"
            drink.amountOfDrink 	= drinkAmount
            drink.typeOfDrink 		= drinkType
            self.updateConsumtion(drink)
        }
        alerContorller.addAction(editOption)
        alerContorller.addAction(removeAmount)
        alerContorller.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alerContorller, animated: true, completion: nil)
    }
    
    /**
     Will export a drink to the health app
     
     - parameter waterAmount: - The amount of water the drink contains.
     - parameter date: -The date the drink was consumed.
     - warning: Will print an error if it wasn't able to export the drink, or if it was successfull.
     
     # Example #
     ```
     
     exportDrinkToHealth(200, Date.init())
     ```
     */
    func exportDrinkToHealth(_ waterAmount: Double, _ date: Date) {
        guard let dietaryWater = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else {
            fatalError("dietary water is no longer available in HealthKit")
        }
        let waterConsumed 			= HKQuantity(unit: HKUnit.liter(), doubleValue: waterAmount)
        let waterConsumedSample 	= HKQuantitySample(type: dietaryWater, quantity: waterConsumed,
                                                   start: date, end: date)
        HKHealthStore().save(waterConsumedSample) { (success, error) in
            if let error = error {
                print("Error Saving water consumtion: \(error.localizedDescription)")
            } else {
                print("Successfully saved water consumtion")
            }
        }
    }
    
    /**
     Will save each drink option to UserDefaults
     
     # Notes: #
     1. This function will save the labels of the drink options what ever they are.
     2. This should only be called after the user has change the value of a drink.
     
     # Example #
     ```
     saveDrinkOptions()
     ```
     */
    func saveDrinkOptions(){
        UserDefaults.standard.set(smallOptionLabel.text, 	forKey: "smallDrinkOption")
        UserDefaults.standard.set(mediumOptionLabel.text,	forKey: "mediumDrinkOption")
        UserDefaults.standard.set(largeOptionLabel.text, 	forKey: "largeDrinkOption")
    }
    
    /**
     Will load each of the drinking options from UserDefaults
     
     # Notes: #
     1. This function will load the trings coresponding to each button, but if the loaded value is empty it will use the default set.
     2. This should only be called when the app launches or are brought to the foreground.
     
     # Example #
     ```
     loadDrtinkOptions()
     ```
     */
    func loadDrinkOptions(){
        let small 		= UserDefaults.standard.string(forKey: "smallDrinkOption") 	?? ""
        let medium 		= UserDefaults.standard.string(forKey: "mediumDrinkOption") ?? ""
        let large 		= UserDefaults.standard.string(forKey: "largeDrinkOption") 	?? ""
        
        if small != "" && medium != "" && large != "" {
            smallOptionLabel.text 		= small
            mediumOptionLabel.text 		= medium
            largeOptionLabel.text 		= large
        }
    }
    
    /**
     Will return the number of digits in a float
     
     - parameter number: - A **Float** with unknown number of didgets.
     - returns: An **Int** with the number of digits
     
     # Example #
     ```
     String(format: "%.\(String(getNumberOfDigits(numberOfDigits)))f", number)
     ```
     */
    func getNumberOfDigits(_ number: Float)-> Int {
        var stringOfNumber = number.description
        if stringOfNumber.contains("."){
            while stringOfNumber.removeFirst() 	!= "." {
                let numberOfDigits 				= stringOfNumber.count - 1
                if numberOfDigits 				< 3 {
                    return numberOfDigits
                    
                } else {
                    return 2
                }
            }
        }
        return 0
    }
    
    /**
     Will return a **String** format for displaying the number of digets in a number, but it will not allow more than two.
     
     - parameter number: - The **Float** you want to use
     - returns: The **string** format
     
     # Example #
     ```
     let string = getStringFormat(3.14)
     ```
     */
    func getStringFormat(_ number: Float)-> String{
        return "%.\(String(getNumberOfDigits(number)))f"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(UIApplication.willEnterForegroundNotification)
    }
}

extension UIApplication {
    
    /**
     Will check if it is the first time the app is ever launched on this phone
     
     - returns: **Bool** true if its the first time false if not.
     
     # Example #
     ```
     if UIApplication.isFirstLaunch() {
         print("first time to launch this app")
         //Do something
     }
     ```
     */
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "firstTimeLaunched") {
            UserDefaults.standard.set(true, forKey: "firstTimeLaunched")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}
