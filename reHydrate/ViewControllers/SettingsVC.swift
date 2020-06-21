//
//  AboutVC.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import HealthKit

struct settingOptions {
    var isOpened: Bool
    var setting:  String
    var options:  [String]
}

class SettingsVC: UIViewController {
    
    // MARK: - Variabels
    let defaults                   = UserDefaults.standard
    var tableView: UITableView     = UITableView()
    var exitButton: UIButton       = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var darkMode                   = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkMode ? .lightContent : .darkContent
    }
    var metricUnits                = true
    var selectedRow: IndexPath     = IndexPath()
    var settings: [settingOptions] = [
        settingOptions(isOpened: false, setting: NSLocalizedString("Appearance", comment: "Header title"),
                       options: [NSLocalizedString("DarkMode", comment: "settings option"),
                                 NSLocalizedString("AppIcon", comment: "setting option")]),
        settingOptions(isOpened: false, setting: NSLocalizedString("UnitSystem", comment: "Header title"),
                       options: [NSLocalizedString("MetricSystem", comment: "settings option"),
                                 NSLocalizedString("ImperialSystem", comment: "settings option")]),
        settingOptions(isOpened: false, setting: NSLocalizedString("ChangeGoal", comment: "Header title"),
                       options: [NSLocalizedString("SetYourGoal", comment: "settings option")]),
        settingOptions(isOpened: false, setting: NSLocalizedString("Reminders", comment: "Header title"),
                       options: [NSLocalizedString("TurnOnReminders", comment: "settings option")]),
        settingOptions(isOpened: false, setting: NSLocalizedString("Introductions", comment: "Header title"),
                       options: [NSLocalizedString("Language", comment: "setting option"),
                                 NSLocalizedString("HowToUse", comment: "settings option")]),
        settingOptions(isOpened: false, setting: NSLocalizedString("DangerZone", comment: "Header title"),
                       options: [NSLocalizedString("OpenAppSettings", comment: "settings option"),
                                 NSLocalizedString("OpenHealthApp", comment: "settings option"),
                                 NSLocalizedString("RemoveData", comment: "settings option")])]
    
    //MARK: - Tap controller
    
    /**
     Will check which **view** that called this function.
     
     - parameter sender: - **view** that called the function.
     
     */
    @objc func tap(_ sender: UIGestureRecognizer){
        switch sender.view {
            case exitButton:
                defaults.set(darkMode, forKey: darkModeString)
                defaults.set(metricUnits, forKey: metricUnitsString)
                let transition      = CATransition()
                transition.duration = 0.4
                transition.type     = .push
                transition.subtype  = .fromRight
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                view.window!.layer.add(transition, forKey: kCATransition)
                self.dismiss(animated: false, completion: nil)
            default:
                break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (success, error) in
            if success {
                print("we are allowed to send notifications.")
            } else {
                print("we are not allowed to send notifications.")
            }
        }
        self.modalPresentationStyle = .fullScreen
        
        settings[3].isOpened = defaults.bool(forKey: remindersString)
        metricUnits          = defaults.bool(forKey: metricUnitsString)
        darkMode             = defaults.bool(forKey: darkModeString)
        
        setUpUI()
        changeAppearance()
    }
    
    //MARK: - Set up of UI
    
    /**
     Will set up the UI and must be called at the launche of the view.
     
     # Example #
     ```
     setUpUI()
     ```
     */
    func setUpUI(){
        self.view.addSubview(exitButton)
        self.view.addSubview(tableView)
        
        let exitTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        exitButton.addGestureRecognizer(exitTapRecognizer)
        
        setConstraints()
        
        if settings[3].isOpened {
            settings[3].options.append(NSLocalizedString("StartingTime", comment: "settings option"))
            settings[3].options.append(NSLocalizedString("EndingTime", comment: "settings option"))
            settings[3].options.append(NSLocalizedString("Frequency", comment: "settings option"))
        }
        
        tableView.register(SettingsHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.register(SettingOptionCell.self, forCellReuseIdentifier: "settingCell")
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    /**
     Will sett the constraints for all the views in the view.
     
     # Notes: #
     1. The setUPUI must be called first and add all of the views.
     
     # Example #
     ```
     func setUpUI(){
     //Add the views
     setConstraints()
     }
     ```
     */
    func setConstraints(){
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - Change appearance
    
    /**
     Changing the appearance of the app deppending on if the users prefrence for dark mode or light mode.
     
     # Notes: #
     1. This will change all the colors off this screen.
     
     # Example #
     ```
     changeAppearance()
     ```
     */
    func changeAppearance(){
        if !darkMode {
            self.view.backgroundColor = .white
            tableView.backgroundColor = .white
            exitButton.tintColor      = .black
        } else{
            self.view.backgroundColor = UIColor().hexStringToUIColor("#212121")
            tableView.backgroundColor = UIColor().hexStringToUIColor("#212121")
            exitButton.tintColor      = .lightGray
        }
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
    func sendToastMessage(_ message: String, _ messageDelay: Double) {
        let toastLabel = UIButton()
        toastLabel.setTitle(message, for: .normal)
        toastLabel.titleLabel?.font          = UIFont(name: "AmericanTypewriter", size: 18.0)
        toastLabel.titleLabel?.textAlignment = .center
        toastLabel.titleLabel?.numberOfLines = 0
        if settings[3].isOpened {
            toastLabel.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        } else {
            toastLabel.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        if darkMode {
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
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    //MARK: - Section controll of tableView
    
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource{
    
    
    //MARK: - Creates a cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell             = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingOptionCell
        cell.setting         = settings[indexPath.section].options[indexPath.row]
        cell.selectionStyle  = .none
        cell.setCellAppairents(darkMode, metricUnits)
        let startDate = UserDefaults.standard.object(forKey: startingTimeString) as! Date
        let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
        let endDate = UserDefaults.standard.object(forKey: endingTimeString) as! Date
        let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
        var intervals = UserDefaults.standard.integer(forKey: reminderIntervalString)
        if intervals == 0 {
            intervals = 30
        }
        switch indexPath {
            case IndexPath(row: 1, section: 0), IndexPath(row: 1, section: 4), IndexPath(row: 0, section: 5),
                 IndexPath(row: 1, section: 5):
                cell.imageForCell.isHidden = false
                cell.imageForCell.setBackgroundImage(UIImage(systemName: "chevron.compact.right"), for: .normal)
                cell.subTitle.removeFromSuperview()
                cell.textField.removeFromSuperview()
                cell.setTitleConstraints()
                cell.setButtonConstraints()
            case IndexPath(row: 0, section: 1):
                cell.addSubTitle( "\(NSLocalizedString("Units", comment: "")): \(UnitVolume.liters.symbol), \(UnitVolume.milliliters.symbol)")
                cell.textField.removeFromSuperview()
                let current = UNUserNotificationCenter.current()
                current.getPendingNotificationRequests { (pendingNotifcations) in
                    if !pendingNotifcations.isEmpty{
                        current.removeAllDeliveredNotifications()
                        current.removeAllPendingNotificationRequests()
                        setReminders(startTimer.hour ?? 8, endTimer.hour ?? 23, intervals)
                    }
                }
            case IndexPath(row: 1, section: 1):
                cell.addSubTitle( "\(NSLocalizedString("Units", comment: "")): \(UnitVolume.imperialPints.symbol), \(UnitVolume.imperialFluidOunces.symbol)")
                cell.textField.removeFromSuperview()
                let current = UNUserNotificationCenter.current()
                current.getPendingNotificationRequests { (pendingNotifcations) in
                    if !pendingNotifcations.isEmpty{
                        current.removeAllDeliveredNotifications()
                        current.removeAllPendingNotificationRequests()
                        setReminders(startTimer.hour ?? 8, endTimer.hour ?? 23, intervals)
                    }
            }
            case IndexPath(row: 0, section: 3):
                if settings[3].isOpened {
                    cell.imageForCell.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    cell.titleOption.text = NSLocalizedString("TurnOffReminders", comment: "Toggle Reminders")
                } else {
                    cell.imageForCell.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
                    cell.titleOption.text = NSLocalizedString("TurnOnReminders", comment: "Toggle Reminders")
                }
                cell.textField.removeFromSuperview()
            case IndexPath(row: 0, section: 2), IndexPath(row: 1, section: 3),
                 IndexPath(row: 2, section: 3), IndexPath(row: 3, section: 3),
                 IndexPath(row: 0, section: 4):
                cell.subTitle.removeFromSuperview()
                break
            case IndexPath(row: 2, section: 5):
                cell.imageForCell.isHidden = false
                cell.imageForCell.setBackgroundImage(UIImage(systemName: "chevron.compact.right"), for: .normal)
                cell.imageForCell.tintColor = .systemRed
                cell.titleOption.textColor = .systemRed
                cell.subTitle.removeFromSuperview()
                cell.textField.removeFromSuperview()
                cell.setTitleConstraints()
                cell.setButtonConstraints()
            default:
                cell.textField.removeFromSuperview()
                cell.subTitle.removeFromSuperview()
                cell.setTitleConstraints()
                cell.setButtonConstraints()
                break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    //MARK: - Creates a section
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell     = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SettingsHeader
        cell.setting = settings[section]
        cell.tag = section
        cell.setHeaderAppairents(darkMode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //MARK: - Cell controlls of TableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
            case IndexPath(row: 0, section: 0): // dark mode selected
                darkMode = !darkMode
                changeAppearance()
                tableView.reloadData()
            case IndexPath(row: 1, section: 0): // Change app icon
                let appIconVC = AppIconVC()
                appIconVC.modalPresentationStyle = .fullScreen
                self.present(appIconVC, animated: true, completion: nil)
                break
            case IndexPath(row: 0, section: 1): // Metric is selected
                metricUnits = true
                tableView.reloadData()
            case IndexPath(row: 1, section: 1): // imperial is selected
                metricUnits = false
                tableView.reloadData()
            case IndexPath(row: 0, section: 3): // turn on/off notifications
                let cell = tableView.cellForRow(at: indexPath) as! SettingOptionCell
                settings[3].isOpened = !settings[3].isOpened
                if settings[3].isOpened {
                    settings[3].options.append(NSLocalizedString("StartingTime", comment: "settings option"))
                    settings[3].options.append(NSLocalizedString("EndingTime", comment: "settings option"))
                    settings[3].options.append(NSLocalizedString("Frequency", comment: "settings option"))
                    cell.imageForCell.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    cell.titleOption.text = NSLocalizedString("TurnOffReminders", comment: "Toggle Reminders")
                    let startDate = defaults.object(forKey: startingTimeString) as! Date
                    let startTimer = Calendar.current.dateComponents([.hour, .minute], from: startDate)
                    let endDate = defaults.object(forKey: endingTimeString) as! Date
                    let endTimer = Calendar.current.dateComponents([.hour, .minute], from: endDate)
                    let intervals = defaults.integer(forKey: reminderIntervalString)
                    setReminders(startTimer.hour!, endTimer.hour!, intervals)
                    sendToastMessage("\(NSLocalizedString("RemindersSetFrom", comment: "starting of toas message")) \(startTimer.hour!) \(NSLocalizedString("To", comment: "splitter for toast")) \(endTimer.hour!)", 4)
                } else {
                    settings[3].options.removeLast(3)
                    cell.imageForCell.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
                    cell.titleOption.text = NSLocalizedString("TurnOnReminders", comment: "Toggle Reminders")
                    let center = UNUserNotificationCenter.current()
                    center.removeAllPendingNotificationRequests()
                    center.removeAllDeliveredNotifications()
                    defaults.set(false, forKey: remindersString)
                    sendToastMessage(NSLocalizedString("RemoveRemindersToast", comment: "Toast message for removing reminders"), 1)
                }
                tableView.reloadData()
            case IndexPath(row: 0, section: 4):
                break
            case IndexPath(row: 1, section: 4):
                print("help pressed")
                let tutorialVC = TutorialVC()
                tutorialVC.modalPresentationStyle = .fullScreen
                self.present(tutorialVC, animated: true, completion: nil)
            case IndexPath(row: 0, section: 5):
                if let url = URL(string:UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
            }
            case IndexPath(row: 1, section: 5):
                UIApplication.shared.open(URL(string: "x-apple-health://")!)
            case IndexPath(row: 2, section: 5):
                let clearDataAlert = UIAlertController(title: NSLocalizedString("ClearingDataAlert",
                                                                                comment: "Title for clearing data alert"),
                                                       message: NSLocalizedString("ClearingDataBody",
                                                                                  comment: "body for clearing data alert"),
                                                       preferredStyle: .alert)
                clearDataAlert.addAction(UIAlertAction(title: NSLocalizedString("ClearDataKeepData",
                                                                                comment: "Keep data option"),
                                                       style: .cancel, handler: nil))
                clearDataAlert.addAction(UIAlertAction(title: NSLocalizedString("ClearDataRemoveData",
                                                                                comment: "Remove old data option"),
                                                       style: .destructive, handler: {_ in
                    let domain = Bundle.main.bundleIdentifier!
                    self.defaults.removePersistentDomain(forName: domain)
                    self.defaults.synchronize()}))
                self.present(clearDataAlert, animated: true, completion: nil)
            default:
                break
        }
    }
}
