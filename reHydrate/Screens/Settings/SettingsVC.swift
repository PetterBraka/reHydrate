//
//  Settings.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import Hero
import UIKit
import HealthKit
import MessageUI

struct settingOptions {
    var isOpened: Bool
    var setting:  String
    var options:  [String]
}

class SettingsVC: UIViewController {
    
    // MARK: - Variabels
    let defaults                   = UserDefaults.standard
    var tableView: UITableView     = UITableView(frame: .null, style: .insetGrouped)
    var exitButton: UIButton       = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var darkMode = true {
        didSet {
            self.overrideUserInterfaceStyle = darkMode ? .dark : .light
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkMode ? .lightContent : .darkContent
    }
    var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    var metricUnits                = true
    var selectedRow: IndexPath     = IndexPath()
    var settings: [settingOptions] = [
        settingOptions(isOpened: false, setting: NSLocalizedString("Appearance", comment: "Header title"),
                       options: [NSLocalizedString("DarkMode", comment: "settings option"),
                                 NSLocalizedString("Language", comment: "setting option")]),
        settingOptions(isOpened: false, setting: NSLocalizedString("UnitSystem", comment: "Header title"),
                       options: [NSLocalizedString("MetricSystem", comment: "settings option"),
                                 NSLocalizedString("ImperialSystem", comment: "settings option")]),
        settingOptions(isOpened: false, setting: NSLocalizedString("ChangeGoal", comment: "Header title"),
                       options: [NSLocalizedString("SetYourGoal", comment: "settings option")]),
        settingOptions(isOpened: false, setting: NSLocalizedString("Reminders", comment: "Header title"),
                       options: [NSLocalizedString("TurnOnReminders", comment: "settings option")]),
        settingOptions(isOpened: false, setting: NSLocalizedString("Credits", comment: "Header title"),
                       options: [NSLocalizedString("Credits", comment: "settings option")]),
        settingOptions(isOpened: false, setting: NSLocalizedString("DangerZone", comment: "Header title"),
                       options: [NSLocalizedString("OpenAppSettings", comment: "settings option"),
                                 NSLocalizedString("OpenHealthApp", comment: "settings option"),
                                 NSLocalizedString("RemoveData", comment: "settings option")]),
        settingOptions(isOpened: false, setting: NSLocalizedString("Introductions", comment: "Header title"),
                       options: [NSLocalizedString("HowToUse", comment: "How to use the app"),
                                 NSLocalizedString("DevInsta", comment: "Developers instagram account"),
                                 NSLocalizedString("FeatureRequest", comment: "Link to github and feature requests"),
                                 NSLocalizedString("ReportBug", comment: "Link to github and bug reports"),
                                 NSLocalizedString("ContactUs", comment: "Link to devs twitter"),
                                 NSLocalizedString("PrivacyPolicy", comment: "Link to the apps privacy policy"),
                                 NSLocalizedString("VersionNumber", comment: "Disply version of app")])]
    var days: [Day] = []
    let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Tap controller
    
    /**
     Will check which **view** that called this function.
     
     - parameter sender: - **view** that called the function.
     
     */
    @objc func tap(_ sender: UIGestureRecognizer){
        switch sender.view {
        case exitButton:
            defaults.set(darkMode, forKey: darkModeString)
            defaults.set(metricUnits, forKey: metricUnitsString)
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
            defaults.set(darkMode, forKey: darkModeString)
            defaults.set(metricUnits, forKey: metricUnitsString)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settings[3].isOpened = defaults.bool(forKey: remindersString)
        metricUnits = defaults.bool(forKey: metricUnitsString)
        darkMode = defaults.bool(forKey: darkModeString)
        
        setUpUI()
        updateSettings()
        setAppearance()
        view.heroID = "settings"
    }
    
    // MARK: - Set up of UI
    
    ///Will set up the UI and must be called at the launche of the view.
    fileprivate func setUpUI(){
        self.view.addSubview(exitButton)
        self.view.addSubview(tableView)
        
        setUpGestrues()
        setConstraints()
        
        tableView.register(SettingOptionCell.self, forCellReuseIdentifier: "settingCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 16
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
    }
    
    /// Sets up gesture recognizers.
    fileprivate func setUpGestrues(){
        let exitTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        
        leftGesture.direction = .left
        
        exitButton.addGestureRecognizer(exitTapRecognizer)
        self.view.addGestureRecognizer(leftGesture)
    }
    
    ///Will sett the constraints for all the views in the view.
    
    ///# Notes: #
    ///1. The setUPUI must be called first and add all of the views.
    
    ///# Example #
    ///```
    ///func setUpUI(){
    /////Add the views
    ///setConstraints()
    ///}
    ///```
    fileprivate func setConstraints(){
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: exitButton.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    fileprivate func updateSettings() {
        // checking if the reminders are turn on or off
        if settings[3].isOpened {
            settings[3].options.append(NSLocalizedString("StartingTime", comment: "settings option"))
            settings[3].options.append(NSLocalizedString("EndingTime", comment: "settings option"))
            settings[3].options.append(NSLocalizedString("Frequency", comment: "settings option"))
        }
        // checks if the phone supports alternative icons
        if UIApplication.shared.supportsAlternateIcons {
            settings[0].options.insert(NSLocalizedString("AppIcon", comment: "setting option"), at: 1)
        }
    }
    
    // MARK: - Set appearance
    
    /**
     Set the appearance of the app deppending on if the users prefrence for dark mode or light mode.
     
     # Notes: #
     1. This will change all the colors off this screen.
     
     # Example #
     ```
     setAppearance()
     ```
     */
    func setAppearance(){
        self.view.backgroundColor = UIColor.reHydrateTableViewBackground
        tableView.backgroundColor = UIColor.reHydrateTableViewBackground
        exitButton.tintColor  = darkMode ? .lightGray : .black
    }
    
    // MARK: - Temp message
    
    /**
     Will create a toast message and display it on the bottom of the screen.
     
     - parameter message: - **String** that will be displayed on the screen.
     - parameter messageDelay: - a **Double** of how long the message will be displayed.
     
     # Example #
     ```
     sendToastMessage("Reminders set for every 30 minutes from 7 am to 11 pm", 3.5)
     ```
     */
    fileprivate func sendToastMessage(_ message: String, _ messageDelay: Double) {
        DispatchQueue.main.async {
            let toastLabel = UIButton()
            toastLabel.setTitle(message, for: .normal)
            toastLabel.titleLabel?.font          = UIFont(name: "AmericanTypewriter", size: 18.0)
            toastLabel.titleLabel?.textAlignment = .center
            toastLabel.titleLabel?.numberOfLines = 0
            toastLabel.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            if self.darkMode {
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
            self.view.addSubview(toastLabel)
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                      = true
            toastLabel.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive       = true
            toastLabel.leftAnchor.constraint(greaterThanOrEqualTo: self.view.leftAnchor, constant: 50).isActive = true
            toastLabel.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -50).isActive = true
            toastLabel.sizeToFit()
            UIView.animate(withDuration: 0.5, delay: messageDelay, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(_) in
                toastLabel.removeFromSuperview()
            })
        }
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource{
    
    
    // MARK: - Creates a cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 7 {
            return 0
        } else {
            return settings[section].options.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell             = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingOptionCell
        cell.setting         = settings[indexPath.section].options[indexPath.row]
        cell.selectionStyle  = .none
        cell.setCellApparance(darkMode, metricUnits)
        
        switch indexPath {
        case IndexPath(row: 0, section: 0): // Dark Mode cell
            cell.textField.removeFromSuperview()
            cell.subTitle.removeFromSuperview()
            cell.setTitleConstraints()
        case IndexPath(row: 0, section: 1): // Unit selection(Metric)
            cell.textField.removeFromSuperview()
            cell.addSubTitle( "\(NSLocalizedString("Units", comment: "")): \(UnitVolume.liters.symbol), \(UnitVolume.milliliters.symbol)")
        case IndexPath(row: 1, section: 1): // Unit selection(Imperial)
            cell.textField.removeFromSuperview()
            cell.addSubTitle( "\(NSLocalizedString("Units", comment: "")): \(UnitVolume.imperialPints.symbol), \(UnitVolume.imperialFluidOunces.symbol)")
        case IndexPath(row: 0, section: 3): // Reminders cell
            if settings[3].isOpened {
                if #available(iOS 13.0, *) {
                    cell.buttonForCell.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                } else {
                    if darkMode {
                        cell.buttonForCell.setBackgroundImage(UIImage(named: "checkmark.circle.fill")?.colored(.gray), for: .normal)
                    } else {
                        cell.buttonForCell.setBackgroundImage(UIImage(named: "checkmark.circle.fill")?.colored(.black), for: .normal)
                    }
                }
                cell.titleOption.text = NSLocalizedString("TurnOffReminders", comment: "Toggle Reminders")
            } else {
                if #available(iOS 13.0, *) {
                    cell.buttonForCell.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
                } else {
                    if darkMode {
                        cell.buttonForCell.setBackgroundImage(UIImage(named: "selection.circle")?.colored(.gray), for: .normal)
                    } else {
                        cell.buttonForCell.setBackgroundImage(UIImage(named: "selection.circle")?.colored(.black), for: .normal)
                    }
                }
                cell.titleOption.text = NSLocalizedString("TurnOnReminders", comment: "Toggle Reminders")
            }
            cell.textField.removeFromSuperview()
            cell.subTitle.removeFromSuperview()
            cell.setTitleConstraints()
        case IndexPath(row: 2, section: 0),
             IndexPath(row: 0, section: 2),
             IndexPath(row: 1, section: 3),
             IndexPath(row: 2, section: 3),
             IndexPath(row: 3, section: 3): // Cell with textField
            cell.subTitle.removeFromSuperview()
            cell.setTextFieldConstraints()
        case IndexPath(row: 2, section: 5): // Danger cell
            cell.buttonForCell.isHidden = false
            if #available(iOS 13.0, *) {
                cell.buttonForCell.setBackgroundImage(UIImage(systemName: "chevron.compact.right")!.applyingSymbolConfiguration(.init(weight: .light)), for: .normal)
                cell.buttonForCell.tintColor = .systemRed
            } else {
                cell.buttonForCell.setBackgroundImage(UIImage(named: "chevron.compact.right")?.colored(.systemRed), for: .normal)
            }
            cell.titleOption.textColor = .systemRed
            cell.subTitle.removeFromSuperview()
            cell.textField.removeFromSuperview()
            cell.setTitleConstraints()
        case IndexPath(row: 6, section: 6): // Version cell
            cell.titleOption.text!.append(" \(String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!))")
            cell.textField.removeFromSuperview()
            cell.subTitle.removeFromSuperview()
            cell.setTitleConstraints()
        default: // Cells with normal button
            cell.buttonForCell.isHidden = false
            if #available(iOS 13.0, *) {
                cell.buttonForCell.setBackgroundImage(UIImage(systemName: "chevron.compact.right")!.applyingSymbolConfiguration(.init(weight: .light)), for: .normal)
            } else {
                if darkMode {
                    cell.buttonForCell.setBackgroundImage(UIImage(named: "chevron.compact.right")?.colored(.gray),
                                                          for: .normal)
                } else {
                    cell.buttonForCell.setBackgroundImage(UIImage(named: "chevron.compact.right")?.colored(.black),
                                                          for: .normal)
                }
            }
            cell.subTitle.removeFromSuperview()
            cell.textField.removeFromSuperview()
            cell.setTitleConstraints()
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count + 1
    }
    
    // MARK: - Cell controlls of TableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 0, section: 0): // dark mode selected
            darkMode = !darkMode
            setAppearance()
            tableView.reloadData()
        case IndexPath(row: 1, section: 0): // Change app icon
            let appIconVC = AppIconVC()
            appIconVC.modalPresentationStyle = .fullScreen
            self.present(appIconVC, animated: true, completion: nil)
        case IndexPath(row: 0, section: 1): // Metric is selected
            metricUnits = true
            tableView.reloadData()
        case IndexPath(row: 1, section: 1): // imperial is selected
            metricUnits = false
            tableView.reloadData()
        case IndexPath(row: 0, section: 3): // turn on/off notifications
            let cell = tableView.cellForRow(at: indexPath) as! SettingOptionCell
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            center.getNotificationSettings { (notificationSetting) in
                switch notificationSetting.authorizationStatus {
                case .denied:
                    self.sendToastMessage(NSLocalizedString("RemindersNotAllowed", comment: "Notificaionts not allowed"), 3)
                case .notDetermined:
                    center.requestAuthorization(options: [.alert, .sound]) { (success, _) in
                        if success {
                            print("we are allowed to send notifications.")
                            self.defaults.set(true, forKey: remindersString)
                        } else {
                            print("we are not allowed to send notifications.")
                            self.defaults.set(false, forKey: remindersString)
                        }
                    }
                default:
                    self.settings[3].isOpened = !self.settings[3].isOpened
                    if self.settings[3].isOpened {
                        let startDate = self.defaults.object(forKey: startingTimeString) as! Date
                        let endDate = self.defaults.object(forKey: endingTimeString) as! Date
                        let intervals = self.defaults.integer(forKey: reminderIntervalString)
                        setReminders(startDate, endDate, intervals)
                        self.sendToastMessage("\(NSLocalizedString("RemindersSetFrom", comment: "starting of toas message")) \(self.timeFormatter.string(from: startDate)) \(NSLocalizedString("To", comment: "splitter for toast")) \(self.timeFormatter.string(from: endDate))", 4)
                        DispatchQueue.main.async {
                            self.settings[3].options.append(NSLocalizedString("StartingTime", comment: "settings option"))
                            self.settings[3].options.append(NSLocalizedString("EndingTime", comment: "settings option"))
                            self.settings[3].options.append(NSLocalizedString("Frequency", comment: "settings option"))
                            tableView.insertRows(at: [IndexPath(row: 1, section: 3), IndexPath(row: 2, section: 3), IndexPath(row: 3, section: 3)], with: .middle)
                            if #available(iOS 13.0, *) {
                                cell.buttonForCell.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                            } else {
                                if self.darkMode {
                                    cell.buttonForCell.setBackgroundImage(UIImage(named: "checkmark.circle.fill")?.colored(.gray), for: .normal)
                                } else {
                                    cell.buttonForCell.setBackgroundImage(UIImage(named: "checkmark.circle.fill")?.colored(.black), for: .normal)
                                }
                            }
                            cell.titleOption.text = NSLocalizedString("TurnOffReminders", comment: "Toggle Reminders")
                            tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .automatic)
                        }
                    } else {
                        self.sendToastMessage(NSLocalizedString("RemoveRemindersToast", comment: "Toast message for removing reminders"), 1)
                        DispatchQueue.main.async {
                            self.settings[3].options.removeLast(3)
                            tableView.deleteRows(at: [IndexPath(row: 1, section: 3), IndexPath(row: 2, section: 3), IndexPath(row: 3, section: 3)], with: .bottom)
                            tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .automatic)
                            if #available(iOS 13.0, *) {
                                cell.buttonForCell.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
                            } else {
                                if self.darkMode {
                                    cell.buttonForCell.setBackgroundImage(UIImage(named: "selection.circle")?.colored(.gray), for: .normal)
                                } else {
                                    cell.buttonForCell.setBackgroundImage(UIImage(named: "selection.circle")?.colored(.black), for: .normal)
                                }
                            }
                            self.defaults.set(false, forKey: remindersString)
                            cell.titleOption.text = NSLocalizedString("TurnOnReminders", comment: "Toggle Reminders")
                        }
                    }
                }
            }
        case IndexPath(row: 0, section: 4): // Credits
            let creditsVC = CreditsVC()
            creditsVC.modalPresentationStyle = .popover
            self.present(creditsVC, animated: true, completion: nil)
        case IndexPath(row: 0, section: 5): // Open settings
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        case IndexPath(row: 1, section: 5): // Open health
            UIApplication.shared.open(URL(string: "x-apple-health://")!)
        case IndexPath(row: 2, section: 5): // Remove data
            let clearDataAlert = UIAlertController(title: NSLocalizedString("ClearingDataAlert",
                                                                            comment: "Title for clearing data alert"),
                                                   message: NSLocalizedString("ClearingDataBody",
                                                                              comment: "body for clearing data alert"),
                                                   preferredStyle: .alert)
            clearDataAlert.addAction(UIAlertAction(title: NSLocalizedString("ClearDataKeepData",
                                                                            comment: "Keep data option"),
                                                   style: .cancel, handler: nil))
            clearDataAlert.addAction(UIAlertAction(title: NSLocalizedString("ClearDataRemoveData", comment: "Remove old data option"), style: .destructive, handler: {_ in
                let domain = Bundle.main.bundleIdentifier!
                self.defaults.removePersistentDomain(forName: domain)
                self.defaults.synchronize()
                let startDate = Calendar.current.date(bySettingHour: 8, minute: 00, second: 0, of: Date())!
                let endDate   = Calendar.current.date(bySettingHour: 23, minute: 00, second: 0, of: Date())!
                let intervals = 30
                self.defaults.set(startDate, forKey: startingTimeString)
                self.defaults.set(endDate,   forKey: endingTimeString)
                self.defaults.set(intervals, forKey: reminderIntervalString)
                self.defaults.set(self.darkMode,  forKey: darkModeString)
                self.defaults.set(self.metricUnits, forKey: metricUnitsString)
                let transition      = CATransition()
                transition.duration = 0.4
                transition.type     = .push
                transition.subtype  = .fromRight
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                self.days = fetchAllDays()
                self.days.forEach({self.context.delete($0)})
                saveDays()
                self.view.window!.layer.add(transition, forKey: kCATransition)
                self.dismiss(animated: false, completion: nil)
            }))
            self.present(clearDataAlert, animated: true, completion: nil)
        case IndexPath(row: 0, section: 6): // Toturial
            let tutorialVC = TutorialVC()
            tutorialVC.modalPresentationStyle = .popover
            self.present(tutorialVC, animated: true, completion: nil)
        case IndexPath(row: 1, section: 6): // Open Instagram
            if let url = URL(string: "https://www.instagram.com/braka.coding/"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        case IndexPath(row: 2, section: 6): // Send mail about feature
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["PetterBraka@gmail.com"])
                mail.setSubject("Feature Request -reHydrate")
                mail.setMessageBody("""
Hi,<br>
**Is your feature request related to a problem?**<br>
Please describe:
<br>
**Describe the solution you'd like**<br>
Please describe your feature:
<br>
**Additional context**<br>
"""
                                    , isHTML: true)
                present(mail, animated: true)
            } else {
                sendToastMessage(NSLocalizedString("CouldtSendMail", comment: "could't send email"), 4)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    if let url = URL(string: "https://github.com/PetterBraka/reHydrate/issues"),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }
        case IndexPath(row: 3, section: 6): // Send mail about bug
            if MFMailComposeViewController.canSendMail() {
                UIDevice.current.isBatteryMonitoringEnabled = true
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["PetterBraka@gmail.com"])
                mail.setSubject("Bug Request -reHydrate")
                mail.setMessageBody("""
**Describe the bug**<br>
Please describe the bug:<br>
<br>
**To Reproduce**<br>
Steps to reproduce the behaviour:<br>
1. Go to '...'<br>
2. Click on '....'<br>
3. Scroll down to '....'<br>
4. See error<br>
<br>
Please add any screenshots you have of the porblem:<br>
<br>
**Device info (please check if the following information):**<br>
 - Battery: \(UIDevice.current.batteryLevel * 100)%<br>
 - OS: \(UIDevice.current.systemVersion.description)<br>
 - App version: \(String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!))<br>
"""
                                    , isHTML: true)
                present(mail, animated: true)
            } else {
                sendToastMessage(NSLocalizedString("CouldtSendMail", comment: "could't send email"), 4)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    if let url = URL(string: "https://github.com/PetterBraka/reHydrate/issues"),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }
        case IndexPath(row: 4, section: 6): // Send mail to contact dev
            if MFMailComposeViewController.canSendMail() {
                UIDevice.current.isBatteryMonitoringEnabled = true
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["PetterBraka@gmail.com"])
                mail.setSubject("-reHydrate")
                mail.setMessageBody("""
Hi,<br>
Thank you for getting in contact with us<br>
"""
                                    , isHTML: true)
                present(mail, animated: true)
            } else {
                sendToastMessage(NSLocalizedString("CouldtSendMail", comment: "could't send email"), 4)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    if let url = URL(string: "https://twitter.com/PetterBraka"),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }
        case IndexPath(row: 5, section: 6): // open privacy policy
            if let url = URL(string: "https://github.com/PetterBraka/reHydrate/wiki/Privacy-Policy"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        default:
            break
        }
    }
}

extension SettingsVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
        if result == .sent {
            dismiss(animated: true)
        }
    }
}
