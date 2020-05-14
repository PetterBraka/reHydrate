//
//  ViewController.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import HealthKit
import FSCalendar

class StartVC: UIViewController {
    
    //MARK: - Variables
    
    var appTitle: UILabel        = {
        let lable  = UILabel()
        lable.text = "reHydrate"
        lable.font = UIFont(name: "AmericanTypewriter-Bold", size: 50)
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var currentDay: UILabel      = {
        let lable  = UILabel()
        lable.text = "Day - dd/MM/yy"
        lable.font = UIFont(name: "AmericanTypewriter", size: 20)
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var consumedAmount: UILabel  = {
        let lable  = UILabel()
        lable.text = "0"
        lable.font = UIFont(name: "AmericanTypewriter-Bold", size: 35)
        lable.textAlignment = .right
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var summerySplitter: UILabel = {
        let lable  = UILabel()
        lable.text = "/"
        lable.font = UIFont(name: "AmericanTypewriter-Bold", size: 35)
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var goalAmount: UILabel      = {
        let lable  = UILabel()
        lable.text = "3"
        lable.font = UIFont(name: "AmericanTypewriter-Bold", size: 35)
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var goalPrefix: UILabel      = {
        let lable  = UILabel()
        lable.text = ""
        lable.font = UIFont(name: "AmericanTypewriter-Bold", size: 35)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var smallOption: UIButton    = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(named: "Cup"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .bottom
        return button
    }()
    var smallLabel: UILabel      = {
        let lable  = UILabel()
        lable.text = "300"
        lable.font = UIFont(name: "AmericanTypewriter", size: 17)
        lable.textAlignment = .right
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var smallPrefix: UILabel     = {
        let lable  = UILabel()
        lable.text = "ml"
        lable.font = UIFont(name: "AmericanTypewriter", size: 16)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var mediumOption: UIButton   = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(named: "Bottle"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .bottom
        return button
    }()
    var mediumLabel: UILabel     = {
        let lable  = UILabel()
        lable.text = "500"
        lable.font = UIFont(name: "AmericanTypewriter", size: 16)
        lable.textAlignment = .right
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var mediumPrefix: UILabel    = {
        let lable  = UILabel()
        lable.text = "ml"
        lable.font = UIFont(name: "AmericanTypewriter", size: 16)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var largeOption: UIButton    = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(named: "Flask"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .bottom
        return button
    }()
    var largeLabel: UILabel      = {
        let lable  = UILabel()
        lable.text = "750"
        lable.font = UIFont(name: "AmericanTypewriter", size: 16)
        lable.textAlignment = .right
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var largePrefix: UILabel     = {
        let lable  = UILabel()
        lable.text = "ml"
        lable.font = UIFont(name: "AmericanTypewriter", size: 16)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let drinkStack: UIStackView  = {
        let stack = UIStackView()
        stack.axis      = .horizontal
        stack.alignment = .bottom
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    var settingsButton: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "gear"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        return button
    }()
    var calendarButton: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "calendar.circle"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let defaults     = UserDefaults.standard
    var days: [Day]  = []
    var today        = Day.init()
    let formatter    = DateFormatter()
    var darkMode     = true
    var metricUnits  = true
    var drinkOptions = [Drink(typeOfDrink: "water", amountOfDrink: 300),
                        Drink(typeOfDrink: "water", amountOfDrink: 500),
                        Drink(typeOfDrink: "water", amountOfDrink: 750)]
    
    //MARK: - Touch controlls
    
    /**
     Will check which view that called this function
     
     - parameter sender: - **View** that called this function.
     # Notes: #
     1. case 1, 2, 3 will add that amount to the consumed amount
     2. case 4 will open the settings page in fullscreen
     3. case 5 will open the calendar page in fullscreen
     
     */
    @objc func tap(_ sender: UIGestureRecognizer){
        let drink = Drink.init()
        switch sender.view {
        case smallOption:
            print("small short-press")
            drink.amountOfDrink = drinkOptions[0].amountOfDrink
            updateConsumtion(drink)
        case mediumOption:
            print("medium short-press")
            drink.amountOfDrink = drinkOptions[1].amountOfDrink
            updateConsumtion(drink)
        case largeOption:
            print("large short-press")
            drink.amountOfDrink = drinkOptions[2].amountOfDrink
            updateConsumtion(drink)
        case settingsButton:
            let aboutScreen = SettingsVC()
            aboutScreen.modalPresentationStyle = .fullScreen
            let transition      = CATransition()
            transition.duration = 0.4
            transition.type     = .push
            transition.subtype  = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            present(aboutScreen, animated: false, completion: nil)
        case calendarButton:
            let calendarScreen  = CalendarVC()
            let transition      = CATransition()
            transition.duration = 0.4
            transition.type     = .push
            transition.subtype  = .fromRight
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            calendarScreen.modalPresentationStyle     = .fullScreen
            self.present(calendarScreen, animated: false, completion: nil)
        default:
            break
        }
    }
    
    /**
     Will check which button view that called the function.
     
     - parameter sender: - **view** that called this function.
     */
    @objc func long(_ sender: UIGestureRecognizer){
        if sender.state 	== .began {
            switch sender.view {
            case smallOption:
                print("small long-press")
                popUpOptions(sender, drinkOptions[0], smallLabel)
            case mediumOption:
                print("medium long-press")
                popUpOptions(sender, drinkOptions[1], mediumLabel)
            case largeOption:
                print("large long-press")
                popUpOptions(sender, drinkOptions[2], largeLabel)
            default:
                break
            }
        }
    }
    
    /**
     Will be called when the app enters the foreground. Then it will update the date for to saved data for this day or create a new instance of **Day**
     
     # Example #
     ```
     override func viewDidLoad() {
     	NotificationCenter.default.addObserver(self, selector: #selector(didMoveToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
     }
     ```
     */
    @objc func didMoveToForeground(){
        currentDay.text         = formatter.string(from: Date.init())
        days                    = Day.loadDay()
        if days.contains(where: {formatter.string(from: $0.date) == formatter.string(from: Date.init())}){
            today                 = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: Date.init())})!
        } else {
            today                 = Day.init()
            if !days.isEmpty {
                today.goalAmount     = days.last!.goalAmount
            }
            insertDay(today)
        }
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        formatter.dateFormat = "EEEE - dd/MM/yy"
        
        NotificationCenter.default.addObserver(self, selector: #selector(didMoveToForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        if UIApplication.isFirstLaunch() {
            print("first time to launch this app")
            metricUnits  = true
            UserDefaults.standard.set(metricUnits, forKey: "metricUnits")
            if self.traitCollection.userInterfaceStyle == .dark {
                darkMode = true
            } else {
                darkMode = false
            }
            let startDate = Calendar.current.date(bySettingHour: 8, minute: 00, second: 0, of: Date())!
            let endDate  = Calendar.current.date(bySettingHour: 23, minute: 00, second: 0, of: Date())!
            let intervals = 30
            UserDefaults.standard.set(startDate, forKey: "startignTime")
            UserDefaults.standard.set(endDate,   forKey: "endingTime")
            UserDefaults.standard.set(intervals, forKey: "reminderInterval")
            UserDefaults.standard.set(darkMode,  forKey: "darkMode")
        }
        setUpHealth()
        days = Day.loadDay()
        updateUI()
        Thread.sleep(forTimeInterval: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Main screen will appear")
        darkMode             = UserDefaults.standard.bool(forKey: "darkMode")
        metricUnits          = UserDefaults.standard.bool(forKey: "metricUnits")
        currentDay.text      = formatter.string(from: Date.init())
        days                 = Day.loadDay()
        if days.contains(where: {formatter.string(from: $0.date) == formatter.string(from: Date.init())}){
            today            = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: Date.init())})!
        } else if !days.isEmpty {
            today.goalAmount = days.last!.goalAmount
        } else {
            today            = Day.init()
            insertDay(today)
        }
        loadDrinkOptions()
        changeAppearance()
        updateUI()
    }
    
    func setUpUI(){
        
        createDrinkStack()
        self.view.addSubview(appTitle)
        self.view.addSubview(currentDay)
        self.view.addSubview(consumedAmount)
        self.view.addSubview(summerySplitter)
        self.view.addSubview(goalAmount)
        self.view.addSubview(goalPrefix)
        self.view.addSubview(drinkStack)
        self.view.addSubview(settingsButton)
        self.view.addSubview(calendarButton)
        setConstraints()
        setUpButtons()
        currentDay.text  = formatter.string(from: Date.init())
        smallLabel.text  = String(drinkOptions[0].amountOfDrink)
        mediumLabel.text = String(drinkOptions[1].amountOfDrink)
        largeLabel.text  = String(drinkOptions[2].amountOfDrink)
    }
    
    func setConstraints(){
        appTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                           = true
        appTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        currentDay.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive         = true
        currentDay.topAnchor.constraint(equalTo: appTitle.bottomAnchor, constant: 20).isActive = true
        
        summerySplitter.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10).isActive = true
        summerySplitter.topAnchor.constraint(equalTo: currentDay.bottomAnchor, constant: 5).isActive       = true
        
        consumedAmount.centerYAnchor.constraint(equalTo: summerySplitter.centerYAnchor).isActive = true
        consumedAmount.rightAnchor.constraint(equalTo: summerySplitter.leftAnchor).isActive      = true
        
        goalAmount.centerYAnchor.constraint(equalTo: summerySplitter.centerYAnchor).isActive = true
        goalAmount.leftAnchor.constraint(equalTo: summerySplitter.rightAnchor).isActive      = true
        
        goalPrefix.centerYAnchor.constraint(equalTo: summerySplitter.centerYAnchor).isActive = true
        goalPrefix.leftAnchor.constraint(equalTo: goalAmount.rightAnchor).isActive           = true
        
        smallOption.widthAnchor.constraint(equalToConstant:  50).isActive   = true
        smallOption.heightAnchor.constraint(equalToConstant: 75).isActive   = true
        
        mediumOption.widthAnchor.constraint(equalToConstant:   80).isActive = true
        mediumOption.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        largeOption.widthAnchor.constraint(equalToConstant:  90).isActive   = true
        largeOption.heightAnchor.constraint(equalToConstant: 160).isActive  = true
        
        drinkStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                = true
        drinkStack.topAnchor.constraint(lessThanOrEqualTo: summerySplitter.bottomAnchor, constant: 80).isActive = true
        
        settingsButton.widthAnchor.constraint(equalToConstant: 50).isActive  = true
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive      = true
        settingsButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        
        calendarButton.widthAnchor.constraint(equalToConstant: 50).isActive  = true
        calendarButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        calendarButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive   = true
        calendarButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        
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
        let settingsTapGesture       = UITapGestureRecognizer(target: self, action: #selector(tap))
        let calendarTapGesture       = UITapGestureRecognizer(target: self, action: #selector(tap))
        let smallOptionTapGesture    = UITapGestureRecognizer(target: self, action: #selector(tap))
        let mediumOptionTapGesture   = UITapGestureRecognizer(target: self, action: #selector(tap))
        let largeOptionTapGesture    = UITapGestureRecognizer(target: self, action: #selector(tap))
        let smallOptionLongGesture   = UILongPressGestureRecognizer(target: self, action: #selector(long))
        let mediumOptionLongGesture  = UILongPressGestureRecognizer(target: self, action: #selector(long))
        let largeOptionLongGesture   = UILongPressGestureRecognizer(target: self, action: #selector(long))
        
        
        smallOptionLongGesture.minimumPressDuration  = 0.2
        mediumOptionLongGesture.minimumPressDuration = 0.2
        largeOptionLongGesture.minimumPressDuration     = 0.2
        
        //adding the gesture recognizer for each option.
        settingsButton.addGestureRecognizer(settingsTapGesture)
        calendarButton.addGestureRecognizer(calendarTapGesture)
        smallOption.addGestureRecognizer(smallOptionTapGesture)
        mediumOption.addGestureRecognizer(mediumOptionTapGesture)
        largeOption.addGestureRecognizer(largeOptionTapGesture)
        
        smallOption.addGestureRecognizer(smallOptionLongGesture)
        mediumOption.addGestureRecognizer(mediumOptionLongGesture)
        largeOption.addGestureRecognizer(largeOptionLongGesture)
    }
    
    fileprivate func createDrinkStack(){
        let smallStack: UIStackView = {
            let stack       = UIStackView()
            stack.axis      = .vertical
            stack.alignment = .center
            return stack
        }()
        let smallLableStack: UIStackView = {
            let stack       = UIStackView()
            stack.axis      = .horizontal
            stack.alignment = .bottom
            stack.distribution = .fillProportionally
            return stack
        }()
        smallLableStack.addArrangedSubview(smallLabel)
        smallLableStack.addArrangedSubview(smallPrefix)
        smallStack.addArrangedSubview(smallOption)
        smallStack.addArrangedSubview(smallLableStack)
        let mediumStack: UIStackView = {
            let stack       = UIStackView()
            stack.axis      = .vertical
            stack.alignment = .center
            return stack
        }()
        let mediumLableStack: UIStackView = {
            let stack       = UIStackView()
            stack.axis      = .horizontal
            stack.alignment = .center
            stack.distribution = .fillProportionally
            return stack
        }()
        mediumLableStack.addArrangedSubview(mediumLabel)
        mediumLableStack.addArrangedSubview(mediumPrefix)
        mediumStack.addArrangedSubview(mediumOption)
        mediumStack.addArrangedSubview(mediumLableStack)
        let largeStack: UIStackView = {
            let stack       = UIStackView()
            stack.axis      = .vertical
            stack.alignment = .center
            stack.distribution = .equalCentering
            return stack
        }()
        let largeLableStack: UIStackView = {
            let stack       = UIStackView()
            stack.axis      = .horizontal
            stack.alignment = .bottom
            stack.distribution = .fillProportionally
            return stack
        }()
        largeLableStack.addArrangedSubview(largeLabel)
        largeLableStack.addArrangedSubview(largePrefix)
        largeStack.addArrangedSubview(largeOption)
        largeStack.addArrangedSubview(largeLableStack)
        drinkStack.addArrangedSubview(smallStack)
        drinkStack.addArrangedSubview(mediumStack)
        drinkStack.addArrangedSubview(largeStack)
    }
    
    //MARK: - HealthKit
    
    fileprivate func setUpHealth() {
        //  Request access to write dietaryWater data to HealthStore
        if HKHealthStore.isHealthDataAvailable(){
            let healthStore = HKHealthStore()
            var typesToShare: Set<HKSampleType> {
                let waterType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
                return [waterType]
            }
            healthStore.requestAuthorization(toShare: typesToShare, read: nil, completion: { (success, error) in
                if (!success) {
                    print("Was not authorization by the user")
                    return
                }
            })
        }
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
        guard let dietaryWater     = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else {
            fatalError("dietary water is no longer available in HealthKit")
        }
        let waterConsumed       = HKQuantity(unit: HKUnit.liter(), doubleValue: waterAmount)
        let waterConsumedSample = HKQuantitySample(type: dietaryWater, quantity: waterConsumed,
                                                   start: date, end: date)
        HKHealthStore().save(waterConsumedSample) { (success, error) in
            if let error = error {
                print("Error Saving water consumtion: \(error.localizedDescription)")
            } else {
                print("Successfully saved water consumtion")
            }
        }
    }
    
    //MARK: - Change appearance
    
    /**
     Changing the appearance of the app deppending on if the users prefrence for dark mode or light mode.
     
     # Notes: #
     1. This will change all the colors off this screen.
     
     # Example #
     ```
     changeAppearance()
     ```
     */
    func changeAppearance() {
        if darkMode == true {
            self.view.backgroundColor         = hexStringToUIColor(hex: "#212121")
            appTitle.textColor                = .white
            currentDay.textColor              = .white
            consumedAmount.textColor          = .white
            summerySplitter.textColor         = .white
            goalAmount.textColor              = .white
            goalPrefix.textColor              = .white
            smallLabel.textColor        = .white
            smallPrefix.textColor  = .white
            mediumLabel.textColor       = .white
            mediumPrefix.textColor = .white
            largeLabel.textColor        = .white
            largePrefix.textColor  = .white
            settingsButton.tintColor             = .lightGray
            calendarButton.tintColor           = .lightGray
        } else {
            self.view.backgroundColor = .white
            appTitle.textColor                = .black
            currentDay.textColor              = .black
            consumedAmount.textColor          = .black
            summerySplitter.textColor         = .black
            goalAmount.textColor              = .black
            goalPrefix.textColor              = .black
            smallLabel.textColor        = .black
            smallPrefix.textColor  = .black
            mediumLabel.textColor       = .black
            mediumPrefix.textColor = .black
            largeLabel.textColor        = .black
            largePrefix.textColor  = .black
            calendarButton.tintColor           = .black
            settingsButton.tintColor             = .black
        }
    }
    
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
    
    //MARK: - Update View
    
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
        let drinkAmount  = Measurement(value: Double(drinkConsumed.amountOfDrink), unit: UnitVolume.milliliters)
        let drink        = Drink(typeOfDrink: "water", amountOfDrink: Float(drinkAmount.converted(to: .liters).value))
        exportDrinkToHealth(Double(drink.amountOfDrink), Date.init())
        today.consumedAmount.amountOfDrink     += drink.amountOfDrink
        if today.consumedAmount.amountOfDrink  <= 0.0{
            today.consumedAmount.amountOfDrink  = 0
        } else {
            
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
        let day = Day()
        let goalAmount     = Measurement(value: Double(today.goalAmount.amountOfDrink), unit: UnitVolume.liters)
        let consumedAmount = Measurement(value: Double(today.consumedAmount.amountOfDrink), unit: UnitVolume.liters)
        let smallDrink 	   = Measurement(value: Double(drinkOptions[0].amountOfDrink), unit: UnitVolume.milliliters)
        let mediumDrink    = Measurement(value: Double(drinkOptions[1].amountOfDrink), unit: UnitVolume.milliliters)
        let largeDrink 	   = Measurement(value: Double(drinkOptions[2].amountOfDrink), unit: UnitVolume.milliliters)
        if metricUnits {
            day.goalAmount.amountOfDrink     = Float(goalAmount.converted(to: .liters).value)
            day.consumedAmount.amountOfDrink = Float(consumedAmount.converted(to: .liters).value)
            let roundedSmallDrink            = smallDrink.converted(to: .milliliters).value.rounded()
            let roundedMediumDrink           = mediumDrink.converted(to: .milliliters).value.rounded()
            let roundedLargeDrink            = largeDrink.converted(to: .milliliters).value.rounded()
            smallLabel.text            = String(format: "%.0f", roundedSmallDrink)
            mediumLabel.text           = String(format: "%.0f", roundedMediumDrink)
            largeLabel.text            = String(format: "%.0f", roundedLargeDrink)
        } else {
            day.goalAmount.amountOfDrink     = Float(goalAmount.converted(to: .imperialPints).value)
            day.consumedAmount.amountOfDrink = Float(consumedAmount.converted(to: .imperialPints).value)
            let small                        = smallDrink.converted(to: .imperialFluidOunces).value
            let medium                       = mediumDrink.converted(to: .imperialFluidOunces).value
            let large                        = largeDrink.converted(to: .imperialFluidOunces).value
            smallLabel.text            = String(format: "%.2f", small)
            mediumLabel.text           = String(format: "%.2f", medium)
            largeLabel.text            = String(format: "%.2f", large)
        }
        
        if (today.goalAmount.amountOfDrink.rounded(.up) == day.goalAmount.amountOfDrink.rounded(.down)){
            self.goalAmount.text  = String(format: "%.0f", day.goalAmount.amountOfDrink)
        } else {
            let stringFormatGoal  = getStringFormat(day.goalAmount.amountOfDrink)
            self.goalAmount.text  = String(format: stringFormatGoal, day.goalAmount.amountOfDrink)
        }
        
        let stringFormatConsumed  = getStringFormat(today.consumedAmount.amountOfDrink)
        self.consumedAmount.text  = String(format: stringFormatConsumed, day.consumedAmount.amountOfDrink)
        if metricUnits {
            smallPrefix.text  = "\(UnitVolume.milliliters.symbol)"
            mediumPrefix.text = "\(UnitVolume.milliliters.symbol)"
            largePrefix.text  = "\(UnitVolume.milliliters.symbol)"
            goalPrefix.text              = "\(UnitVolume.liters.symbol)"
        } else {
            smallPrefix.text  = "\(UnitVolume.imperialFluidOunces.symbol)"
            mediumPrefix.text = "\(UnitVolume.imperialFluidOunces.symbol)"
            largePrefix.text  = "\(UnitVolume.imperialFluidOunces.symbol)"
            goalPrefix.text              = "\(UnitVolume.imperialPints.symbol)"
        }
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
        let alerContorller  = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let editOption      = UIAlertAction(title: "Edit option", style: .default) {_ in
            let editAlert   = UIAlertController(title: "Change drink amount", message: nil, preferredStyle: .alert)
            editAlert.addTextField(configurationHandler: {(_ textField: UITextField) in
                textField.attributedPlaceholder = NSAttributedString(string: "Enter new value", attributes:[ NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                textField.font          = UIFont(name: "American typewriter", size: 18)
                textField.keyboardType  = .decimalPad
                textField.textAlignment = .center
            })
            let done = UIAlertAction(title: "Done", style: .default) {_ in
                let newValue = (editAlert.textFields?.first!.text!)! as String
                if newValue != "" {
                    if self.metricUnits {
                        let drinkAmount = Measurement(value: Double(newValue)!, unit: UnitVolume.milliliters).converted(to: .milliliters)
                        switch optionLabel {
                            case self.smallLabel:
                                self.drinkOptions[0].amountOfDrink = Float(drinkAmount.value)
                            case self.mediumLabel:
                                self.drinkOptions[1].amountOfDrink = Float(drinkAmount.value)
                            case self.largeLabel:
                                self.drinkOptions[2].amountOfDrink = Float(drinkAmount.value)
                            default:
                                break
                        }
                    } else {
                            let drinkAmount = Measurement(value: Double(newValue)!, unit: UnitVolume.imperialFluidOunces)
                                .converted(to: .milliliters)
                            switch optionLabel {
                                case self.smallLabel:
                                    self.drinkOptions[0].amountOfDrink = Float(drinkAmount.value)
                                case self.mediumLabel:
                                    self.drinkOptions[1].amountOfDrink = Float(drinkAmount.value)
                                case self.largeLabel:
                                    self.drinkOptions[2].amountOfDrink = Float(drinkAmount.value)
                                default:
                                    break
                            }
                        }
                    self.saveDrinkOptions()
                }
            }
            editAlert.addAction(done)
            self.present(editAlert, animated: true, completion: nil)
        }
        let removeAmount    = UIAlertAction(title: "Remove drink", style: .default) {_ in
            let removeDrink = Drink.init(typeOfDrink: "water", amountOfDrink: -drink.amountOfDrink)
            self.updateConsumtion(removeDrink)
        }
        alerContorller.addAction(editOption)
        alerContorller.addAction(removeAmount)
        alerContorller.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alerContorller, animated: true, completion: nil)
    }
    
    //MARK: - Save and Load
    
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
        UserDefaults.standard.set(drinkOptions[0].amountOfDrink, forKey: "smallDrinkOption")
        UserDefaults.standard.set(drinkOptions[1].amountOfDrink, forKey: "mediumDrinkOption")
        UserDefaults.standard.set(drinkOptions[2].amountOfDrink, forKey: "largeDrinkOption")
        updateUI()
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
        let small   = UserDefaults.standard.float(forKey: "smallDrinkOption")
        let medium  = UserDefaults.standard.float(forKey: "mediumDrinkOption")
        let large   = UserDefaults.standard.float(forKey: "largeDrinkOption")
        
        
        if small != 0 || medium != 0 || large != 0  {
            drinkOptions[0] = Drink(typeOfDrink: "water", amountOfDrink: Float(small))
            drinkOptions[1] = Drink(typeOfDrink: "water", amountOfDrink: Float(medium))
            drinkOptions[2] = Drink(typeOfDrink: "water", amountOfDrink: Float(large))
        }
    }
    
    //MARK: - String formatting
    
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
            while stringOfNumber.removeFirst() != "." {
                let numberOfDigits = stringOfNumber.count - 1
                if numberOfDigits  < 3 {
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
        if !UserDefaults.standard.bool(forKey: "version1.7") {
            UserDefaults.standard.set(true, forKey: "version1.7")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}
