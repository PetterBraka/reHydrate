//
//  ViewController.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import SwiftUI
import CloudKit
import CoreData
import HealthKit
import WatchConnectivity

let versionString = "version4.1"
let appleLanguagesString = "AppleLanguages"

let darkModeString          = "darkMode"
let metricUnitsString       = "metricUnits"
let startingTimeString      = "startignTime"
let endingTimeString        = "endingTime"
let remindersString         = "reminders"
let reminderIntervalString  = "reminderInterval"
let smallDrinkOptionString  = "smallDrinkOption"
let mediumDrinkOptionString = "mediumDrinkOption"
let largeDrinkOptionString  = "largeDrinkOption"

let appLanguages = ["en", "nb"]

class StartVC: UIViewController, UNUserNotificationCenterDelegate {
    
    //MARK: - Variables
    
    var appTitle: UILabel         = {
        let lable  = UILabel()
        lable.text = "reHydrate"
        lable.font = UIFont(name: "AmericanTypewriter-Bold", size: 50)
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var currentDay: UILabel       = {
        let lable  = UILabel()
        lable.text = "Day - dd/MM/yy"
        lable.font = UIFont(name: "AmericanTypewriter", size: 20)
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var consumedAmount: UILabel   = {
        let lable  = UILabel()
        lable.text = "0"
        lable.font = UIFont(name: "AmericanTypewriter-Bold", size: 35)
        lable.textAlignment = .right
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var summarySplitter: UILabel  = {
        let lable  = UILabel()
        lable.text = "/"
        lable.font = UIFont(name: "AmericanTypewriter-Bold", size: 35)
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var goalAmount: UILabel       = {
        let lable  = UILabel()
        lable.text = "3"
        lable.font = UIFont(name: "AmericanTypewriter-Bold", size: 35)
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var goalPrefix: UILabel       = {
        let lable  = UILabel()
        lable.text = ""
        lable.font = UIFont(name: "AmericanTypewriter-Bold", size: 35)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var summaryStack: UIStackView = {
        let stack = UIStackView()
        stack.axis      = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    var smallOption: UIButton     = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(named: "Cup"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .bottom
        return button
    }()
    var smallLabel: UILabel       = {
        let lable  = UILabel()
        lable.text = "300"
        lable.font = UIFont(name: "AmericanTypewriter", size: 17)
        lable.textAlignment = .right
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var smallPrefix: UILabel      = {
        let lable  = UILabel()
        lable.text = "ml"
        lable.font = UIFont(name: "AmericanTypewriter", size: 16)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var mediumOption: UIButton    = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(named: "Bottle"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .bottom
        return button
    }()
    var mediumLabel: UILabel      = {
        let lable  = UILabel()
        lable.text = "500"
        lable.font = UIFont(name: "AmericanTypewriter", size: 16)
        lable.textAlignment = .right
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var mediumPrefix: UILabel     = {
        let lable  = UILabel()
        lable.text = "ml"
        lable.font = UIFont(name: "AmericanTypewriter", size: 16)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var largeOption: UIButton     = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(named: "Flask"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .bottom
        return button
    }()
    var largeLabel: UILabel       = {
        let lable  = UILabel()
        lable.text = "750"
        lable.font = UIFont(name: "AmericanTypewriter", size: 16)
        lable.textAlignment = .right
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var largePrefix: UILabel      = {
        let lable  = UILabel()
        lable.text = "ml"
        lable.font = UIFont(name: "AmericanTypewriter", size: 16)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let drinkStack: UIStackView   = {
        let stack = UIStackView()
        stack.axis      = .horizontal
        stack.alignment = .bottom
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    var settingsButton: UIButton  = {
        var button = UIButton()
        if #available(iOS 13.0, *) {
            button.setBackgroundImage(UIImage(systemName: "gear"), for: .normal)
        } else {
            button.setBackgroundImage(UIImage(named: "gear")?.colored(.gray), for: .normal)
        }
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .center
        return button
    }()
    var calendarButton: UIButton  = {
        var button = UIButton()
        if #available(iOS 13.0, *) {
            button.setBackgroundImage(UIImage(systemName: "calendar.circle"), for: .normal)
        } else {
            button.setBackgroundImage(UIImage(named: "calendar.circle")?.colored(.gray), for: .normal)
        }
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .center
        return button
    }()
    
    let defaults     = UserDefaults.standard
    let context      = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let formatter    = DateFormatter()
    var darkMode     = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return darkMode ? .lightContent : .darkContent
        } else {
            return .default
        }
    }
    var metricUnits  = true
    var drinkOptions = [Double(300), Double(500), Double(750)]
    var days: [Day] = []
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
        var drink = Double()
        switch sender.view {
        case smallOption:
            print("small short-press")
            drink = drinkOptions[0]
            updateConsumtion(drink)
        case mediumOption:
            print("medium short-press")
            drink = drinkOptions[1]
            updateConsumtion(drink)
        case largeOption:
            print("large short-press")
            drink = drinkOptions[2]
            updateConsumtion(drink)
        case settingsButton:
            let aboutScreen = SettingsVC()
            let transition      = CATransition()
            transition.duration = 0.4
            transition.type     = .push
            transition.subtype  = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            aboutScreen.modalPresentationStyle = .fullScreen
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
     
     # Notes: #
     1. case 1, 2, 3 and will ask the usr if the user wants to change or remove a drink from the consumed amount.
     */
    @objc func long(_ sender: UIGestureRecognizer){
        if sender.state     == .began {
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
    
    //MARK: - ViewDid
    
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
        currentDay.text = formatter.string(from: Date.init()).localizedCapitalized
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDrinkStack()
        createSummaryStack()
        
        formatter.dateFormat = "EEEE - dd/MM/yy"
        let local = defaults.array(forKey: appleLanguagesString)
        formatter.locale = Locale(identifier: local?.first as! String)
        
        if UIApplication.isFirstLaunch() {
            print("first time to launch this version of the app")
            metricUnits  = true
            defaults.set(metricUnits, forKey: metricUnitsString)
            if self.traitCollection.userInterfaceStyle == .dark {
                darkMode = true
            } else {
                darkMode = false
            }
            defaults.set(darkMode,  forKey: darkModeString)
            saveDrinkOptions()
            let language = UserDefaults.standard.array(forKey: appleLanguagesString) as! [String]
            if !appLanguages.contains(language[0]){
                setAppLanguage(appLanguages[0])
            }
            setUpRequests()
            //sets default values for reminders
            let startDate = Calendar.current.date(bySettingHour: 8, minute: 00, second: 0, of: Date())!
            let endDate   = Calendar.current.date(bySettingHour: 23, minute: 00, second: 0, of: Date())!
            let intervals = 30
            self.defaults.set(startDate, forKey: startingTimeString)
            self.defaults.set(endDate,   forKey: endingTimeString)
            self.defaults.set(intervals, forKey: reminderIntervalString)
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus == .authorized {
                    current.removeAllPendingNotificationRequests()
                    setReminders(startDate, endDate, intervals)
                }
            })
        }
        
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings { (notificationSetting) in
            if notificationSetting.authorizationStatus == .authorized {
                current.delegate = self
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didMoveToForeground),name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            if session.activationState != .activated {
                session.activate()
            }
        }
        
        updateUI()
    }
    
    //MARK: - ViewWill
    
    override func viewWillAppear(_ animated: Bool) {
        darkMode        = defaults.bool(forKey: darkModeString)
        metricUnits     = defaults.bool(forKey: metricUnitsString)
        currentDay.text = formatter.string(from: Date.init()).localizedCapitalized
        loadDrinkOptions()
        setUpUI()
        changeAppearance()
        updateUI()
        // Checks if Watch comunications is supported.
        if WCSession.isSupported(){
            if WCSession.default.activationState != .activated {
                WCSession.default.activate()
            }
        }
        #if DEBUG
        print("Main screen will appear")
        let current = UNUserNotificationCenter.current()
        current.getPendingNotificationRequests { (notificationRequest) in
            print("pending notification: \(notificationRequest.count)")
        }
        #endif
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let today = fetchToday()
        #if DEBUG
        print("View will disappear")
        let current = UNUserNotificationCenter.current()
        current.getPendingNotificationRequests { (notificationRequest) in
            print("pending notification: \(notificationRequest.count)")
        }
        #endif
        if WCSession.isSupported(){
            let message = ["phoneDate": formatter.string(from: today.date),
                           "phoneGoal": String(today.goal),
                           "phoneConsumed": String(today.consumed),
                           "phoneDrinks": "\(drinkOptions[0]),\(drinkOptions[1]),\(drinkOptions[2])"]
            WCSession.default.transferCurrentComplicationUserInfo(message)
        }
    }
    
    //MARK: - Load and Save days
    
    func fetchDays() {
        do {
            self.days = try self.context.fetch(Day.fetchRequest())
        } catch {
            print("can't featch days")
            print(error.localizedDescription)
        }
    }
    
    func saveDays() {
        do {
            try self.context.save()
        } catch {
            print("can't save days")
            print(error.localizedDescription)
        }
    }
    
    /// Will get a day representing data for the current day. It will also set the goal to be the same as the goal from the previous day.
    /// - Returns: The day found to be equal to todays date.
    func fetchToday() -> Day {
        do {
            let request = Day.fetchRequest() as NSFetchRequest
            // Get today's beginning & tomorrows beginning time
            let dateFrom = Calendar.current.startOfDay(for: Date())
            let dateTo = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)
            // Sets conditions for date to be within today
            let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
            let toPredicate = NSPredicate(format: "date < %@", dateTo! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request.predicate = datePredicate
            // tries to get the day out of the array.
            let loadedDays = try self.context.fetch(request)
            // If today wasn't found it will create a new day.
            guard let today = loadedDays.first else {
                let today = Day(context: self.context)
                today.date = Date()
                today.goal = 3
                return today }
            return today
        } catch {
            print("can't featch day")
            print(error.localizedDescription)
            // If the loading of data fails, we create a new day
            let today = Day(context: self.context)
            today.date = Date()
            today.goal = 3
            return today
        }
    }
    
    //MARK: - Set up of UI
    /**
     Will set up the UI and must be called when the view will appear.
     
     # Example #
     ```
     setUpUI()
     ```
     */
    func setUpUI(){
        for view in self.view.subviews{
            view.removeFromSuperview()
        }
        //Adding the views
        self.view.addSubview(appTitle)
        self.view.addSubview(currentDay)
        self.view.addSubview(summaryStack)
        self.view.addSubview(drinkStack)
        self.view.addSubview(settingsButton)
        self.view.addSubview(calendarButton)
        setConstraints()
        setUpButtons()
        currentDay.text  = formatter.string(from: Date.init()).localizedCapitalized
        smallLabel.text  = String(drinkOptions[0])
        mediumLabel.text = String(drinkOptions[1])
        largeLabel.text  = String(drinkOptions[2])
    }
    
    /**
     Will sett the constraints for all the views in the view.
     
     # Notes: #
     1. The setUPUI must be called first and add all of the views.
     
     # Example #
     ```
     override func viewDidLoad() {
     super.viewDidLoad()
     createDrinkStack()
     }
     ```
     */
    func setConstraints(){
        
        appTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                           = true
        appTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        currentDay.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive         = true
        currentDay.topAnchor.constraint(equalTo: appTitle.bottomAnchor, constant: 20).isActive = true
        
        // Constraints for the summery lables(Where the user can see the consumed amount and the goal)
        summaryStack.centerXAnchor.constraint(equalTo: currentDay.centerXAnchor).isActive         = true
        summaryStack.topAnchor.constraint(equalTo: currentDay.bottomAnchor, constant: 5).isActive = true
        
        // Constraints for the drink options and the lables.
        smallOption.widthAnchor.constraint(equalToConstant:  50).isActive   = true
        smallOption.heightAnchor.constraint(equalToConstant: 75).isActive   = true
        smallLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        mediumOption.widthAnchor.constraint(equalToConstant:   80).isActive = true
        mediumOption.heightAnchor.constraint(equalToConstant: 130).isActive = true
        mediumLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        largeOption.widthAnchor.constraint(equalToConstant:  90).isActive   = true
        largeOption.heightAnchor.constraint(equalToConstant: 160).isActive  = true
        largeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        drinkStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                          = true
        drinkStack.topAnchor.constraint(lessThanOrEqualTo: summarySplitter.bottomAnchor, constant: 80).isActive = true
        
        // Constraints for the buttons
        settingsButton.widthAnchor.constraint(equalToConstant: 50).isActive  = true
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive      = true
        settingsButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        
        calendarButton.widthAnchor.constraint(equalToConstant: 50).isActive  = true
        calendarButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        calendarButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive   = true
        calendarButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        
    }
    
    //MARK: - SetUp UIButton
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
        largeOptionLongGesture.minimumPressDuration  = 0.2
        
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
    
    //MARK: - SetUp UIViewStack
    /**
     Will crate a stack for all the summary lables.
     
     # Example #
     ```
     func setUPUI(){
     createSummaryStack()
     self.view.addSubView(summaryStack)
     }
     ```
     */
    func createSummaryStack(){
        summaryStack.addArrangedSubview(consumedAmount)
        summaryStack.addArrangedSubview(summarySplitter)
        summaryStack.addArrangedSubview(goalAmount)
        summaryStack.addArrangedSubview(goalPrefix)
    }
    
    /**
     Will create a stack for the drink options and add the labels corresponding too the drink option.
     
     # Example #
     ```
     func setUPUI(){
     crateDrinkStack()
     self.view.addSubView(drinkStack)
     }
     ```
     */
    func createDrinkStack(){
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
    
    /**
     Will ask for premitions to use the health data for water consumtion. it will only write not read.
     Will ask for premition to send notifications after previous request.
     
     # Example #
     ```
     setUpHealth()
     ```
     */
    fileprivate func setUpRequests() {
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
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound]) { (success, error) in
                    if success {
                        print("we are allowed to send notifications.")
                        self.defaults.set(true, forKey: remindersString)
                    } else {
                        print("we are not allowed to send notifications.")
                        self.defaults.set(false, forKey: remindersString)
                    }
                }
            })
        }
    }
    
    //MARK: - HealthKit
    
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
        if waterAmount != 0 {
            HKHealthStore().save(waterConsumedSample) { (success, error) in
                if let error = error {
                    print("Error Saving water consumtion: \(error.localizedDescription)")
                } else {
                    print("Successfully saved water consumtion")
                }
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
        if darkMode {
            self.view.backgroundColor = UIColor().hexStringToUIColor("#212121")
            appTitle.textColor        = .white
            currentDay.textColor      = .white
            consumedAmount.textColor  = .white
            summarySplitter.textColor = .white
            goalAmount.textColor      = .white
            goalPrefix.textColor      = .white
            smallLabel.textColor      = .white
            smallPrefix.textColor     = .white
            mediumLabel.textColor     = .white
            mediumPrefix.textColor    = .white
            largeLabel.textColor      = .white
            largePrefix.textColor     = .white
            if #available(iOS 13, *) {
                settingsButton.tintColor  = .lightGray
                calendarButton.tintColor  = .lightGray
            } else {
                settingsButton.setBackgroundImage(UIImage(named: "gear")?.colored(.gray), for: .normal)
                calendarButton.setBackgroundImage(UIImage(named: "calendar.circle")?.colored(.gray), for: .normal)
            }
        } else {
            self.view.backgroundColor = .white
            appTitle.textColor        = .black
            currentDay.textColor      = .black
            consumedAmount.textColor  = .black
            summarySplitter.textColor = .black
            goalAmount.textColor      = .black
            goalPrefix.textColor      = .black
            smallLabel.textColor      = .black
            smallPrefix.textColor     = .black
            mediumLabel.textColor     = .black
            mediumPrefix.textColor    = .black
            largeLabel.textColor      = .black
            largePrefix.textColor     = .black
            if #available(iOS 13, *) {
                settingsButton.tintColor  = .black
                calendarButton.tintColor  = .black
            } else {
                settingsButton.setBackgroundImage(UIImage(named: "gear")?.colored(.black), for: .normal)
                calendarButton.setBackgroundImage(UIImage(named: "calendar.circle")?.colored(.black), for: .normal)
            }
        }
    }
    
    //MARK: - Update consmed
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
    func updateConsumtion(_ drinkConsumed: Double) {
        let drinkAmount  = Measurement(value: Double(drinkConsumed), unit: UnitVolume.milliliters)
        let drink        = drinkAmount.converted(to: .liters).value
        exportDrinkToHealth(Double(drink), Date.init())
        fetchDays()
        let today = fetchToday()
        today.consumed += drink
        let rounded = round(today.consumed * 100)/100
        today.consumed = rounded
        if today.consumed <= 0.0{
            today.consumed  = 0
        }
        saveDays()
        updateUI()
        
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .authorized {
                // check if the user have activated notifications or not.
                
                let wantReminders = self.defaults.bool(forKey: remindersString)
                if wantReminders {
                    //gets starrting times
                    let startDate = self.defaults.object(forKey: startingTimeString) as! Date
                    let endDate   = self.defaults.object(forKey: endingTimeString) as! Date
                    let intervals = self.defaults.integer(forKey: reminderIntervalString)
                    current.getPendingNotificationRequests { (notifications) in
                        if !notifications.isEmpty{
                            //Sets starting time with datecomponents [month, day, hour, minute]
                            var tempStart = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: startDate)
                            var tempEnd   = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: endDate)
                            let tempNow   = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: Date())
                            // checks if the goal has been reached
                            if today.goal <= today.consumed{
                                current.removeAllPendingNotificationRequests()
                                //Setting reminders for tomorrow.
                                tempStart.day = tempNow.day! + 1
                                tempEnd.day   = tempNow.day! + 1
                                setReminders(Calendar.current.date(from: tempStart)!,
                                             Calendar.current.date(from: tempEnd)!,
                                             intervals)
                                // checks if the goal has been reached
                                if today.goal <= today.consumed {
                                    let startDate = self.defaults.object(forKey: startingTimeString) as! Date
                                    let endDate   = self.defaults.object(forKey: endingTimeString) as! Date
                                    let intervals = self.defaults.integer(forKey: reminderIntervalString)
                                    
                                    var tempStart = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: startDate)
                                    var tempEnd   = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: endDate)
                                    let now   = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: Date())
                                    
                                    current.removeAllPendingNotificationRequests()
                                    //Setting reminders for tomorrow.
                                    tempStart.day = now.day! + 1
                                    tempEnd.day   = now.day! + 1
                                    setReminders(Calendar.current.date(from: tempStart)!,
                                                 Calendar.current.date(from: tempEnd)!,
                                                 intervals)
                                    //Setting up a congratulation message.
                                    let notification = getCongratulationReminder()
                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60*1, repeats: false)
                                    let uuidString = UUID().uuidString
                                    let request = UNNotificationRequest(identifier: uuidString, content: notification, trigger: trigger)
                                    current.add(request, withCompletionHandler: nil)
                                }
                            } else {
                                //checks if the current time is within the notifications time span.
                                if ((tempStart.hour! == tempNow.hour! && tempStart.minute! < tempNow.minute!) ||
                                        tempStart.hour! < tempNow.hour!) &&
                                    ((tempEnd.hour! == tempNow.hour! && tempEnd.minute! > tempNow.minute!) ||
                                        tempEnd.hour! > tempNow.hour!)
                                {
                                    //sets new reminders for the notification range
                                    current.getPendingNotificationRequests {(requests) in
                                        for request in requests {
                                            if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                                               let triggerDate = trigger.nextTriggerDate(){
                                                let difference = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: triggerDate)
                                                let differenceInMunutes = (difference.hour! * 60) + difference.minute!
                                                // Checks if the time to the next notification is less than 80% of the interval time.
                                                if differenceInMunutes < Int(Double(intervals) * 0.8) {
                                                    current.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            setReminders(startDate, endDate, intervals)
                        }
                    }
                }
            }
        })
         
        if WCSession.isSupported(){
            let message = ["phoneDate": formatter.string(from: today.date),
                           "phoneGoal": String(today.goal),
                           "phoneConsumed": String(today.consumed),
                           "phoneDrinks": "\(drinkOptions[0]),\(drinkOptions[1]),\(drinkOptions[2])"]
            WCSession.default.transferCurrentComplicationUserInfo(message)
        }
    }
    
    //MARK: - Update View
    /**
     Updates the  in the UI
     
     # Notes: #
     1. Should be called when the amount off drinks has been changed
     
     # Example #
     ```
     updateUI()
     ```
     */
    @objc func updateUI(){
        let today = fetchToday()
        let goalAmount     = Measurement(value: Double(today.goal), unit: UnitVolume.liters)
        let consumedAmount = Measurement(value: Double(today.consumed), unit: UnitVolume.liters)
        let smallDrink     = Measurement(value: Double(drinkOptions[0]), unit: UnitVolume.milliliters)
        let mediumDrink    = Measurement(value: Double(drinkOptions[1]), unit: UnitVolume.milliliters)
        let largeDrink     = Measurement(value: Double(drinkOptions[2]), unit: UnitVolume.milliliters)
        var goal = Double()
        var consumed = Double()
        if metricUnits {
            goal       = goalAmount.converted(to: .liters).value
            consumed   = consumedAmount.converted(to: .liters).value
            let roundedSmallDrink  = smallDrink.converted(to: .milliliters).value.rounded()
            let roundedMediumDrink = mediumDrink.converted(to: .milliliters).value.rounded()
            let roundedLargeDrink  = largeDrink.converted(to: .milliliters).value.rounded()
            smallLabel.text        = String(format: "%.0f", roundedSmallDrink)
            mediumLabel.text       = String(format: "%.0f", roundedMediumDrink)
            largeLabel.text        = String(format: "%.0f", roundedLargeDrink)
        } else {
            goal     = goalAmount.converted(to: .imperialPints).value
            consumed = consumedAmount.converted(to: .imperialPints).value
            let small           = smallDrink.converted(to: .imperialFluidOunces).value
            let medium          = mediumDrink.converted(to: .imperialFluidOunces).value
            let large           = largeDrink.converted(to: .imperialFluidOunces).value
            smallLabel.text     = String(format: "%.2f", small)
            mediumLabel.text    = String(format: "%.2f", medium)
            largeLabel.text     = String(format: "%.2f", large)
        }
        
        self.goalAmount.text     = String(goal.clean)
        self.consumedAmount.text = String(consumed.clean)
        
        if metricUnits {
            smallPrefix.text  = "\(UnitVolume.milliliters.symbol)"
            mediumPrefix.text = "\(UnitVolume.milliliters.symbol)"
            largePrefix.text  = "\(UnitVolume.milliliters.symbol)"
            goalPrefix.text   = "\(UnitVolume.liters.symbol)"
        } else {
            smallPrefix.text  = "\(UnitVolume.imperialFluidOunces.symbol)"
            mediumPrefix.text = "\(UnitVolume.imperialFluidOunces.symbol)"
            largePrefix.text  = "\(UnitVolume.imperialFluidOunces.symbol)"
            goalPrefix.text   = "\(UnitVolume.imperialPints.symbol)"
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
    func popUpOptions(_ sender: UIGestureRecognizer, _ drink: Double, _ optionLabel: UILabel) {
        let alerContorller  = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let editOption      = UIAlertAction(title: NSLocalizedString("EditDrink",comment: "popup view option for editing the drink options."),
                                            style: .default) {_ in
            let editAlert   = UIAlertController(title: NSLocalizedString("ChangeAmount", comment: "popup view title"),
                                                message: nil, preferredStyle: .alert)
            editAlert.addTextField(configurationHandler: {(_ textField: UITextField) in
                textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("EnterNewValue", comment: "PlaceHolder text for textfield"), attributes:[ NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                textField.font          = UIFont(name: "American typewriter", size: 18)
                textField.keyboardType  = .decimalPad
                textField.textAlignment = .center
            })
            let done = UIAlertAction(title: NSLocalizedString("Done", comment: "The done option of a popup view"), style: .default) {_ in
                let newValue = (editAlert.textFields?.first!.text!)! as String
                if newValue != "" {
                    if self.metricUnits {
                        let drinkAmount = Measurement(value: Double(newValue)!, unit: UnitVolume.milliliters).converted(to: .milliliters)
                        switch optionLabel {
                        case self.smallLabel:
                            self.drinkOptions[0] = drinkAmount.value
                        case self.mediumLabel:
                            self.drinkOptions[1] = drinkAmount.value
                        case self.largeLabel:
                            self.drinkOptions[2] = drinkAmount.value
                        default:
                            break
                        }
                    } else {
                        let drinkAmount = Measurement(value: Double(newValue)!, unit: UnitVolume.imperialFluidOunces)
                            .converted(to: .milliliters)
                        switch optionLabel {
                        case self.smallLabel:
                            self.drinkOptions[0] = drinkAmount.value
                        case self.mediumLabel:
                            self.drinkOptions[1] = drinkAmount.value
                        case self.largeLabel:
                            self.drinkOptions[2] = drinkAmount.value
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
        let removeAmount = UIAlertAction(title: NSLocalizedString("RemoveDrink", comment:
                                                                    "popup view option for removeing the drink amount."), style: .default) {_ in
            let removeDrink = -drink
            self.updateConsumtion(removeDrink)
        }
        alerContorller.addAction(editOption)
        alerContorller.addAction(removeAmount)
        alerContorller.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:
                                                                            "popup view option for cancel."), style: .destructive, handler: nil))
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
        defaults.set(drinkOptions[0], forKey: smallDrinkOptionString)
        defaults.set(drinkOptions[1], forKey: mediumDrinkOptionString)
        defaults.set(drinkOptions[2], forKey: largeDrinkOptionString)
        updateUI()
        self.fetchDays()
        var today: Day?
        if days.isEmpty {
            today = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: Date())}) ?? Day(context: context)
        }
        if !days.isEmpty {
            today?.goal = days.last?.goal ?? 3
        }
        let message = ["phoneDate": formatter.string(from: today?.date ?? Date()),
                       "phoneGoal": String(today?.goal ?? 3),
                       "phoneConsumed": String(today?.consumed ?? 0),
                       "phoneDrinks": "\(drinkOptions[0] ),\(drinkOptions[1] ),\(drinkOptions[2] )"]
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(message, replyHandler: nil) { (error) in
                print(error.localizedDescription)
            }
            WCSession.default.transferCurrentComplicationUserInfo(message)
        } else {
            WCSession.default.transferUserInfo(message)
        }
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
        drinkOptions[0]  = defaults.double(forKey: smallDrinkOptionString)
        drinkOptions[1]  = defaults.double(forKey: mediumDrinkOptionString)
        drinkOptions[2]  = defaults.double(forKey: largeDrinkOptionString)
        
        if  drinkOptions[0]  == 0 || drinkOptions[1]  == 0 || drinkOptions[2]  == 0 {
            drinkOptions[0]  = 300
            drinkOptions[1]  = 500
            drinkOptions[2]  = 750
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "small" {
            print("small button was pressed")
            updateConsumtion(drinkOptions[0])
            completionHandler()
        } else if response.actionIdentifier == "medium"{
            print("medium button was pressed")
            updateConsumtion(drinkOptions[1])
            completionHandler()
        } else if response.actionIdentifier == "large"{
            print("large button was pressed")
            updateConsumtion(drinkOptions[2])
            completionHandler()
        } else {
            print("button was pressed")
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(UIApplication.willEnterForegroundNotification)
    }
}

//MARK: - Watch communications
extension StartVC: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if (activationState == .activated) {
            print("Connected")
        } else {
            print(error!.localizedDescription)
            
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("disconnecting from watch")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("watch not connected")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        fetchDays()
        let today = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: Date())}) ?? Day(context: context)
        if !days.isEmpty {
            today.goal = days.last?.goal ?? 3
        }
        print("sent data with transferUserInfo")
        print(String(describing: message["consumed"]))
        print(String(describing: message["date"]))
        if formatter.string(from: today.date) == message["date"] as! String {
            let messageConsumed = message["consumed"]! as! String
            guard let watchConsumed = Double(messageConsumed) else {
                print("error can't extract number from string")
                return
            }
            if today.consumed  <= watchConsumed {
                let drinkAmountAdded = watchConsumed - today.consumed
                today.consumed = watchConsumed
                self.saveDays()
                print("todays amount was updated")
                DispatchQueue.main.async {
                    self.exportDrinkToHealth(Double(drinkAmountAdded), today.date)
                    self.updateUI()
                }
            } else {
                let message = ["phoneDate": formatter.string(from: today.date),
                               "phoneGoal": String(today.goal),
                               "phoneConsumed": String(today.consumed),
                               "phoneDrinks": "\(drinkOptions[0]),\(drinkOptions[1]),\(drinkOptions[2])"]
                if WCSession.default.isReachable {
                    WCSession.default.sendMessage(message, replyHandler: nil) { (error) in
                        print(error.localizedDescription)
                    }
                    WCSession.default.transferCurrentComplicationUserInfo(message)
                } else {
                    WCSession.default.transferUserInfo(message)
                }
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        fetchDays()
        let today = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: Date())}) ?? Day(context: context)
        if !days.isEmpty {
            today.goal = days.last?.goal ?? 3
        }
        print("sent data with transferUserInfo")
        print(String(describing: userInfo["consumed"]))
        print(String(describing: userInfo["date"]))
        if formatter.string(from: today.date) == userInfo["date"] as! String {
            let messageConsumed = userInfo["consumed"]! as! String
            guard let watchConsumed = Double(messageConsumed) else {
                print("error can't extract number from string")
                return
            }
            if today.consumed <= watchConsumed {
                let drinkAmountAdded = watchConsumed - today.consumed
                today.consumed = watchConsumed
                print("todays amount was updated")
                DispatchQueue.main.async {
                    self.saveDays()
                    self.exportDrinkToHealth(Double(drinkAmountAdded), today.date)
                    self.updateUI()
                }
            } else {
                let message = ["phoneDate": formatter.string(from: today.date),
                               "phoneGoal": String(today.goal),
                               "phoneConsumed": String(today.consumed),
                               "phoneDrinks": "\(drinkOptions[0]),\(drinkOptions[1]),\(drinkOptions[2])"]
                if WCSession.default.isReachable {
                    WCSession.default.sendMessage(message, replyHandler: nil) { (error) in
                        print(error.localizedDescription)
                    }
                    WCSession.default.transferCurrentComplicationUserInfo(message)
                } else {
                    WCSession.default.transferUserInfo(message)
                }
            }
        }
    }
}

