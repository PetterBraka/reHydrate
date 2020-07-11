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
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        return formatter
    }()
    var setting: String? {
        didSet {
            guard let string 	= setting else {return}
            titleOption.text 	= string
        }
    }
    var textField: UITextField       = {
        let textField                = UITextField()
        textField.placeholder        = "value"
        textField.layer.borderWidth  = 2
        textField.layer.cornerRadius = 5
        textField.layer.borderColor  = UIColor.lightGray.cgColor
        textField.font               = UIFont(name: "AmericanTypewriter", size: 17)
        textField.textAlignment      = .center
        textField.setLeftPadding(10)
        textField.setRightPadding(10)
        return textField
    }()
    let titleOption: UILabel 	= {
        let lable   = UILabel()
        lable.text  = "test"
        lable.font  = UIFont(name: "AmericanTypewriter", size: 15)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
        }()
    let subTitle: UILabel = {
        let lable  = UILabel()
        lable.text = "subText"
        lable.font = UIFont(name: "AmericanTypewriter", size: 13)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var imageForCell: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleOption)
        self.addSubview(imageForCell)
        setTitleConstraints()
        setButtonConstraints()
        self.backgroundColor = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Adds a subtitle under the title lable
     
     - parameter : subTitle - the **String** you wnat to display under the title.
     
     # Example #
     ```
     addSubTitle("subtitle")
     ```
     */
    func addSubTitle(_ subtitle: String){
        subTitle.text = subtitle
        self.addSubview(subTitle)
        self.removeConstraints(self.constraints)
        titleOption.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        titleOption.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive        = true
        subTitle.leftAnchor.constraint(equalTo: titleOption.leftAnchor, constant: 10).isActive    = true
        subTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10).isActive     = true
        setButtonConstraints()
    }
    
    /**
     Setting constraints for the tilte lable.
     
     # Example #
     ```
     setTitleConstraints()
     ```
     */
    func setTitleConstraints(){
        self.removeConstraints(self.constraints)
        titleOption.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleOption.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive         = true
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
        imageForCell.widthAnchor.constraint(equalToConstant: 25).isActive                                  = true
        imageForCell.heightAnchor.constraint(equalToConstant: 25).isActive                                 = true
        imageForCell.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        imageForCell.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive            = true
    }
    
    func setButtonConstraints(_ size: CGFloat) {
        imageForCell.widthAnchor.constraint(equalToConstant: size).isActive                                = true
        imageForCell.heightAnchor.constraint(equalToConstant: size).isActive                               = true
        imageForCell.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        imageForCell.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive            = true
    }
    
    fileprivate func setTextFieldConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints                                 = false
        textField.heightAnchor.constraint(equalToConstant: 35).isActive                     = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive        = true
        textField.centerYAnchor.constraint(equalTo: titleOption.centerYAnchor).isActive     = true
    }
    
    /**
     Changes the apparentce of a **SettingOptionCell** deppending on the users preferents.
     
     # Example #
     ```
     settCellAppairents(darkMode)
     ```
     */
    func setCellAppairents(_ dark: Bool,_ metric: Bool){
        if dark{
            imageForCell.tintColor          = .lightGray
            titleOption.textColor           = .white
            subTitle.textColor              = .white
            textField.textColor             = .white
            self.backgroundColor            = UIColor().hexStringToUIColor("#212121")
            
            textField.attributedPlaceholder = NSAttributedString(string: "value", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        } else {
            imageForCell.tintColor          = .darkGray
            titleOption.textColor           = .black
            subTitle.textColor              = .black
            textField.textColor             = .black
            self.backgroundColor            = .white
            textField.attributedPlaceholder = NSAttributedString(string: "value", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        }
        switch titleOption.text?.lowercased() {
            case NSLocalizedString("DarkMode", comment: "").lowercased():
                imageForCell.isHidden = false
                if dark{
                    imageForCell.setBackgroundImage(UIImage(systemName: "moon.circle.fill"), for: .normal)
                } else {
                    imageForCell.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
                }
            case NSLocalizedString("MetricSystem", comment: "").lowercased():
                imageForCell.isHidden = false
                if metric{
                    imageForCell.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                } else {
                    imageForCell.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
                }
            case NSLocalizedString("ImperialSystem", comment: "").lowercased():
                imageForCell.isHidden = false
                if !metric{
                    imageForCell.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                } else {
                    imageForCell.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
                }
            case NSLocalizedString("SetYourGoal", comment: "").lowercased():
                imageForCell.isHidden = true
                let days = Day.loadDays()
                if !days.isEmpty{
                    textField.text = String(describing: days.last!.goal.amountOfDrink)
                } else {
                    textField.text = "3"
                }
                pickerArray     = ["0", "1","2","3","4","5","6","7","8","9"]
                componentString = ["","",",",""]
                setUpPickerView()
                break
            case NSLocalizedString("TurnOnReminders", comment: "").lowercased(),
                 NSLocalizedString("TurnOffReminders", comment: "").lowercased():
                imageForCell.isHidden = false
            case NSLocalizedString("StartingTime", comment: "").lowercased(),
                 NSLocalizedString("EndingTime", comment: "").lowercased():
            	setUpDatePicker()
                imageForCell.isHidden = true
            case NSLocalizedString("Frequency", comment: "").lowercased():
                imageForCell.isHidden = true
                setUpMinutePicker()
            case NSLocalizedString("Language", comment: "").lowercased():
                imageForCell.isHidden = true
                pickerArray     = [NSLocalizedString(appLanguages[0], comment: ""), NSLocalizedString(appLanguages[1], comment: "")]
                componentString = [""]
                setUpPickerView()
                textField.placeholder = "language"
                let picker = textField.inputView as! UIPickerView
                let language = UserDefaults.standard.array(forKey: appleLanguagesString) as! [String]
                if pickerArray.contains(NSLocalizedString(language[0], comment: "")){
                    textField.text = NSLocalizedString(language.first!, comment: "")
                    picker.selectRow(pickerArray.firstIndex(of: NSLocalizedString(language.first!, comment: "")) ?? 0, inComponent: 0, animated: true)
                } else {
                    textField.text = NSLocalizedString(appLanguages[0], comment: "")
                    picker.selectRow(pickerArray.firstIndex(of: NSLocalizedString(appLanguages[0], comment: "")) ?? 0, inComponent: 0, animated: true)
                }
//            case NSLocalizedString("AppIcon", comment: "").lowercased():
//                imageForCell.setBackgroundImage(UIImage(systemName: "chevron.compact.right"), for: .normal)
//            case NSLocalizedString("HowToUse", comment: "").lowercased():
//                imageForCell.setBackgroundImage(UIImage(systemName: "chevron.compact.right"), for: .normal)
            default:
                imageForCell.isHidden = true
        }
        UserDefaults.standard.set(dark, forKey: darkModeString)
        UserDefaults.standard.set(metric, forKey: metricUnitsString)
    }
    
    //MARK: - Set-up PickerView
    
    /**
     Setting up a **UIPickerView** for a **UITextField**
     
     # Example #
     ```
     setUpPickerView()
     ```
     */
    fileprivate func setUpPickerView() {
        self.addSubview(textField)
        setTextFieldConstraints()
        
        let toolBar       = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.contentView.frame.width, height: 40)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton    = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(doneClicked))
        let cancelButton  = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelClicked))
        cancelButton.tintColor = .red
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
        
        picker.frame        = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: 280)
        picker.delegate     = self
        picker.dataSource   = self
        textField.inputView = picker
    }
    
    // MARK: - SetUp DatePicker
    
    /**
     Setting up a **UIDatePicker** for a **UITextField**
     
     # Example #
     ```
     setUpPickerView()
     ```
     */
    fileprivate func setUpDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.locale = .current
        datePicker.minuteInterval = 10
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.hour, .minute], from: Date())
        let startDate = UserDefaults.standard.object(forKey: startingTimeString) as! Date
        let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
        let endDate = UserDefaults.standard.object(forKey: endingTimeString) as! Date
        let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
        if titleOption.text?.lowercased() == NSLocalizedString("StartingTime", comment: "").lowercased(){
            components.hour = startTimer.hour
            components.minute = startTimer.minute
            datePicker.setDate(startDate, animated: true)
            textField.text = formatter.string(from: startDate)
        } else if titleOption.text?.lowercased() == NSLocalizedString("EndingTime", comment: "").lowercased() {
            components.hour = endTimer.hour
            components.minute = endTimer.minute
            datePicker.setDate(endDate, animated: true)
            textField.text = formatter.string(from: endDate)
        }
        datePicker.addTarget(self, action: #selector(handleInput), for: .allEvents)
        
        self.addSubview(textField)
        setTextFieldConstraints()
        textField.inputView = datePicker
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        
        let toolBar       = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.contentView.frame.width, height: 40)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton    = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        let cancelButton  = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelClicked))
        cancelButton.tintColor = .red
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    //MARK: - SetUp MinutePicker
    
    /**
     Setting up a **UIDatePicker** for a **UITextField**
     
     # Example #
     ```
     setUpPickerView()
     ```
     */
    fileprivate func setUpMinutePicker() {
        let minutePicker = UIDatePicker()
        minutePicker.datePickerMode = .countDownTimer
        minutePicker.minuteInterval = 10
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
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(doneClicked))
        let cancelButton  = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelClicked))
        cancelButton.tintColor = .red
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
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
    
    @objc func cancelClicked(){
        textField.endEditing(true)
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
                let picker = textField.inputView as! UIPickerView
                textField.text = pickerArray[picker.selectedRow(inComponent: 0)]
                switch textField.text?.lowercased() {
                    case NSLocalizedString("nb", comment: "").lowercased():
                        setAppLanguage("nb")
                        break
                    case NSLocalizedString("en", comment: ""):
                        setAppLanguage("en")
                    default:
                        setAppLanguage("en")
                }
                let startDate = UserDefaults.standard.object(forKey: startingTimeString) as! Date
                let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
                let endDate = UserDefaults.standard.object(forKey: endingTimeString) as! Date
                let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
                var intervals = UserDefaults.standard.integer(forKey: reminderIntervalString)
                if intervals == 0 {
                    intervals = 60
                }
                let current = UNUserNotificationCenter.current()
                current.getPendingNotificationRequests { (pendingNotifcations) in
                    if !pendingNotifcations.isEmpty{
                        current.removeAllDeliveredNotifications()
                        current.removeAllPendingNotificationRequests()
                        setReminders(startTimer.hour ?? 8, endTimer.hour ?? 23, intervals)
                    }
                }
                break
            default:
                break
        }
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
        let days = Day.loadDays()
        let newGoal = Float(textField.text!)!
        if newGoal != 0 {
            days[days.count - 1].goal.amountOfDrink = newGoal
            print(days[days.count - 1].goal.amountOfDrink)
            Day.saveDays(days)
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
