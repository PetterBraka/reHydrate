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

class AboutVC: UIViewController {
    
    // MARK: - Variabels
    
    @IBOutlet weak var tableView:  UITableView!
    @IBOutlet weak var exitButton: UIButton!
    var darkMode                   = true
    var metricUnits                = true
    let helpImage                  = UIImageView.init(image: UIImage.init(named: "toturial-1"))
    var selectedRow: IndexPath     = IndexPath()
    var settings: [settingOptions] = [
        settingOptions(isOpened: false, setting: "appearance", options: ["Light Mode", "Dark Mode"]),
        settingOptions(isOpened: false, setting: "chang unit system", options: ["Metric System", "Imperial System"]),
        settingOptions(isOpened: false, setting: "change goal", options: ["Goal"]),
        settingOptions(isOpened: false, setting: "reminders", options: ["Turn on reminders",
                                                                        "Starting time",
                                                                        "Ending time",
                                                                        "Frequency"]),
        settingOptions(isOpened: false, setting: "how to use", options: []),
        settingOptions(isOpened: false, setting: "remove data", options: [])]
    
    //MARK: - Tap controller
    
    /**
     Will check which **view** that called this function.
     
     - parameter sender: - **view** that called the function.
     
     */
    @objc func tap(_ sender: UIGestureRecognizer){
        switch sender.view {
            case exitButton:
                UserDefaults.standard.set(darkMode, forKey: "darkMode")
                UserDefaults.standard.set(metricUnits, forKey: "metricUnits")
                self.dismiss(animated: true, completion: nil)
            case helpImage:
                helpImage.removeFromSuperview()
                tableView.isHidden = false
            default:
                break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let exitTapRecognizer 	= UITapGestureRecognizer(target: self, action: #selector(tap))
        let helpTapRecognizer 	= UITapGestureRecognizer(target: self, action: #selector(tap))
        exitButton.addGestureRecognizer(exitTapRecognizer)
        helpImage.addGestureRecognizer(helpTapRecognizer)
        tableView.register(SettingsHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.register(SettingOptionCell.self, forCellReuseIdentifier: "settingCell")
        tableView.delegate 		= self
        tableView.dataSource 	= self
        settings[3].isOpened    = UserDefaults.standard.bool(forKey: "reminder")
        metricUnits				= UserDefaults.standard.bool(forKey: "metricUnits")
        darkMode 				= UserDefaults.standard.bool(forKey: "darkMode")
        changeAppearance()
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
            self.view.backgroundColor = hexStringToUIColor(hex: "#212121")
            tableView.backgroundColor = hexStringToUIColor(hex: "#212121")
            exitButton.tintColor      = .lightGray
        }
    }
    
    /**
     Changing the appearance of the **UITableView** deppending on if the users prefrence for dark mode or light mode.
     
     # Example #
     ```
     changeAppearance()
     ```
     */
    func changeTableViewAppearants(){
        var section 	= 0
        while section 	< tableView.numberOfSections && tableView.numberOfSections != 0{
            let headerCell = tableView.headerView(forSection: section) as! SettingsHeader
            headerCell.setHeaderAppairents(self.darkMode)
            var row 	= 0
            while row 	< tableView.numberOfRows(inSection: section) {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? SettingOptionCell ?? nil
                if cell != nil {
                    cell?.setCellAppairents(darkMode, metricUnits)
                }
                row += 1
            }
            section += 1
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
    
    // MARK: - Notifications
    
    /**
     Will set a notification for every half hour between 7 am and 11pm.
     
     # Example #
     ```
     setReminders()
     ```
     */
    func setReminders(){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
        
        let startTimer = UserDefaults.standard.double(forKey: "startignTime")
        let endTimer = UserDefaults.standard.double(forKey: "endingTime")
        let startHour = Int(startTimer.rounded(.down))
        let endHour   = Int(endTimer.rounded(.down))
        let intervals = 30
        
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
    
    /**
     Will handle the gestures form the **UITableView**.
     
     - parameter sender: - The **UIGestureRecognizer** that called the function.
     
     # Notes: #
     1. case for "how to use" will create a image and hide the **UITableView**. If the user clicks the image it will dismiss and show the **UITableView**
     2. case for "remove data" will ask the user if the user want to remove all saved data.
     3. Default case for the tapping any other header cell. This case will then expand the header and show the cells in that section.
     */
    @objc func expandOrCollapsSection(_ sender: UIGestureRecognizer){
        guard let section = sender.view?.tag else { return }
        switch section {
            case settings.firstIndex(where: {$0.setting == "how to use"}):
                print("help pressed")
                let tutorialVC = TutorialVC()
                tutorialVC.modalPresentationStyle = .fullScreen
                self.present(tutorialVC, animated: true, completion: nil)
            case settings.firstIndex(where: {$0.setting == "remove data"}):
                // This will clear all the saved data from past days.
                let clearDataAlert = UIAlertController(title: "Clearing data.", message: "Are you sure you want to delete all save data?", preferredStyle: .alert)
                clearDataAlert.addAction(UIAlertAction(title: "Keep data", style: .cancel, handler: nil))
                clearDataAlert.addAction(UIAlertAction(title: "REMOVE OLD DATA", style: .destructive, handler: {_ in
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()}))
                self.present(clearDataAlert, animated: true, completion: nil)
            default:
                var indexPaths                 = [IndexPath]()
                for row in settings[section].options.indices {
                    let indexPath             = IndexPath(row: row, section: section)
                    indexPaths.append(indexPath)
                }
                let header = tableView.headerView(forSection: section) as! SettingsHeader
                let isOpened                 = settings[section].isOpened
                settings[section].isOpened     = !isOpened
                if isOpened {
                    header.button.setBackgroundImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
                    tableView.deleteRows(at: indexPaths, with: .fade)
                } else {
                    tableView.insertRows(at: indexPaths, with: .fade)
                    header.button.setBackgroundImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
            }
        }
    }
}

extension AboutVC: UITableViewDelegate, UITableViewDataSource{
    
    
    //MARK: - Creates a cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].isOpened ? settings[section].options.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell 				= tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingOptionCell
        cell.setting 			= settings[indexPath.section].options[indexPath.row]
        cell.selectionStyle 	= .none
        cell.setCellAppairents(darkMode, metricUnits)
        switch indexPath {
            case IndexPath(row: 0, section: 1):
                cell.addSubTitle( "Units: \(UnitVolume.liters.symbol), \(UnitVolume.milliliters.symbol)")
            case IndexPath(row: 1, section: 1):
                cell.addSubTitle( "Units: \(UnitVolume.imperialPints.symbol), \(UnitVolume.imperialFluidOunces.symbol)")
            case IndexPath(row: 0, section: 3):
                if settings[3].isOpened {
                    cell.activatedOption.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    cell.titleOption.text = "Turn off reminders"
                } else {
                    cell.activatedOption.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
                    cell.titleOption.text = "Turn on reminders"
            }
            default:
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
        let cell 			= tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SettingsHeader
        cell.setting 		= settings[section]
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOrCollapsSection)))
        cell.tag 			= section
        switch cell.title.text?.uppercased() {
            case String("remove data").uppercased():
                cell.title.textColor = .systemRed
            default:
            break
        }
        if settings[section].options.isEmpty{
            if cell.title.text != "REMINDERS"{
                cell.button.removeFromSuperview()
            }
        }
        cell.setHeaderAppairents(darkMode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView 					= UIView()
        let separatorView 				= UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        separatorView.backgroundColor 	= UIColor.lightGray
        footerView.addSubview(separatorView)
        return footerView
    }
    
    //MARK: - Cell controlls of TableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
            case IndexPath(row: 0, section: 0): // light mode selected
                darkMode = false
                changeAppearance()
                changeTableViewAppearants()
            case IndexPath(row: 1, section: 0): // dark mode selected
                darkMode = true
                changeAppearance()
                changeTableViewAppearants()
            case IndexPath(row: 0, section: 1): // Metric is selected
                metricUnits = true
                changeTableViewAppearants()
            case IndexPath(row: 1, section: 1): // imperial is selected
                metricUnits = false
                changeTableViewAppearants()
            case IndexPath(row: 0, section: 3): // setts notifications between 7 and 23
                let cell = tableView.cellForRow(at: indexPath) as! SettingOptionCell
                settings[3].isOpened = !settings[3].isOpened
                if settings[3].isOpened {
                    cell.activatedOption.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    cell.titleOption.text = "Turn off reminders"
                    setReminders()
                    sendToastMessage("Reminders set for every 30 minutes from 7 am to 11 pm", 3.5)
                } else {
                    cell.activatedOption.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
                    cell.titleOption.text = "Turn on reminders"
                    let center = UNUserNotificationCenter.current()
                    center.removeAllPendingNotificationRequests()
                    center.removeAllDeliveredNotifications()
                    sendToastMessage("all reminders are removed", 1)
                }
                UserDefaults.standard.set(settings[3].isOpened, forKey: "reminder")
            default:
            break
        }
    }
}

extension UIImage {
    
    /**
     Will create a greayed out version of the image.
     
     - returns: The image grayed out.
     
     # Example #
     ```
     imageView.image  = imageView.image?.grayed
     ```
     */
    var grayed: UIImage {
        guard let ciImage = CIImage(image: self)
            else { return self }
        let filterParameters = [ kCIInputColorKey: CIColor.white, kCIInputIntensityKey: 1.0 ] as [String: Any]
        let grayscale = ciImage.applyingFilter("CIColorMonochrome", parameters: filterParameters)
        return UIImage(ciImage: grayscale)
    }
}
