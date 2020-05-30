//
//  SettingOptionCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 24/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class SettingOptionCell: UITableViewCell {
    var pickerArray       = ["0", "1","2","3","4","5","6","7","8","9"]
    var componentString   = ["","",",",""]
    let picker            = UIPickerView()
    var notificationStart = Int()
    var notificationEnd   = Int()
    var setting: String? {
        didSet {
            guard let string 	= setting else {return}
            titleOption.text 	= string
        }
    }
    var textField: UITextField 			= {
        let textField 					= UITextField()
        textField.placeholder 			= "value"
        textField.layer.borderWidth 	= 2
        textField.layer.cornerRadius 	= 5
        textField.layer.borderColor 	= UIColor.lightGray.cgColor
        textField.font 					= UIFont(name: "AmericanTypewriter", size: 17)
        textField.textAlignment 		= .center
        textField.setLeftPadding(20)
        textField.setRightPadding(20)
        return textField
    }()
    let titleOption: UILabel 	= {
        let lable 				= UILabel()
        lable.text 				= "test"
        lable.font 				= UIFont(name: "AmericanTypewriter", size: 15)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
        }()
    let subTitle: UILabel 		= {
        let lable 				= UILabel()
        lable.text 				= "subText"
        lable.font 				= UIFont(name: "AmericanTypewriter", size: 13)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let activatedOption: UIButton 	= {
        let button					= UIButton()
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleOption)
        self.addSubview(activatedOption)
        setButtonConstraints()
        titleOption.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive	= true
        titleOption.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive			= true
        self.backgroundColor																= .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubTitle(_ string: String){
        subTitle.text = string
        self.addSubview(subTitle)
        self.removeConstraints(self.constraints)
        titleOption.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive	= true
        titleOption.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive    		= true
        subTitle.leftAnchor.constraint(equalTo: titleOption.leftAnchor, constant: 10).isActive 		= true
        subTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10).isActive		= true
        setButtonConstraints()
    }
    
    /**
     Setting the constraints for the activate button.
     
     # Example #
     ```
     setActivatedButtonConstraints()
     ```
     */
    func setButtonConstraints() {
        activatedOption.widthAnchor.constraint(equalToConstant: 25).isActive                                  = true
        activatedOption.heightAnchor.constraint(equalToConstant: 25).isActive                                 = true
        activatedOption.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        activatedOption.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive            = true
    }
    
    fileprivate func setTextFieldConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints                                 = false
        textField.heightAnchor.constraint(equalToConstant: 35).isActive                     = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive        = true
        textField.centerYAnchor.constraint(equalTo: titleOption.centerYAnchor).isActive     = true
    }
    
    /**
     Changes the apparentce of the **SettingOptionCell** deppending on the users preferents.
     
     # Example #
     ```
     settCellAppairents(darkMode)
     ```
     */
    func setCellAppairents(_ dark: Bool,_ metric: Bool){
        if dark{
            activatedOption.tintColor       = .lightGray
            titleOption.textColor           = .white
            subTitle.textColor              = .white
            textField.textColor             = .white
            self.backgroundColor            = UIColor().hexStringToUIColor("#212121")
            textField.attributedPlaceholder = NSAttributedString(string: "value", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        } else {
            activatedOption.tintColor       = .black
            titleOption.textColor           = .black
            subTitle.textColor              = .black
            textField.textColor             = .black
            self.backgroundColor            = .white
            textField.attributedPlaceholder = NSAttributedString(string: "value", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        }
        switch titleOption.text?.lowercased() {
            case NSLocalizedString("DarkMode", comment: "").lowercased():
                if dark{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case NSLocalizedString("LightMode", comment: "").lowercased():
                if !dark{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case NSLocalizedString("MetricSystem", comment: "").lowercased():
                if metric{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case NSLocalizedString("ImperialSystem", comment: "").lowercased():
                if !metric{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case NSLocalizedString("SetYourGoal", comment: "").lowercased():
                activatedOption.isHidden = true
                let days = Day.loadDay()
                if !days.isEmpty{
                    textField.text = String(describing: days.last!.goalAmount.amountOfDrink)
                } else {
                    textField.text = "3"
                }
                pickerArray     = ["0", "1","2","3","4","5","6","7","8","9"]
                componentString = ["","",",",""]
                setUpPickerView()
            case NSLocalizedString("TurnOnReminders", comment: "").lowercased(),
                 NSLocalizedString("TurnOffReminders", comment: "").lowercased():
                activatedOption.isHidden = false
            case NSLocalizedString("StartingTime", comment: "").lowercased(),
                 NSLocalizedString("EndingTime", comment: "").lowercased():
            	setUpDatePicker()
                activatedOption.isHidden = true
            case NSLocalizedString("Frequency", comment: "").lowercased():
                activatedOption.isHidden = true
                setUpMinutePicker()
            case NSLocalizedString("Language", comment: "").lowercased():
                activatedOption.isHidden = true
                pickerArray     = [NSLocalizedString("en", comment: ""), NSLocalizedString("nb", comment: "")]
                componentString = [""]
                textField.placeholder = "language"
                let language = UserDefaults.standard.array(forKey: "AppleLanguages")
                textField.text = NSLocalizedString(language!.first as! String, comment: "")
                setUpPickerView()
            default:
                activatedOption.isHidden = true
        }
        UserDefaults.standard.set(dark, forKey: darkModeString)
        UserDefaults.standard.set(metric, forKey: metricUnitsString)
    }
    
    //MARK: - Set-up pickers
    
    fileprivate func setUpPickerView() {
        self.addSubview(textField)
        setTextFieldConstraints()
        
        let toolBar       = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.contentView.frame.width, height: 40)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton    = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
        
        picker.frame        = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: 280)
        picker.delegate     = self
        picker.dataSource   = self
        textField.inputView = picker
    }
    
    fileprivate func setUpDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.locale = .current
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.hour, .minute], from: Date())
        let startDate = UserDefaults.standard.object(forKey: startingTimeString) as! Date
        let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
        let endDate = UserDefaults.standard.object(forKey: endingTimeString) as! Date
        let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
        if titleOption.text?.lowercased() == NSLocalizedString(startingTimeString, comment: "").lowercased(){
            components.hour = startTimer.hour
            components.minute = startTimer.minute
        } else if titleOption.text?.lowercased() == NSLocalizedString(endingTimeString, comment: "").lowercased() {
            components.hour = endTimer.hour
            components.minute = endTimer.minute
        }
        datePicker.setDate(calendar.date(from: components)!, animated: true)
        datePicker.addTarget(self, action: #selector(handleInput), for: .allEvents)
        
        self.addSubview(textField)
        setTextFieldConstraints()
        textField.inputView = datePicker
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        textField.text = formatter.string(from: datePicker.date)
        
        let toolBar       = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.contentView.frame.width, height: 40)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton    = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    fileprivate func setUpMinutePicker() {
        let minutePicker = UIDatePicker()
        minutePicker.datePickerMode = .countDownTimer
        minutePicker.minuteInterval = 1
        var components = DateComponents()
        components.minute = UserDefaults.standard.integer(forKey: reminderIntervalString)
        let date = Calendar.current.date(from: components)!
        minutePicker.setDate(date, animated: false)
        minutePicker.addTarget(self, action: #selector(handleInput), for: .allEvents)
        
        self.addSubview(textField)
        setTextFieldConstraints()
        textField.inputView = minutePicker
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        textField.text = formatter.string(from: minutePicker.date)
        
        let toolBar       = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.contentView.frame.width, height: 40)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton    = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    @objc func handleInput(_ sender: UIDatePicker ){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        switch titleOption.text?.lowercased() {
            case NSLocalizedString("StartingTime", comment: "").lowercased():
                let startDate = sender.date
                var endDate = UserDefaults.standard.object(forKey: endingTimeString) as! Date
                if endDate <= startDate {
                    endDate = endDate - 1 * 60
                    sender.setDate(endDate, animated: true)
                }
                UserDefaults.standard.set(startDate, forKey: startingTimeString)
                break
            case NSLocalizedString("EndingTime", comment: "").lowercased():
                let endDate = sender.date
                var startDate = UserDefaults.standard.object(forKey: startingTimeString) as! Date
                if endDate <= startDate {
                    startDate = startDate + 1 * 60
                    sender.setDate(startDate, animated: true)
                }
                UserDefaults.standard.set(endDate, forKey: endingTimeString)
                break
            case NSLocalizedString("Frequency", comment: "").lowercased():
                if sender.countDownDuration > 2.5 * 60 * 60{
                    var components = DateComponents()
                    components.hour = 2
                    components.minute = 50
                    let date = Calendar.current.date(from: components)!
                    sender.setDate(date, animated: true)
                }
            default:
            break
        }
        textField.text = formatter.string(from: sender.date)
    }
    
    @objc func doneClicked(){
        textField.endEditing(true)
        switch titleOption.text?.lowercased() {
            case NSLocalizedString("SetYourGoal", comment: "").lowercased():
                var component = 0
                while component < picker.numberOfComponents {
                    let value = pickerArray[picker.selectedRow(inComponent: component)]
                    switch component {
                        case 0, 1, 3:
                            updateTextField(String(value), component)
                        case 2:
                            updateTextField(".", component)
                        default:
                            break
                    }
                    component += 1
                }
                updateGoal()
            case NSLocalizedString("StartingTime", comment: "").lowercased(),
                 NSLocalizedString("EndingTime", comment: "").lowercased():
                let startDate = UserDefaults.standard.object(forKey: startingTimeString) as! Date
                let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
                let endDate = UserDefaults.standard.object(forKey: endingTimeString) as! Date
                let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
                let intervals = UserDefaults.standard.integer(forKey: reminderIntervalString)
                setReminders(startTimer.hour!, endTimer.hour!, intervals)
                sendToastMessage("\(NSLocalizedString("RemindersSetFrom", comment: "starting of toas message")) \(startTimer.hour!) \(NSLocalizedString("To", comment: "splitter for toast")) \(endTimer.hour!)", 4)
            case NSLocalizedString("Frequency", comment: "").lowercased():
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                formatter.locale = .current
                let picker = textField.inputView as! UIDatePicker
                if picker.countDownDuration > 2.5 * 60 * 60{
                    var components = DateComponents()
                    components.hour = 2
                    components.minute = 50
                    let date = Calendar.current.date(from: components)!
                    picker.setDate(date, animated: true)
                }
                textField.text = formatter.string(from: picker.date)
                
                let calendar = Calendar.current
                
                let currentDateComponent = calendar.dateComponents([.hour, .minute], from: picker.date)
                let numberOfMinutes = (currentDateComponent.hour! * 60) + currentDateComponent.minute!
                
                print("numberOfMinutes : ", numberOfMinutes)
                UserDefaults.standard.set(numberOfMinutes, forKey: reminderIntervalString)
                let startDate = UserDefaults.standard.object(forKey: startingTimeString) as! Date
                let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
                let endDate = UserDefaults.standard.object(forKey: endingTimeString) as! Date
                let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
                setReminders(startTimer.hour!, endTimer.hour!, numberOfMinutes)
                sendToastMessage("\(NSLocalizedString("FrequencyReminder", comment: "start of frequency toast")) \(numberOfMinutes) \(NSLocalizedString("Minutes", comment: "end of frquency toast"))", 4)
                break
            case NSLocalizedString("Language", comment: "").lowercased():
                if NSLocalizedString("nb", comment: "") == textField.text {
                    // This is done so that network calls now have the Accept-Language as "hi" (Using Alamofire) Check if you can remove these
                    UserDefaults.standard.set(["nb"], forKey: "AppleLanguages")
                    UserDefaults.standard.synchronize()
                    
                    // Update the language by swaping bundle
                    Bundle.setLanguage("nb")
                } else {
                    // This is done so that network calls now have the Accept-Language as "hi" (Using Alamofire) Check if you can remove these
                    UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
                    UserDefaults.standard.synchronize()
                    
                    // Update the language by swaping bundle
                    Bundle.setLanguage("en")
                }
                break
            default:
                break
        }
    }
    
    func languageButtonAction() {
        // This is done so that network calls now have the Accept-Language as "hi" (Using Alamofire) Check if you can remove these
        UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Update the language by swaping bundle
        Bundle.setLanguage("en")
        
        // Done to reintantiate the storyboards instantly
    }
    
    // MARK: - Notifications
    
    /**
     Will set a notification for every half hour between 7 am and 11pm.
     
     # Example #
     ```
     setReminders()
     ```
     */
    func setReminders(_ startHour: Int, _ endHour: Int, _ frequency: Int){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
        
        UserDefaults.standard.set(true, forKey: remindersString)
        
        let intervals = frequency
        
        let totalHours = endHour - startHour
        let totalNotifications = totalHours * 60 / intervals
        
        for i in 0...totalNotifications {
            var date = DateComponents()
            date.hour = startHour + (intervals * i) / 60
            date.minute = (intervals * i) % 60
            print("setting reminder for \(date.hour!):\(date.minute!)")
            let notification = getReminder()
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: notification, trigger: trigger)
            notificationCenter.add(request, withCompletionHandler: nil)
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
        notification.categoryIdentifier = "reminder"
        notification.sound  = .default
        return notification
    }
    
    /**
     Will create a toast message and display it on the bottom of the screen.
     
     - parameter message: - **String** that will be displayed on the screen.
     - parameter messageDelay: - a **Double** of how long the message will be displayed.
     
     # Example #
     ```
     sendToastMessage("Reminders set for every 30 minutes from 7 am to 11 pm", 3.5)
     ```
     */
    func sendToastMessage(_ message: String, _ messageDelay: Double) {
        let toastLabel = UIButton()
        toastLabel.setTitle(message, for: .normal)
        toastLabel.titleLabel?.font          = UIFont(name: "AmericanTypewriter", size: 18.0)
        toastLabel.titleLabel?.textAlignment = .center
        toastLabel.titleLabel?.numberOfLines = 0
        toastLabel.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        if titleOption.textColor == UIColor.white {
            toastLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
            toastLabel.setTitleColor(UIColor.white, for: .normal)
        } else {
            toastLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
            toastLabel.setTitleColor(UIColor.black, for: .normal)
        }
        toastLabel.isUserInteractionEnabled = false
        toastLabel.layer.cornerRadius       = 10
        toastLabel.clipsToBounds            = true
        toastLabel.alpha                    = 1
        self.superview!.superview!.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor).isActive                      = true
        toastLabel.centerYAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: -100).isActive       = true
        toastLabel.leftAnchor.constraint(greaterThanOrEqualTo: self.superview!.leftAnchor, constant: 50).isActive = true
        toastLabel.rightAnchor.constraint(lessThanOrEqualTo: self.superview!.rightAnchor, constant: -50).isActive = true
        toastLabel.sizeToFit()
        UIView.animate(withDuration: 0.5, delay: messageDelay, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func updateGoal(){
        let days = Day.loadDay()
        let newGoal = Float(textField.text!)!
        if newGoal != 0 {
            days[days.count - 1].goalAmount.amountOfDrink = newGoal
            print(days[days.count - 1].goalAmount.amountOfDrink)
            Day.saveDay(days)
        }
    }
}

extension SettingOptionCell: UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: - UIPickerVeiw
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if NSLocalizedString("Language", comment: "") == titleOption.text {
            return 1
        } else {
            return 4
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if NSLocalizedString("Language", comment: "") == titleOption.text {
            return pickerArray.count
        } else {
            switch component {
                case 0, 1, 3:
                    return pickerArray.count
                case 2:
                    return 1
                default:
                    return 0
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if NSLocalizedString("Language", comment: "") == titleOption.text {
            return pickerArray[row]
        } else {
            switch component {
                case 0, 1, 3:
                    return pickerArray[row]
                case 2:
                    return "."
                default:
                    return ""
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if NSLocalizedString("Language", comment: "") == titleOption.text {
            return 150
        } else {
            return 35
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if NSLocalizedString("Language", comment: "") == titleOption.text {
            updateTextField(pickerArray[row], component)
        } else {
            switch component {
                case 0, 1, 3:
                    updateTextField(pickerArray[row], component)
                case 2:
                    updateTextField(".", component)
                default:
                    break
            }
        }
    }
    
    func updateTextField(_ input: String, _ component: Int){
        textField.text = ""
        componentString[component] = input
        if componentString[0] == "0" {
            componentString[0] = ""
        }
        for number in componentString {
            textField.text = textField.text! + number
        }
            
    }
}

