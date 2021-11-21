////
////  SettingOptionCell.swift
////  reHydrate
////
////  Created by Petter vang Brakalsvålet on 24/04/2020.
////  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
////
//
//import UIKit
//import SwiftUI
//import CoreData
//import SwiftyUserDefaults
//
//class SettingOptionCell: UITableViewCell {
//    var pickerArray       = [""]
//    var componentString   = [""]
//    let picker            = UIPickerView()
//    var notificationStart = Int()
//    var notificationEnd   = Int()
//    let context = (UIApplication.shared.delegate as!
//                    AppDelegate).persistentContainer.viewContext
//    let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        formatter.locale = .current
//        return formatter
//    }()
//    var textField: UITextField   = {
//        let textField                = UITextField()
//        textField.placeholder        = "value"
//        textField.layer.borderWidth  = 2
//        textField.layer.cornerRadius = 5
//        textField.layer.borderColor  = UIColor.lightGray.cgColor
//        textField.font               = .body
//        textField.textAlignment      = .center
//        textField.setLeftPadding(10)
//        textField.setRightPadding(10)
//        return textField
//    }()
//    var roundedCell: UIView      = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    let titleOption: UILabel     = {
//        let lable   = UILabel()
//        lable.text  = "test"
//        lable.font  = .body
//        lable.translatesAutoresizingMaskIntoConstraints = false
//        return lable
//    }()
//    var buttonForCell: UIButton = {
//        let button = UIButton()
//        button.setTitle("", for: .normal)
//        button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    let subTitle: UILabel = {
//        let lable  = UILabel()
//        lable.text = "subText"
//        lable.font = .subTitle
//        lable.translatesAutoresizingMaskIntoConstraints = false
//        return lable
//    }()
//    var setting: String? {
//        didSet {
//            guard let string = setting else {return}
//            titleOption.text = string
//        }
//    }
//    var days: [Day] = []
//    let languageArray = [NSLocalizedString(appLanguages[0], comment: ""),
//                       NSLocalizedString(appLanguages[1], comment: ""),
//                       NSLocalizedString(appLanguages[2], comment: ""),
//                       NSLocalizedString(appLanguages[3], comment: "")]
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(roundedCell)
//        roundedCell.addSubview(titleOption)
//        roundedCell.addSubview(buttonForCell)
//        setTitleConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Setup UI
//    
//    /// Settes background constraints and rounds the corners depening on the position of the cell.
//    func setBackgroundConstraints(){
//        self.subviews.forEach({$0.removeConstraints($0.constraints)})
//        roundedCell.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
//        roundedCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
//        roundedCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
//        roundedCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
//    }
//    
//    /// Setting constraints for the background, tilte *UILable* and the button.
//    func setTitleConstraints(){
//        setBackgroundConstraints()
//        titleOption.leftAnchor.constraint(equalTo: roundedCell.leftAnchor, constant: 20).isActive = true
//        if self.contains(subTitle){
//            titleOption.centerYAnchor.constraint(equalTo: roundedCell.centerYAnchor, constant: -4).isActive = true
//        } else {
//            titleOption.centerYAnchor.constraint(equalTo: roundedCell.centerYAnchor).isActive = true
//        }
//        setButtonConstraints()
//    }
//    
//    /// Adds a subtitle under the title lable
//    /// - Parameter subtitle: : subTitle - the **String** you wnat to display under the title.
//    func addSubTitle(_ subtitle: String){
//        subTitle.text = subtitle
//        roundedCell.addSubview(subTitle)
//        setTitleConstraints()
//        subTitle.leftAnchor.constraint(equalTo: titleOption.leftAnchor, constant: 10).isActive = true
//        subTitle.topAnchor.constraint(equalTo: titleOption.bottomAnchor, constant: 2).isActive = true
//        subTitle.bottomAnchor.constraint(equalTo: roundedCell.bottomAnchor, constant: -4).isActive = true
//        setButtonConstraints()
//    }
//    
//    /// Setts the button constraints
//    func setButtonConstraints() {
//        buttonForCell.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        buttonForCell.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        buttonForCell.rightAnchor.constraint(equalTo: roundedCell.rightAnchor, constant: -20).isActive = true
//        buttonForCell.centerYAnchor.constraint(equalTo: roundedCell.centerYAnchor).isActive = true
//    }
//    
//    /// Setts the background constrains and the constraints for the *UITextField*
//    func setTextFieldConstraints() {
//        setBackgroundConstraints()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        textField.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        textField.centerYAnchor.constraint(equalTo: roundedCell.centerYAnchor).isActive = true
//        textField.rightAnchor.constraint(equalTo: roundedCell.rightAnchor, constant: -20).isActive = true
//    }
//    
//    /**
//     Sets the apparance of each cell
//     
//     # Example #
//     ```
//     cell.setCellApparance(dark, metric)
//     ```
//     */
//    func setCellApparance(_ dark: Bool,_ metric: Bool){
//        buttonForCell.tintColor         = dark ? .lightGray : .black
//        titleOption.textColor           = dark ? .white : .black
//        subTitle.textColor              = dark ? .white : .black
//        textField.textColor             = dark ? .white : .black
//        self.backgroundColor            = UIColor.tableViewBackground
//        roundedCell.backgroundColor     = UIColor.background
//        textField.layer.borderColor     = dark ? UIColor.lightGray.cgColor : UIColor.black.cgColor
//        textField.attributedPlaceholder = NSAttributedString(string: "value",
//                                                             attributes: [NSAttributedString.Key.foregroundColor :
//                                                                            dark ? UIColor.lightGray : UIColor.darkGray])
//        setSubviewApparance(dark, metric)
//        Defaults[\.darkMode] = dark
//        Defaults[\.metricUnits] = metric
//    }
//    
//    /**
//     Setts the apparances of the button
//     
//     # Example #
//     ```
//     setButtonApparance(dark, metric)
//     ```
//     */
//    private func setSubviewApparance(_ dark: Bool, _ metric: Bool) {
//        buttonForCell.isHidden = false
//        switch titleOption.text?.lowercased() {
//        case NSLocalizedString("DarkMode", comment: "").lowercased():
//            buttonForCell.setBackgroundImage(dark ? UIImage(systemName: "moon.circle.fill") :
//                                                UIImage(systemName: "circle"), for: .normal)
//        case NSLocalizedString("MetricSystem", comment: "").lowercased():
//            buttonForCell.setBackgroundImage(metric ? UIImage(systemName: "checkmark.circle.fill") :
//                                                UIImage(systemName: "circle"), for: .normal)
//        case NSLocalizedString("ImperialSystem", comment: "").lowercased():
//            buttonForCell.setBackgroundImage(!metric ? UIImage(systemName: "checkmark.circle.fill") :
//                                                UIImage(systemName: "circle"), for: .normal)
//        case NSLocalizedString("SetYourGoal", comment: "").lowercased():
//            textfieldApparanceGoal(metric)
//        case NSLocalizedString("TurnOnReminders", comment: "").lowercased(),
//             NSLocalizedString("TurnOffReminders", comment: "").lowercased():
//            buttonForCell.isHidden = false
//        case NSLocalizedString("StartingTime", comment: "").lowercased(),
//             NSLocalizedString("EndingTime", comment: "").lowercased():
//            setUpDatePicker()
//            buttonForCell.isHidden = true
//        case NSLocalizedString("Frequency", comment: "").lowercased():
//            buttonForCell.isHidden = true
//            setUpMinutePicker()
//        case NSLocalizedString("Language", comment: "").lowercased():
//            setLanguageApparance()
//        default:
//            buttonForCell.isHidden = true
//        }
//    }
//    
//    /**
//     Will change the apparance of the textfield with the goal to the metrics specified.
//     
//     - parameter metric: - Indicates if the user are using metric units or not..
//     
//     # Example #
//     ```
//     case NSLocalizedString("SetYourGoal", comment: "").lowercased():
//        textfieldApparanceGoal(metric)
//     ```
//     */
//    private func textfieldApparanceGoal(_ metric: Bool) {
//        buttonForCell.isHidden = true
//        days = fetchAllDays()
//        let day = fetchToday()
//        if metric {
//            textField.text = day.goal.clean
//        } else {
//            let measurement = Measurement(value: day.goal, unit: UnitVolume.liters)
//            textField.text  = measurement.converted(to: .imperialFluidOunces).value.clean
//        }
//        setUpPickerView()
//    }
//    
//    /**
//     Will change the apparance of the picker and its options.
//     
//     - parameter metric: - Indicates if the user are using metric units or not..
//     
//     # Example #
//     ```
//     case NSLocalizedString("SetYourGoal", comment: "").lowercased():
//        textfieldApparanceGoal(metric)
//     ```
//     */
//    private func setLanguageApparance() {
//        buttonForCell.isHidden = true
//        pickerArray = languageArray
//        componentString = [""]
//        setUpPickerView()
//        textField.placeholder = "language"
//        let picker = textField.inputView as! UIPickerView
//        let language = Defaults[\.appleLanguages]
//        if pickerArray.contains(NSLocalizedString(language.first!, comment: "")){
//            textField.text = NSLocalizedString(language.first!, comment: "")
//            picker.selectRow(pickerArray.firstIndex(of: NSLocalizedString(language.first!, comment: "")) ?? 0, inComponent: 0, animated: true)
//        } else {
//            textField.text = NSLocalizedString("en", comment: "")
//            picker.selectRow(pickerArray.firstIndex(of: NSLocalizedString("en", comment: "")) ?? 0, inComponent: 0, animated: true)
//        }
//    }
//    
//    /**
//     Creates an toolbar with a done and cancle button.
//     
//     # Example #
//     ```
//     let toolbar = getToolbar
//     ```
//     */
//    private func getToolbar() -> UIToolbar{
//        let toolbar = UIToolbar(frame: CGRect(origin: CGPoint.zero,
//                                              size: CGSize(width: contentView.frame.width,
//                                                           height: 40)))
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
//                                            target: nil,
//                                            action: nil)
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
//                                         target: self,
//                                         action: #selector(doneClicked))
//        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""),
//                                           style: .plain,
//                                           target: self,
//                                           action: #selector(cancelClicked))
//        cancelButton.tintColor = .red
//        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
//        toolbar.sizeToFit()
//        return toolbar
//    }
//    
//    // MARK: - Set-up PickerView
//    
//    /**
//     Setting up a **UIPickerView** for a **UITextField**
//     
//     # Example #
//     ```
//     setUpPickerView()
//     ```
//     */
//    private func setUpPickerView() {
//        self.addSubview(textField)
//        setTextFieldConstraints()
//        let toolBar = getToolbar()
//        textField.inputAccessoryView = toolBar
//        picker.frame = CGRect(x: 0,
//                              y: 0,
//                              width: contentView.bounds.width,
//                              height: 280)
//        picker.delegate = self
//        picker.dataSource = self
//        if titleOption.text?.lowercased() == NSLocalizedString("Language", comment: "").lowercased(){
//            textField.inputView = picker
//        } else if titleOption.text?.lowercased() == NSLocalizedString("SetYourGoal", comment: "").lowercased(){
//            textField.keyboardType = .decimalPad
//            textField.delegate = self
//        }
//    }
//    
//    // MARK: - SetUp DatePicker
//    
//    /**
//     Setting up a **UIDatePicker** for a **UITextField**
//     
//     # Example #
//     ```
//     setUpPickerView()
//     ```
//     */
//    private func setUpDatePicker() {
//        let datePicker: UIDatePicker = {
//            let picker = UIDatePicker()
//            picker.locale = .current
//            picker.minuteInterval = 10
//            picker.datePickerMode = .time
//            picker.preferredDatePickerStyle = .wheels
//            picker.sizeToFit()
//            return picker
//        }()
//        let calendar = NSCalendar.current
//        var components = calendar.dateComponents([.hour, .minute], from: Date())
//        let startDate = Defaults[\.startingTime]
//        let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
//        let endDate = Defaults[\.endingTime]
//        let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
//        if titleOption.text?.lowercased() == NSLocalizedString("StartingTime", comment: "").lowercased(){
//            components.hour = startTimer.hour
//            components.minute = startTimer.minute
//            datePicker.setDate(startDate, animated: true)
//            textField.text = formatter.string(from: startDate)
//        } else if titleOption.text?.lowercased() == NSLocalizedString("EndingTime", comment: "").lowercased() {
//            components.hour = endTimer.hour
//            components.minute = endTimer.minute
//            datePicker.setDate(endDate, animated: true)
//            textField.text = formatter.string(from: endDate)
//        }
//        datePicker.addTarget(self, action: #selector(handleInput), for: .allEvents)
//        self.addSubview(textField)
//        setTextFieldConstraints()
//        textField.inputView = datePicker
//        let toolbar = getToolbar()
//        textField.inputAccessoryView = toolbar
//    }
//    
//    // MARK: - SetUp MinutePicker
//    
//    /**
//     Setting up a **UIDatePicker** for a **UITextField**
//     
//     # Example #
//     ```
//     setUpPickerView()
//     ```
//     */
//    private func setUpMinutePicker() {
//        let minutePicker = UIDatePicker()
//        minutePicker.datePickerMode = .countDownTimer
//        minutePicker.minuteInterval = 10
//        var components = DateComponents()
//        components.minute = Defaults[\.reminderInterval]
//        let date = Calendar.current.date(from: components)!
//        minutePicker.setDate(date, animated: false)
//        minutePicker.addTarget(self, action: #selector(handleInput), for: .allEvents)
//        minutePicker.preferredDatePickerStyle = .wheels
//        minutePicker.sizeToFit()
//        
//        self.addSubview(textField)
//        setTextFieldConstraints()
//        textField.inputView = minutePicker
//        textField.text = formatter.string(from: minutePicker.date)
//        
//        let toolBar = getToolbar()
//        textField.inputAccessoryView = toolBar
//    }
//    
//    /**
//     handles the imput for the UIDatePicker
//     
//     - parameter sender: - The UIDatePicker that called the function.
//     
//     # Example #
//     ```
//     minutePicker.addTarget(self, action: #selector(handleInput), for: .allEvents)
//     ```
//     */
//    @objc func handleInput(_ sender: UIDatePicker ){
//        switch titleOption.text?.lowercased() {
//        case NSLocalizedString("StartingTime", comment: "").lowercased():
//            let startDate = sender.date
//            var endDate = Defaults[\.endingTime]
//            if endDate <= startDate {
//                endDate = endDate - 1 * 60
//                sender.setDate(endDate, animated: true)
//            }
//            Defaults[\.startingTime] = startDate
//        case NSLocalizedString("EndingTime", comment: "").lowercased():
//            let endDate = sender.date
//            var startDate = Defaults[\.startingTime]
//            if endDate <= startDate {
//                startDate = startDate + 1 * 60
//                sender.setDate(startDate, animated: true)
//            }
//            Defaults[\.endingTime] = endDate
//        case NSLocalizedString("Frequency", comment: "").lowercased():
//            if sender.countDownDuration > 2.5 * 60 * 60{
//                var components = DateComponents()
//                components.hour = 2
//                components.minute = 50
//                let date = Calendar.current.date(from: components)!
//                sender.setDate(date, animated: true)
//            }
//        default:
//            break
//        }
//        textField.text = formatter.string(from: sender.date)
//    }
//    
//    /**
//     will cancle the edits and close the keyboard
//     
//     # Example #
//     ```
//     let cancelButton  = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelClicked))
//     ```
//     */
//    @objc func cancelClicked(){
//        textField.endEditing(true)
//    }
//    
//    @objc func doneClicked(){
//        textField.endEditing(true)
//        switch titleOption.text?.lowercased() {
//        case NSLocalizedString("SetYourGoal", comment: "").lowercased():
//            updateGoal()
//        case NSLocalizedString("StartingTime", comment: "").lowercased(),
//             NSLocalizedString("EndingTime", comment: "").lowercased():
//            handleRemindersOptions()
//        case NSLocalizedString("Frequency", comment: "").lowercased():
//            handleFrequencyOptions()
//        case NSLocalizedString("Language", comment: "").lowercased():
//            handleLanguageOptions()
//        default:
//            break
//        }
//    }
//    
//    /**
//     will set reminders and notify the user that reminders has been set between the times specified by the user.
//     
//     # Example #
//     ```
//     case NSLocalizedString("StartingTime", comment: "").lowercased(),
//        NSLocalizedString("EndingTime", comment: "").lowercased():
//        handleRemindersOptions()
//     ```
//     */
//    private func handleRemindersOptions() {
//        let startDate = Defaults[\.startingTime]
//        let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
//        let endDate = Defaults[\.endingTime]
//        let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
//        let intervals = Defaults[\.reminderInterval]
//        setReminders(startDate, endDate, intervals)
//        sendToastMessage("\(NSLocalizedString("RemindersSetFrom", comment: "starting of toas message")) \(startTimer.hour!) \(NSLocalizedString("To", comment: "splitter for toast")) \(endTimer.hour!)", 4)
//    }
//    
//    /**
//     will set the frequensy of the reminders and notify the user that reminders has been in the frequency specified by the user.
//     
//     # Example #
//     ```
//     case NSLocalizedString("Frequency", comment: "").lowercased():
//         handleFrequencyOptions()
//     ```
//     */
//    private func handleFrequencyOptions() {
//        let picker = textField.inputView as! UIDatePicker
//        if picker.countDownDuration > 2.5 * 60 * 60{
//            var components = DateComponents()
//            components.hour = 2
//            components.minute = 50
//            let date = Calendar.current.date(from: components)!
//            picker.setDate(date, animated: true)
//        }
//        textField.text = formatter.string(from: picker.date)
//        
//        let calendar = Calendar.current
//        
//        let currentDateComponent = calendar.dateComponents([.hour, .minute], from: picker.date)
//        let numberOfMinutes = (currentDateComponent.hour! * 60) + currentDateComponent.minute!
//        
//        print("numberOfMinutes : ", numberOfMinutes)
//        Defaults[\.reminderInterval] = numberOfMinutes
//        let startDate = Defaults[\.startingTime]
//        let endDate = Defaults[\.endingTime]
//        setReminders(startDate, endDate, numberOfMinutes)
//        sendToastMessage("\(NSLocalizedString("FrequencyReminder", comment: "start of frequency toast")) \(numberOfMinutes) \(NSLocalizedString("Minutes", comment: "end of frquency toast"))", 4)
//    }
//    
//    /**
//     will change the app language to the language specified by the user.
//     
//     # Example #
//     ```
//     case NSLocalizedString("Language", comment: "").lowercased():
//        handleLanguageOptions()
//     ```
//     */
//    private func handleLanguageOptions() {
//        let picker = textField.inputView as! UIPickerView
//        textField.text = pickerArray[picker.selectedRow(inComponent: 0)]
//        switch textField.text?.lowercased() {
//        case NSLocalizedString("nb", comment: "").lowercased():
//            setAppLanguage("nb")
//        case NSLocalizedString("en", comment: "").lowercased():
//            setAppLanguage("en")
//        case NSLocalizedString("de", comment: "").lowercased():
//            setAppLanguage("de")
//        case NSLocalizedString("is", comment: "").lowercased():
//            setAppLanguage("is")
//        default:
//            setAppLanguage("en")
//        }
//        let startDate = Defaults[\.startingTime]
//        let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
//        let endDate = Defaults[\.endingTime]
//        let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
//        var intervals = Defaults[\.reminderInterval]
//        if intervals == 0 {
//            intervals = 60
//        }
//        let current = UNUserNotificationCenter.current()
//        current.getPendingNotificationRequests { (pendingNotifcations) in
//            if !pendingNotifcations.isEmpty{
//                current.removeAllDeliveredNotifications()
//                current.removeAllPendingNotificationRequests()
//                setReminders(startTimer.date!, endTimer.date!, intervals)
//            }
//        }
//    }
//    
//    /**
//     Will create a toast message and display it on the bottom of the screen.
//     
//     - parameter message: - **String** that will be displayed on the screen.
//     - parameter messageDelay: - a **Double** of how long the message will be displayed.
//     
//     # Example #
//     ```
//     sendToastMessage("Reminders set for every 30 minutes from 7 am to 11 pm", 3.5)
//     ```
//     */
//    func sendToastMessage(_ message: String, _ messageDelay: Double) {
//        let toastLabel = UIButton()
//        toastLabel.setTitle(message, for: .normal)
//        toastLabel.titleLabel?.font          = .body
//        toastLabel.titleLabel?.textAlignment = .center
//        toastLabel.titleLabel?.numberOfLines = 0
//        toastLabel.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
//        if titleOption.textColor == UIColor.white {
//            toastLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
//            toastLabel.setTitleColor(UIColor.white, for: .normal)
//        } else {
//            toastLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
//            toastLabel.setTitleColor(UIColor.black, for: .normal)
//        }
//        toastLabel.isUserInteractionEnabled = false
//        toastLabel.layer.cornerRadius       = 10
//        toastLabel.clipsToBounds            = true
//        toastLabel.alpha                    = 1
//        self.superview!.superview!.addSubview(toastLabel)
//        toastLabel.translatesAutoresizingMaskIntoConstraints = false
//        toastLabel.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor).isActive                      = true
//        toastLabel.centerYAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: -100).isActive       = true
//        toastLabel.leftAnchor.constraint(greaterThanOrEqualTo: self.superview!.leftAnchor, constant: 50).isActive = true
//        toastLabel.rightAnchor.constraint(lessThanOrEqualTo: self.superview!.rightAnchor, constant: -50).isActive = true
//        toastLabel.sizeToFit()
//        UIView.animate(withDuration: 0.5, delay: messageDelay, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//        }, completion: {(_) in
//            toastLabel.removeFromSuperview()
//        })
//    }
//    
//    /**
//     will get all the days and change the goal for today and save the changes.
//     
//     # Example #
//     ```
//     case NSLocalizedString("SetYourGoal", comment: "").lowercased():
//         updateGoal()
//     ```
//     */
//    func updateGoal(){
//        days = fetchAllDays()
//        let newGoal = Double(textField.text!)!
//        let day = fetchToday()
//        
//        if newGoal > 0 {
//            day.goal = Double(newGoal)
//        } else {
//            textField.text = day.goal.clean
//        }
//        saveDays()
//    }
//    
//    override func prepareForReuse() {
//        self.subTitle.removeFromSuperview()
//        self.textField.removeFromSuperview()
//        titleOption.text = ""
//        subTitle.text = ""
//        self.removeConstraints(self.constraints)
//    }
//}
//
//extension SettingOptionCell: UIPickerViewDelegate, UIPickerViewDataSource{
//    
//    // MARK: - UIPickerVeiw
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        if NSLocalizedString("Language", comment: "") == titleOption.text {
//            return 1
//        } else {
//            return 4
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if NSLocalizedString("Language", comment: "") == titleOption.text {
//            return pickerArray.count
//        } else {
//            switch component {
//            case 0, 1, 3:
//                return pickerArray.count
//            case 2:
//                return 1
//            default:
//                return 0
//            }
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if NSLocalizedString("Language", comment: "") == titleOption.text {
//            return pickerArray[row]
//        } else {
//            switch component {
//            case 0, 1, 3:
//                return pickerArray[row]
//            case 2:
//                return "."
//            default:
//                return ""
//            }
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        if NSLocalizedString("Language", comment: "") == titleOption.text {
//            return 150
//        } else {
//            return 35
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 40
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if NSLocalizedString("Language", comment: "") == titleOption.text {
//            updateTextField(pickerArray[row], component)
//        } else {
//            switch component {
//            case 0, 1, 3:
//                updateTextField(pickerArray[row], component)
//            case 2:
//                updateTextField(".", component)
//            default:
//                break
//            }
//        }
//    }
//    
//    func updateTextField(_ input: String, _ component: Int){
//        textField.text = ""
//        componentString[component] = input
//        if componentString[0] == "0" {
//            componentString[0] = ""
//        }
//        for number in componentString {
//            textField.text = textField.text! + number
//        }
//    }
//}
//
//
//extension SettingOptionCell: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.selectAll(self)
//    }
//}
