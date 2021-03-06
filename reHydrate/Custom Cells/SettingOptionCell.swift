//
//  SettingOptionCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 24/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

class SettingOptionCell: UITableViewCell {
    enum cellPosition {
        case none
        case top
        case mid
        case bot
    }
    var pickerArray       = [""]
    var componentString   = [""]
    let picker            = UIPickerView()
    var notificationStart = Int()
    var notificationEnd   = Int()
    let context = (UIApplication.shared.delegate as!
                    AppDelegate).persistentContainer.viewContext
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        return formatter
    }()
    var textField: UITextField   = {
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
    var roundedCell: UIView      = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleOption: UILabel     = {
        let lable   = UILabel()
        lable.text  = "test"
        lable.font  = UIFont(name: "AmericanTypewriter", size: 16)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var buttonForCell: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        if #available(iOS 13.0, *) {
            button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            button.setBackgroundImage(UIImage(named: "checkmark.circle.fill"), for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let subTitle: UILabel = {
        let lable  = UILabel()
        lable.text = "subText"
        lable.font = UIFont(name: "AmericanTypewriter", size: 11)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var setting: String? {
        didSet {
            guard let string 	= setting else {return}
            titleOption.text 	= string
        }
    }
    var days: [Day] = []
    var position: cellPosition = .none
    let languageArray = [NSLocalizedString(appLanguages[0], comment: ""),
                       NSLocalizedString(appLanguages[1], comment: ""),
                       NSLocalizedString(appLanguages[2], comment: ""),
                       NSLocalizedString(appLanguages[3], comment: "")]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(roundedCell)
        roundedCell.addSubview(titleOption)
        roundedCell.addSubview(buttonForCell)
        setTitleConstraints()
        separatorInset.right = 20
        separatorInset.left  = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    /// Settes background constraints and rounds the corners depening on the position of the cell.
    func setBackgroundConstraints(){
        self.subviews.forEach({$0.removeConstraints($0.constraints)})
        roundedCell.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive       = true
        roundedCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        roundedCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive    = true
        roundedCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        switch position {
        case .top:
            roundedCell.roundCorners(corners: [.topLeft, .topRight], amount: 10)
        case .mid:
            roundedCell.roundCorners(corners: [])
        case .bot:
            roundedCell.roundCorners(corners: [.bottomLeft, .bottomRight], amount: 10)
        default:
            roundedCell.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], amount: 10)
        }
    }
    
    /// Adds a subtitle under the title lable
    /// - Parameter subtitle: : subTitle - the **String** you wnat to display under the title.
    func addSubTitle(_ subtitle: String){
        subTitle.text = subtitle
        roundedCell.addSubview(subTitle)
        setTitleConstraints()
        subTitle.leftAnchor.constraint(equalTo: titleOption.leftAnchor, constant: 10).isActive           = true
        subTitle.centerYAnchor.constraint(equalTo: roundedCell.centerYAnchor, constant: 15).isActive     = true
        setButtonConstraints()
    }
    
    /// Setting constraints for the background, tilte *UILable* and the button.
    func setTitleConstraints(){
        setBackgroundConstraints()
        titleOption.leftAnchor.constraint(equalTo: roundedCell.leftAnchor, constant: 20).isActive = true
        titleOption.centerYAnchor.constraint(equalTo: roundedCell.centerYAnchor).isActive         = true
        setButtonConstraints()
    }
    
    /// Setts the button constraints
    func setButtonConstraints() {
        buttonForCell.widthAnchor.constraint(equalToConstant: 25).isActive                             = true
        buttonForCell.heightAnchor.constraint(equalToConstant: 25).isActive                            = true
        buttonForCell.rightAnchor.constraint(equalTo: roundedCell.rightAnchor, constant: -20).isActive = true
        buttonForCell.centerYAnchor.constraint(equalTo: roundedCell.centerYAnchor).isActive            = true
    }
    
    /// Setts the background constrains and the constraints for the *UITextField*
    func setTextFieldConstraints() {
        setBackgroundConstraints()
        textField.translatesAutoresizingMaskIntoConstraints                                        = false
        textField.heightAnchor.constraint(equalToConstant: 25).isActive                            = true
        textField.widthAnchor.constraint(equalToConstant: 100).isActive                            = true
        textField.centerYAnchor.constraint(equalTo: roundedCell.centerYAnchor).isActive            = true
        textField.rightAnchor.constraint(equalTo: roundedCell.rightAnchor, constant: -20).isActive = true
    }
    
    /**
     Calles a method to change the apparance of each cell
     
     # Example #
     ```
     setCellApparance(darkMode)
     ```
     */
    func setCellApparance(_ dark: Bool,_ metric: Bool){
        changeTheme(dark)
        switch titleOption.text?.lowercased() {
        case NSLocalizedString("DarkMode", comment: "").lowercased():
            buttonApparanceDarkMode(dark)
        case NSLocalizedString("MetricSystem", comment: "").lowercased():
            buttonApparanceMetrics(metric, dark)
        case NSLocalizedString("ImperialSystem", comment: "").lowercased():
            buttonApparanceImperial(metric, dark)
        case NSLocalizedString("SetYourGoal", comment: "").lowercased():
            textfieldApparanceGoal(metric)
        case NSLocalizedString("TurnOnReminders", comment: "").lowercased(),
             NSLocalizedString("TurnOffReminders", comment: "").lowercased():
            buttonForCell.isHidden = false
        case NSLocalizedString("StartingTime", comment: "").lowercased(),
             NSLocalizedString("EndingTime", comment: "").lowercased():
            setUpDatePicker()
            buttonForCell.isHidden = true
        case NSLocalizedString("Frequency", comment: "").lowercased():
            buttonForCell.isHidden = true
            setUpMinutePicker()
        case NSLocalizedString("Language", comment: "").lowercased():
            setLanguageApparance()
        default:
            buttonForCell.isHidden = true
        }
        UserDefaults.standard.set(dark, forKey: darkModeString)
        UserDefaults.standard.set(metric, forKey: metricUnitsString)
    }
    
    
    /**
     This method will change the theme of the app.
     
     - parameter dark: -  Indecating if the theme is light or dark mode.
     
     # Example #
     ```
        changeTheme(dark)
     ```
     */
    fileprivate func changeTheme(_ dark: Bool) {
        if dark{
            buttonForCell.tintColor         = .lightGray
            titleOption.textColor           = .white
            subTitle.textColor              = .white
            textField.textColor             = .white
            self.backgroundColor            = UIColor().hexStringToUIColor("#212121")
            roundedCell.backgroundColor     = UIColor().hexStringToUIColor("#303030")
            textField.layer.borderColor     = UIColor.lightGray.cgColor
            textField.attributedPlaceholder = NSAttributedString(string: "value", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        } else {
            buttonForCell.tintColor         = .black
            titleOption.textColor           = .black
            subTitle.textColor              = .black
            textField.textColor             = .black
            self.backgroundColor            = UIColor().hexStringToUIColor("ebebeb")
            roundedCell.backgroundColor     = .white
            textField.layer.borderColor     = UIColor.darkGray.cgColor
            textField.attributedPlaceholder = NSAttributedString(string: "value", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        }
    }
    
    /**
     Will change the button apparance for dark mode cell
     
     - parameter dark: - Indecating if the theme is light or dark mode.
     
     # Example #
     ```
     case NSLocalizedString("DarkMode", comment: "").lowercased():
         buttonApparanceDarkMode(dark)
     ```
     */
    fileprivate func buttonApparanceDarkMode(_ dark: Bool) {
        buttonForCell.isHidden = false
        if dark{
            if #available(iOS 13.0, *) {
                buttonForCell.setBackgroundImage(UIImage(systemName: "moon.circle.fill"), for: .normal)
            } else {
                buttonForCell.setBackgroundImage(UIImage(named: "moon.circle.fill")?.colored(.gray), for: .normal)
            }
        } else {
            if #available(iOS 13.0, *) {
                buttonForCell.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            } else {
                buttonForCell.setBackgroundImage(UIImage(named: "selection.circle")?.colored(.black), for: .normal)
            }
        }
    }
    
    /**
     Will change the button apparance for the metrics cell
     
     - parameter metric: - Indicates if the user are using metric units or not..
     - parameter dark: -  Indecating if the theme is light or dark mode.
    
     # Example #
     ```
     case NSLocalizedString("MetricSystem", comment: "").lowercased():
        buttonApparanceMetrics(metric, dark)
     ```
     */
    fileprivate func buttonApparanceMetrics(_ metric: Bool, _ dark: Bool) {
        buttonForCell.isHidden = false
        if metric{
            if #available(iOS 13.0, *) {
                buttonForCell.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            } else {
                if dark {
                    buttonForCell.setBackgroundImage(UIImage(named: "checkmark.circle.fill")?.colored(.gray), for: .normal)
                } else {
                    buttonForCell.setBackgroundImage(UIImage(named: "checkmark.circle.fill")?.colored(.black), for: .normal)
                }
            }
        } else {
            if #available(iOS 13.0, *) {
                buttonForCell.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            } else {
                if dark {
                    buttonForCell.setBackgroundImage(UIImage(named: "selection.circle")?.colored(.gray), for: .normal)
                } else {
                    buttonForCell.setBackgroundImage(UIImage(named: "selection.circle")?.colored(.black), for: .normal)
                }
            }
        }
    }
    
    /**
     Will change the button apparance for the imperial cell
     
     - parameter metric: - Indicates if the user are using metric units or not..
     - parameter dark: -  Indecating if the theme is light or dark mode.
    
     # Example #
     ```
     case NSLocalizedString("MetricSystem", comment: "").lowercased():
        buttonApparanceMetrics(metric, dark)
     ```
     */
    fileprivate func buttonApparanceImperial(_ metric: Bool, _ dark: Bool) {
        buttonForCell.isHidden = false
        if !metric{
            if #available(iOS 13.0, *) {
                buttonForCell.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            } else {
                if dark {
                    buttonForCell.setBackgroundImage(UIImage(named: "checkmark.circle.fill")?.colored(.gray), for: .normal)
                } else {
                    buttonForCell.setBackgroundImage(UIImage(named: "checkmark.circle.fill")?.colored(.black), for: .normal)
                }
            }
        } else {
            if #available(iOS 13.0, *) {
                buttonForCell.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            } else {
                if dark {
                    buttonForCell.setBackgroundImage(UIImage(named: "selection.circle")?.colored(.gray), for: .normal)
                } else {
                    buttonForCell.setBackgroundImage(UIImage(named: "selection.circle")?.colored(.black), for: .normal)
                }
            }
        }
    }
    
    /**
     Will change the apparance of the textfield with the goal to the metrics specified.
     
     - parameter metric: - Indicates if the user are using metric units or not..
     
     # Example #
     ```
     case NSLocalizedString("SetYourGoal", comment: "").lowercased():
        textfieldApparanceGoal(metric)
     ```
     */
    fileprivate func textfieldApparanceGoal(_ metric: Bool) {
        buttonForCell.isHidden = true
        days = fetchAllDays()
        let day = fetchToday()
        if metric {
            textField.text = day.goal.clean
        } else {
            let measurement = Measurement(value: day.goal, unit: UnitVolume.liters)
            textField.text  = measurement.converted(to: .imperialFluidOunces).value.clean
        }
        setUpPickerView()
    }
    
    /**
     Will change the apparance of the picker and its options.
     
     - parameter metric: - Indicates if the user are using metric units or not..
     
     # Example #
     ```
     case NSLocalizedString("SetYourGoal", comment: "").lowercased():
        textfieldApparanceGoal(metric)
     ```
     */
    fileprivate func setLanguageApparance() {
        buttonForCell.isHidden = true
        pickerArray     = languageArray
        componentString = [""]
        setUpPickerView()
        textField.placeholder = "language"
        let picker = textField.inputView as! UIPickerView
        let language = UserDefaults.standard.array(forKey: appleLanguagesString) as! [String]
        if pickerArray.contains(NSLocalizedString(language.first!, comment: "")){
            textField.text = NSLocalizedString(language.first!, comment: "")
            picker.selectRow(pickerArray.firstIndex(of: NSLocalizedString(language.first!, comment: "")) ?? 0, inComponent: 0, animated: true)
        } else {
            textField.text = NSLocalizedString("en", comment: "")
            picker.selectRow(pickerArray.firstIndex(of: NSLocalizedString("en", comment: "")) ?? 0, inComponent: 0, animated: true)
        }
    }
    
    // MARK: - Set-up PickerView
    
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
        if titleOption.text?.lowercased() == NSLocalizedString("Language", comment: "").lowercased(){
            textField.inputView = picker
        } else if titleOption.text?.lowercased() == NSLocalizedString("SetYourGoal", comment: "").lowercased(){
            textField.keyboardType = .decimalPad
            textField.delegate = self
        }
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
        let datePicker : UIDatePicker = {
            let picker = UIDatePicker()
            picker.locale = .current
            picker.minuteInterval = 10
            picker.datePickerMode = .time
            return picker
        }()
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
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
        let toolBar       = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.contentView.frame.width, height: 40)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton    = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        let cancelButton  = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelClicked))
        cancelButton.tintColor = .red
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    // MARK: - SetUp MinutePicker
    
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
        if #available(iOS 14, *) {
            minutePicker.preferredDatePickerStyle = .wheels
            minutePicker.sizeToFit()
        }
        
        self.addSubview(textField)
        setTextFieldConstraints()
        textField.inputView = minutePicker
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
    
    /**
     handles the imput for the UIDatePicker
     
     - parameter sender: - The UIDatePicker that called the function.
     
     # Example #
     ```
     minutePicker.addTarget(self, action: #selector(handleInput), for: .allEvents)
     ```
     */
    @objc func handleInput(_ sender: UIDatePicker ){
        switch titleOption.text?.lowercased() {
        case NSLocalizedString("StartingTime", comment: "").lowercased():
            let startDate = sender.date
            var endDate = UserDefaults.standard.object(forKey: endingTimeString) as! Date
            if endDate <= startDate {
                endDate = endDate - 1 * 60
                sender.setDate(endDate, animated: true)
            }
            UserDefaults.standard.set(startDate, forKey: startingTimeString)
        case NSLocalizedString("EndingTime", comment: "").lowercased():
            let endDate = sender.date
            var startDate = UserDefaults.standard.object(forKey: startingTimeString) as! Date
            if endDate <= startDate {
                startDate = startDate + 1 * 60
                sender.setDate(startDate, animated: true)
            }
            UserDefaults.standard.set(endDate, forKey: endingTimeString)
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
    
    /**
     will cancle the edits and close the keyboard
     
     # Example #
     ```
     let cancelButton  = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelClicked))
     ```
     */
    @objc func cancelClicked(){
        textField.endEditing(true)
    }
    
    @objc func doneClicked(){
        textField.endEditing(true)
        switch titleOption.text?.lowercased() {
        case NSLocalizedString("SetYourGoal", comment: "").lowercased():
            updateGoal()
        case NSLocalizedString("StartingTime", comment: "").lowercased(),
             NSLocalizedString("EndingTime", comment: "").lowercased():
            handleRemindersOptions()
        case NSLocalizedString("Frequency", comment: "").lowercased():
            handleFrequencyOptions()
        case NSLocalizedString("Language", comment: "").lowercased():
            handleLanguageOptions()
        default:
            break
        }
    }
    
    /**
     will set reminders and notify the user that reminders has been set between the times specified by the user.
     
     # Example #
     ```
     case NSLocalizedString("StartingTime", comment: "").lowercased(),
        NSLocalizedString("EndingTime", comment: "").lowercased():
        handleRemindersOptions()
     ```
     */
    fileprivate func handleRemindersOptions() {
        let startDate = UserDefaults.standard.object(forKey: startingTimeString) as! Date
        let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
        let endDate = UserDefaults.standard.object(forKey: endingTimeString) as! Date
        let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
        let intervals = UserDefaults.standard.integer(forKey: reminderIntervalString)
        setReminders(startDate, endDate, intervals)
        sendToastMessage("\(NSLocalizedString("RemindersSetFrom", comment: "starting of toas message")) \(startTimer.hour!) \(NSLocalizedString("To", comment: "splitter for toast")) \(endTimer.hour!)", 4)
    }
    
    /**
     will set the frequensy of the reminders and notify the user that reminders has been in the frequency specified by the user.
     
     # Example #
     ```
     case NSLocalizedString("Frequency", comment: "").lowercased():
         handleFrequencyOptions()
     ```
     */
    fileprivate func handleFrequencyOptions() {
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
        let endDate = UserDefaults.standard.object(forKey: endingTimeString) as! Date
        setReminders(startDate, endDate, numberOfMinutes)
        sendToastMessage("\(NSLocalizedString("FrequencyReminder", comment: "start of frequency toast")) \(numberOfMinutes) \(NSLocalizedString("Minutes", comment: "end of frquency toast"))", 4)
    }
    
    /**
     will change the app language to the language specified by the user.
     
     # Example #
     ```
     case NSLocalizedString("Language", comment: "").lowercased():
        handleLanguageOptions()
     ```
     */
    fileprivate func handleLanguageOptions() {
        let picker = textField.inputView as! UIPickerView
        textField.text = pickerArray[picker.selectedRow(inComponent: 0)]
        switch textField.text?.lowercased() {
        case NSLocalizedString("nb", comment: "").lowercased():
            setAppLanguage("nb")
        case NSLocalizedString("en", comment: "").lowercased():
            setAppLanguage("en")
        case NSLocalizedString("de", comment: "").lowercased():
            setAppLanguage("de")
        case NSLocalizedString("is", comment: "").lowercased():
            setAppLanguage("is")
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
                setReminders(startTimer.date!, endTimer.date!, intervals)
            }
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
        }, completion: {(_) in
            toastLabel.removeFromSuperview()
        })
    }
    
    /**
     will get all the days and change the goal for today and save the changes.
     
     # Example #
     ```
     case NSLocalizedString("SetYourGoal", comment: "").lowercased():
         updateGoal()
     ```
     */
    func updateGoal(){
        days = fetchAllDays()
        let newGoal = Double(textField.text!)!
        let day = fetchToday()
        
        if newGoal > 0 {
            day.goal = Double(newGoal)
        } else {
            textField.text = day.goal.clean
        }
        saveDays()
    }
    
    override func prepareForReuse() {
        self.subTitle.removeFromSuperview()
        self.textField.removeFromSuperview()
        titleOption.text = ""
        subTitle.text = ""
        self.removeConstraints(self.constraints)
    }
}

extension SettingOptionCell: UIPickerViewDelegate, UIPickerViewDataSource{
    
    // MARK: - UIPickerVeiw
    
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


extension SettingOptionCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(self)
    }
}

extension UIView {
    enum Corner:Int {
        case bottomRight = 0,
             topRight,
             bottomLeft,
             topLeft
    }
    
    private func parseCorner(corner: Corner) -> CACornerMask.Element {
        let corners: [CACornerMask.Element] = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        return corners[corner.rawValue]
    }
    
    private func createMask(corners: [Corner]) -> UInt {
        return corners.reduce(0, { (a, b) -> UInt in
            return a + parseCorner(corner: b).rawValue
        })
    }
    
    func roundCorners(corners: [Corner], amount: CGFloat = 5) {
        layer.cornerRadius = amount
        let maskedCorners: CACornerMask = CACornerMask(rawValue: createMask(corners: corners))
        layer.maskedCorners = maskedCorners
    }
}
