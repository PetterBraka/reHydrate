//
//  SettingOptionCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 24/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class SettingOptionCell: UITableViewCell {
    var numberArray       = ["0", "1","2","3","4","5","6","7","8","9"]
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
            self.backgroundColor            = hexStringToUIColor(hex: "#212121")
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
            case "dark mode":
                if dark{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case "light mode":
                if !dark{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case "metric system":
                if metric{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case "imperial system":
                if !metric{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case "goal":
                activatedOption.isHidden = true
                titleOption.text         = "Set your goal"
                let days = Day.loadDay()
                if !days.isEmpty{
                    textField.text = String(describing: days.last!.goalAmount.amountOfDrink)
                } else {
                    textField.text = "3"
                }
                setUpPickerView()
            case "turn on reminders", "turn off reminders":
                activatedOption.isHidden = false
            case "starting time", "ending time":
            	setUpDatePicker()
                activatedOption.isHidden = true
            case "frequency" :
                activatedOption.isHidden = true
                setUpMinutePicker()
            default:
                activatedOption.isHidden = true
        }
        UserDefaults.standard.set(dark, forKey: "darkMode")
        UserDefaults.standard.set(metric, forKey: "metricUnits")
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
    
    //MARK: - Set-up pickers
    
    fileprivate func setUpPickerView() {
        self.addSubview(textField)
        setTextFieldConstraints()
        
        let toolBar 		= UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.contentView.frame.width, height: 40)))
        let flexibleSpace 	= UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton 		= UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
        
        picker.frame 		= CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: 280)
        picker.delegate		= self
        picker.dataSource 	= self
        textField.inputView = picker
    }
    
    fileprivate func setUpDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.locale = .current
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.hour, .minute], from: Date())
        let startDate = UserDefaults.standard.object(forKey: "startignTime") as! Date
        let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
        let endDate = UserDefaults.standard.object(forKey: "endingTime") as! Date
        let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
        if titleOption.text?.lowercased() == "starting time"{
            components.hour = startTimer.hour
            components.minute = startTimer.minute
        } else if titleOption.text?.lowercased() == "ending time" {
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
        minutePicker.minuteInterval = 10
        var components = DateComponents()
        components.minute = UserDefaults.standard.integer(forKey: "reminderInterval")
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
            case "starting time":
                let startDate = sender.date
                var endDate = UserDefaults.standard.object(forKey: "endingTime") as! Date
                if endDate <= startDate {
                    endDate = endDate - 1 * 60
                    sender.setDate(endDate, animated: true)
                }
                UserDefaults.standard.set(startDate, forKey: "startignTime")
                break
            case "ending time":
                let endDate = sender.date
                var startDate = UserDefaults.standard.object(forKey: "startignTime") as! Date
                if endDate <= startDate {
                    startDate = startDate + 1 * 60
                    sender.setDate(startDate, animated: true)
                }
                UserDefaults.standard.set(endDate, forKey: "endingTime")
                break
            case "frequency":
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
            case "set your goal":
                var component = 0
                while component < picker.numberOfComponents {
                    let value = numberArray[picker.selectedRow(inComponent: component)]
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
            case "starting time" , "ending time":
                let startDate = UserDefaults.standard.object(forKey: "startignTime") as! Date
                let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
                let endDate = UserDefaults.standard.object(forKey: "endingTime") as! Date
                let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
                let intervals = UserDefaults.standard.integer(forKey: "reminderInterval")
                setReminders(startTimer.hour!, endTimer.hour!, intervals)
                sendToastMessage("Reminders set from \(startTimer.hour!) to \(endTimer.hour!)", 4)
            case "frequency":
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                formatter.locale = .current
                let picker = textField.inputView as! UIDatePicker
                textField.text = formatter.string(from: picker.date)
                
                let calendar = Calendar.current
                
                let currentDateComponent = calendar.dateComponents([.hour, .minute], from: picker.date)
                let numberOfMinutes = (currentDateComponent.hour! * 60) + currentDateComponent.minute!
                
                print("numberOfMinutes : ", numberOfMinutes)
                UserDefaults.standard.set(numberOfMinutes, forKey: "reminderInterval")
                let startDate = UserDefaults.standard.object(forKey: "startignTime") as! Date
                let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
                let endDate = UserDefaults.standard.object(forKey: "endingTime") as! Date
                let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
                setReminders(startTimer.hour!, endTimer.hour!, numberOfMinutes)
                sendToastMessage("The frequency of reminders are \(numberOfMinutes) minutes", 4)
                break
            default:
                break
        }
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
        
        UserDefaults.standard.set(true, forKey: "reminders")
        
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
            reminder(title: "You should have some water",
                     body:  "It has been a long time since you had some water, why don't you have some."),
            reminder(title: "Hi, have you heard about the Sahara?",
                     body:  "I suggest not having that as an idol. Have some water."),
            reminder(title: "Water what is that?",
                     body:  "Have you remembered to drink water? I suggest that you have some."),
            reminder(title: "Hey, would you mind if i asked you a question?",
                     body:  "Wouldn't it be great with some water?"),
            reminder(title: "What about some water?",
                     body:  "Hey, maybe you should give your brain something to run on?"),
            reminder(title: "Just a little reminder",
                     body:  "There is a thing called water maybe you should have some."),
            reminder(title: "I know you don't like it",
                     body:  "But have some water it's not going to hurt you"),
            reminder(title: "What is blue and refreshing?",
                     body:  "Water. It is water why not have some"),
            reminder(title: "Have some drink water",
                     body:  "You need to hydrate. have some water"),
            reminder(title: "Why aren't you thirsty by now",
                     body:  "You should have some water."),
            reminder(title: "Hello there",
                     body:  "General Kenobi, would you like some water?"),
            reminder(title: "Hey there me again",
                     body:  "I think you should have some water")
        ]
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
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case 0, 1, 3:
                return numberArray.count
            case 2:
                return 1
            default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
            case 0, 1, 3:
                return numberArray[row]
            case 2:
                return "."
            default:
                return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
            case 0, 1, 3:
            updateTextField(numberArray[row], component)
            case 2:
            updateTextField(".", component)
            default:
            break
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

extension UITextField {
    //MARK: TextField padding
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