func setAppLanguage(_ language: String) {
    UserDefaults.standard.set([language], forKey: appleLanguagesString)
    UserDefaults.standard.synchronize()
    
    // Update the language by swaping bundle
    Bundle.setLanguage(language)
    
    // Done to reintantiate the storyboards instantly
    UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController = StartVC()
}

// MARK: - Notifications

func setReminders() {
        // Gets times for reminders and sets reminders
    let defaults = UserDefaults.standard
    let startDate = defaults.object(forKey: startingTimeString) as! Date
    let endDate = defaults.object(forKey: endingTimeString) as! Date
    let intervals = defaults.integer(forKey: reminderIntervalString)
    setReminders(startDate, endDate, intervals)
}

/**
 Will set a notification for every half hour between 7 am and 11pm.
 
 # Example #
 ```
 setReminders()
 ```
 */
func setReminders(_ startDate: Date, _ endDate: Date, _ frequency: Int){
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.removeAllDeliveredNotifications()
    notificationCenter.removeAllPendingNotificationRequests()
    
    UserDefaults.standard.set(true, forKey: remindersString)
    
    let intervals = frequency
    
    let difference = Calendar.current.dateComponents([.hour, .minute], from: startDate, to: endDate)
    let differenceInMunutes = (difference.hour! * 60) + difference.minute!
    let totalNotifications = Double(differenceInMunutes / intervals).rounded(.down)
    
    print("difference \(differenceInMunutes)")
    print("total notifications \(totalNotifications)")
    
    let small   = UserDefaults.standard.double(forKey: smallDrinkOptionString)
    let medium  = UserDefaults.standard.double(forKey: mediumDrinkOptionString)
    let large   = UserDefaults.standard.double(forKey: largeDrinkOptionString)
    
    let metricUnits = UserDefaults.standard.bool(forKey: metricUnitsString)
    var unit = String()
    var smallDrink  = String()
    var mediumDrink = String()
    var largeDrink  = String()
    if metricUnits {
        smallDrink  = String(format: "%.0f", Measurement(value: small, unit: UnitVolume.milliliters).value)
        mediumDrink = String(format: "%.0f", Measurement(value: medium, unit: UnitVolume.milliliters).value)
        largeDrink  = String(format: "%.0f", Measurement(value: large, unit: UnitVolume.milliliters).value)
        unit = "ml"
    } else {
        smallDrink  = String(format: "%.2f", Measurement(value: small, unit: UnitVolume.milliliters).converted(to: .fluidOunces).value)
        mediumDrink = String(format: "%.2f", Measurement(value: medium, unit: UnitVolume.milliliters).converted(to: .fluidOunces).value)
        largeDrink  = String(format: "%.2f", Measurement(value: large, unit: UnitVolume.milliliters).converted(to: .fluidOunces).value)
        unit = "fl oz"
    }
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/YYYY"
    print(formatter.string(from: startDate))
    for i in 0...Int(totalNotifications) {
        let notificationDate = Calendar.current.date(byAdding: .minute, value: intervals * i, to: startDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        print("setting reminder for \(formatter.string(from: notificationDate!))")
        let notification = getReminder()
        let smallDrinkAction = UNNotificationAction(identifier: "small", title: "\(NSLocalizedString("Add", comment: "")) \(smallDrink)\(unit)",
                                                    options: UNNotificationActionOptions(rawValue: 0))
        let mediumDrinkAction = UNNotificationAction(identifier: "medium", title: "\(NSLocalizedString("Add", comment: "")) \(mediumDrink)\(unit)",
                                                     options: UNNotificationActionOptions(rawValue: 0))
        let largeDrinkAction = UNNotificationAction(identifier: "large", title: "\(NSLocalizedString("Add", comment: "")) \(largeDrink)\(unit)",
                                                    options: UNNotificationActionOptions(rawValue: 0))
        let category = UNNotificationCategory(identifier: "reminders", actions: [smallDrinkAction, mediumDrinkAction, largeDrinkAction], intentIdentifiers: [], options: .customDismissAction)
        let date = Calendar.current.dateComponents([.day, .hour, .minute], from: notificationDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: notification, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: nil)
        notificationCenter.setNotificationCategories([category])
    }
}

/**
 Will return a random **UNMutableNotificationContent** a notifcation message.
 
 # Notes: #
 1. This will pick out a message randomly so you could get the same message twice.
 
 # Example #
 ```
 let notification = getReminder()
 ```
 */
func getReminder()-> UNMutableNotificationContent{
    struct reminder {
        var title = String()
        var body  = String()
    }
    let reminderMessages: [reminder] = [
        reminder(title: NSLocalizedString("reminder1Title", comment: "First reminder title"),
                 body:  NSLocalizedString("reminder1Body", comment: "First reminder body")),
        reminder(title: NSLocalizedString("reminder2Title", comment: "Second reminder title"),
                 body:  NSLocalizedString("reminder2Body", comment: "Second reminder body")),
        reminder(title: NSLocalizedString("reminder3Title", comment: "third reminder title"),
                 body:  NSLocalizedString("reminder3Body", comment: "third reminder body")),
        reminder(title: NSLocalizedString("reminder4Title", comment: "forth reminder title"),
                 body:  NSLocalizedString("reminder4Body", comment: "forth reminder body")),
        reminder(title: NSLocalizedString("reminder5Title", comment: "fifth reminder title"),
                 body:  NSLocalizedString("reminder5Body", comment: "fifth reminder body")),
        reminder(title: NSLocalizedString("reminder6Title", comment: "sixth reminder title"),
                 body:  NSLocalizedString("reminder6Body", comment: "sixth reminder body")),
        reminder(title: NSLocalizedString("reminder7Title", comment: "seventh reminder title"),
                 body:  NSLocalizedString("reminder7Body", comment: "seventh reminder body")),
        reminder(title: NSLocalizedString("reminder8Title", comment: "eighth reminder title"),
                 body:  NSLocalizedString("reminder8Body", comment: "eighth reimder body")),
        reminder(title: NSLocalizedString("reminder9Title", comment: "ninth reminder title"),
                 body:  NSLocalizedString("reminder9Body", comment: "ninth reminder body")),
        reminder(title: NSLocalizedString("reminder10Title", comment: "tenth reminder title"),
                 body:  NSLocalizedString("reminder10Body", comment: "tenth reminder body")),
        reminder(title: NSLocalizedString("reminder11Title", comment: "eleventh reminder title"),
                 body:  NSLocalizedString("reminder11Body", comment: "eleventh reminder body")),
        reminder(title: NSLocalizedString("reminder12Title", comment: "twelfth reminder title"),
                 body:  NSLocalizedString("reminder12Body", comment: "twelfth reminder body"))]
    let randomInt = Int.random(in: 0...reminderMessages.count - 1)
    let notification = UNMutableNotificationContent()
    notification.title = reminderMessages[randomInt].title
    notification.body  = reminderMessages[randomInt].body
    notification.categoryIdentifier = "reminders"
    notification.sound  = .default
    return notification
}

func getCongratulationReminder()-> UNMutableNotificationContent{
    struct reminder {
        var title = String()
        var body  = String()
    }
    let reminderMessages: [reminder] = [
        reminder(title: NSLocalizedString("congrats1Title" , comment: "First reminder title"),
                 body:  NSLocalizedString("congrats1Body"  , comment: "First reminder body")),
        reminder(title: NSLocalizedString("congrats2Title" , comment: "Second reminder title"),
                 body:  NSLocalizedString("congrats2Body"  , comment: "Second reminder body")),
        reminder(title: NSLocalizedString("congrats3Title" , comment: "third reminder title"),
                 body:  NSLocalizedString("congrats3Body"  , comment: "third reminder body")),
        reminder(title: NSLocalizedString("congrats4Title" , comment: "forth reminder title"),
                 body:  NSLocalizedString("congrats4Body"  , comment: "forth reminder body")),
        reminder(title: NSLocalizedString("congrats5Title" , comment: "fifth reminder title"),
                 body:  NSLocalizedString("congrats5Body"  , comment: "fifth reminder body")),
        reminder(title: NSLocalizedString("congrats6Title" , comment: "sixth reminder title"),
                 body:  NSLocalizedString("congrats6Body"  , comment: "sixth reminder body")),
        reminder(title: NSLocalizedString("congrats7Title" , comment: "seventh reminder title"),
                 body:  NSLocalizedString("congrats7Body"  , comment: "seventh reminder body")),
        reminder(title: NSLocalizedString("congrats8Title" , comment: "eighth reminder title"),
                 body:  NSLocalizedString("congrats8Body"  , comment: "eighth reimder body")),
        reminder(title: NSLocalizedString("congrats9Title" , comment: "ninth reminder title"),
                 body:  NSLocalizedString("congrats9Body"  , comment: "ninth reminder body")),
        reminder(title: NSLocalizedString("congrats10Title", comment: "tenth reminder title"),
                 body:  NSLocalizedString("congrats10Body" , comment: "tenth reminder body"))]
    let randomInt = Int.random(in: 0...reminderMessages.count - 1)
    let notification = UNMutableNotificationContent()
    notification.title = reminderMessages[randomInt].title
    notification.body  = reminderMessages[randomInt].body
    notification.categoryIdentifier = "congratulations"
    notification.sound  = .default
    return notification
}

#if DEBUG

struct startVCRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // leave this empty
    }
    
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        StartVC()
    }
}

@available(iOS 13.0, *)
struct startVCPreview: PreviewProvider {
    static var previews: some View {
        startVCRepresentable()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 pro"))
            .previewDisplayName("iPhone 11 pro")
    }
}
#endif
