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
    var isOpened: 	Bool
    var setting: 	String
    var options: 	[String]
}

class AboutVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exitButton: UIButton!
    let toturialVC					= UIViewController()
    var darkMode					= true
    var metricUnits					= true
    var stage						= 0
    let helpImage 					= UIImageView.init(image: UIImage.init(named: "toturial-1"))
    var selectedRow: IndexPath 		= IndexPath()
    var settings: [settingOptions] 	= [
        settingOptions(isOpened: false, setting: "appearance", options: ["Light Mode", "Dark Mode"]),
        settingOptions(isOpened: false, setting: "unit system", options: ["Metric System", "Imperial System"]),
        settingOptions(isOpened: false, setting: "change goal", options: ["Goal"]),
        settingOptions(isOpened: false, setting: "how to use", options: []),
        settingOptions(isOpened: false, setting: "remove data", options: [])]
    
    let toolBar: UIView                    = {
        let view                         = UIView()
        view.backgroundColor            = .opaqueSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let skipButton: UIButton            = {
        let button                        = UIButton()
        button.setTitle("skip", for: .normal)
        button.titleLabel?.font            = UIFont(name: "AmericanRypeWriter", size: 25)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let nextButton: UIButton            = {
        let button                        = UIButton()
        button.setTitle("next", for: .normal)
        button.titleLabel?.font            = UIFont(name: "AmericanRypeWriter", size: 25)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let dayLable: UILabel                 = {
        let lable                         = UILabel()
        lable.textAlignment             = .center
        lable.text                         = "Monday - 05/10/20"
        lable.font                         = UIFont(name: "AmericanTypeWriter-Bold", size: 20)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let summaryLable: UILabel             = {
        let lable                         = UILabel()
        lable.textAlignment             = .center
        lable.text                         = "1.25 / 3L"
        lable.font                         = UIFont(name: "AmericanTypeWriter-Bold", size: 40)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let drinkOptionStack: UIStackView     = {
        let stack                         = UIStackView()
        stack.axis                         = .horizontal
        stack.spacing                     = 15
        stack.alignment                 = .bottom
        stack.distribution                 = .equalSpacing
        let smallDrink                     = UIImageView()
        smallDrink.image                 = UIImage(named: "Glass")
        smallDrink.contentMode             = .scaleAspectFit
        let mediumDrink                 = UIImageView()
        mediumDrink.image                 = UIImage(named: "Bottle")
        mediumDrink.contentMode         = .scaleAspectFit
        let largeDrink                     = UIImageView()
        largeDrink.image                 = UIImage(named: "Flask")
        largeDrink.contentMode             = .scaleAspectFit
        
        smallDrink.translatesAutoresizingMaskIntoConstraints     = false
        mediumDrink.translatesAutoresizingMaskIntoConstraints     = false
        largeDrink.translatesAutoresizingMaskIntoConstraints     = false
        stack.addArrangedSubview(smallDrink)
        stack.addArrangedSubview(mediumDrink)
        stack.addArrangedSubview(largeDrink)
        smallDrink.heightAnchor.constraint(equalToConstant: 70).isActive     = true
        smallDrink.widthAnchor.constraint(equalToConstant: 50).isActive     = true
        mediumDrink.heightAnchor.constraint(equalToConstant: 120).isActive     = true
        mediumDrink.widthAnchor.constraint(equalToConstant: 80).isActive     = true
        largeDrink.heightAnchor.constraint(equalToConstant: 140).isActive     = true
        largeDrink.widthAnchor.constraint(equalToConstant: 80).isActive     = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let smallDrinkLable: UILabel         = {
        let lable                         = UILabel()
        lable.textAlignment             = .center
        lable.text                         = "300ml"
        lable.font                         = UIFont(name: "AmericanTypeWriter", size: 17)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let mediumDrinkLable: UILabel         = {
        let lable                         = UILabel()
        lable.textAlignment             = .center
        lable.text                         = "500ml"
        lable.font                         = UIFont(name: "AmericanTypeWriter", size: 17)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let largeDrinkLable: UILabel         = {
        let lable                         = UILabel()
        lable.textAlignment             = .center
        lable.text                         = "750ml"
        lable.font                         = UIFont(name: "AmericanTypeWriter", size: 17)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let settingsButton: UIButton         = {
        let button                         = UIButton()
        button.setBackgroundImage(UIImage(systemName: "gear"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints                 = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive     = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive     = true
        return button
    }()
    let calendarButton: UIButton         = {
        let button                         = UIButton()
        button.setBackgroundImage(UIImage(systemName: "calendar.circle"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints                 = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive     = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive     = true
        return button
    }()
    let explanationLabel: UILabel		= {
        let lable						= UILabel()
        lable.text						= "Explain whats showed"
        lable.font						= UIFont(name: "AmericanTypewriter-Bold", size: 25)
        lable.textAlignment				= .center
        lable.numberOfLines             = 0
        lable.translatesAutoresizingMaskIntoConstraints             = false
        lable.widthAnchor.constraint(equalToConstant: 250).isActive = true
        return lable
    }()
    
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
        metricUnits				= UserDefaults.standard.bool(forKey: "metricUnits")
        darkMode 				= UserDefaults.standard.bool(forKey: "darkMode")
        changeAppearance()
    }
    
    
    
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
            self.view.backgroundColor 	= .white
            tableView.backgroundColor 	= .white
            exitButton.tintColor		= .black
        } else{
            self.view.backgroundColor 	= hexStringToUIColor(hex: "#212121")
            tableView.backgroundColor 	= hexStringToUIColor(hex: "#212121")
            exitButton.tintColor		= .lightGray
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
        var section = 0
        while section < tableView.numberOfSections && tableView.numberOfSections != 0{
            let headerCell = tableView.headerView(forSection: section) as! SettingsHeader
            headerCell.setHeaderAppairents(self.darkMode)
            var row = 0
            while row < tableView.numberOfRows(inSection: section) {
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
    
    @objc func skip(_ sender: UIBarButtonItem){
        toturialVC.dismiss(animated: true, completion: nil)
    }
    @objc func nextClick(_ sender: UIBarButtonItem){
        print("Go to next view")
        stage += 1
        
        switch stage {
            case 1:
                explanationLabel.text = "Here is you consumed amount and your goal for the day."
                dayLable.textColor = hexStringToUIColor(hex: "#666666")
                if darkMode {
                    summaryLable.textColor = .white
                } else {
                    summaryLable.textColor = .black
            	}
            case 2:
                summaryLable.textColor = hexStringToUIColor(hex: "#666666")
                let imageArray = [UIImage(named: "Glass"), UIImage(named: "Bottle"), UIImage(named: "Flask")]
                var position = 0
                while position < drinkOptionStack.subviews.count {
                    let drink = drinkOptionStack.subviews[position] as! UIImageView
                    drink.image = imageArray[position]
                    position += 1
                }
                if darkMode {
                    smallDrinkLable.textColor = .white
                    mediumDrinkLable.textColor = .white
                    largeDrinkLable.textColor = .white
                } else {
                    smallDrinkLable.textColor = .black
                    mediumDrinkLable.textColor = .black
                    largeDrinkLable.textColor = .black
                }
                explanationLabel.text = "Here is the different drinks you can use. Click on a drink to add it too your total amount."
            case 3:
                for drink in drinkOptionStack.subviews {
                    let drinkOption = drink as! UIImageView
                    drinkOption.image = drinkOption.image?.grayed
                }
                smallDrinkLable.textColor = hexStringToUIColor(hex: "#666666")
                mediumDrinkLable.textColor = hexStringToUIColor(hex: "#666666")
                largeDrinkLable.textColor = hexStringToUIColor(hex: "#666666")
                if darkMode {
                    settingsButton.tintColor = .lightGray
                } else {
                    settingsButton.tintColor = .black
                }
                explanationLabel.text = "Click on this to go to app settings."
            case 4:
                settingsButton.tintColor = hexStringToUIColor(hex: "#666666")
                if darkMode {
                    calendarButton.tintColor = .lightGray
                } else {
                    calendarButton.tintColor = .black
                }
                explanationLabel.text = "Click on this to see you history"
                nextButton.setTitle("done", for: .normal)
            case 5:
                toturialVC.dismiss(animated: true, completion: nil)
            default:
                break
        }
    }

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
                stage = 0
                print("help pressed")
                if darkMode{
                    toturialVC.view.backgroundColor = hexStringToUIColor(hex: "#212121")
                    // Mark: Lables
                    dayLable.textColor 				= .white
                    summaryLable.textColor 			= .white
                    smallDrinkLable.textColor 		= .white
                    mediumDrinkLable.textColor 		= .white
                    largeDrinkLable.textColor 		= .white
                    explanationLabel.textColor 		= .white
                    // Mark: Buttons
                    settingsButton.tintColor		= .lightGray
                    calendarButton.tintColor		= .lightGray
                } else {
                    toturialVC.view.backgroundColor = .white
                    // Mark: Lables
                    dayLable.textColor 				= .black
                    summaryLable.textColor 			= .black
                    smallDrinkLable.textColor 		= .black
                    mediumDrinkLable.textColor 		= .black
                    largeDrinkLable.textColor 		= .black
                    explanationLabel.textColor 		= .black
                    // Mark: Buttons
                    settingsButton.tintColor 		= .black
                    calendarButton.tintColor 		= .black
                }
                
                
                toturialVC.view.addSubview(toolBar)
                toturialVC.view.addSubview(dayLable)
                toturialVC.view.addSubview(summaryLable)
                toturialVC.view.addSubview(drinkOptionStack)
                toturialVC.view.addSubview(smallDrinkLable)
                toturialVC.view.addSubview(mediumDrinkLable)
                toturialVC.view.addSubview(largeDrinkLable)
                toturialVC.view.addSubview(settingsButton)
                toturialVC.view.addSubview(calendarButton)
                toturialVC.view.addSubview(explanationLabel)
                toolBar.addSubview(skipButton)
                toolBar.addSubview(nextButton)
                
                toolBar.leftAnchor.constraint(equalTo: toturialVC.view.leftAnchor, constant: 0).isActive					= true
                toolBar.rightAnchor.constraint(equalTo: toturialVC.view.rightAnchor, constant: 0).isActive					= true
                toolBar.topAnchor.constraint(equalTo: toturialVC.view.topAnchor, constant: 0).isActive						= true
                toolBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive									= true
                skipButton.leftAnchor.constraint(equalTo: toolBar.leftAnchor, constant: 20).isActive						= true
                skipButton.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: 50).isActive							= true
                nextButton.rightAnchor.constraint(equalTo: toolBar.rightAnchor, constant: -20).isActive						= true
                nextButton.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: 50).isActive							= true
                dayLable.centerXAnchor.constraint(equalTo: toturialVC.view.centerXAnchor).isActive							= true
                dayLable.topAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: 40).isActive							= true
                summaryLable.centerXAnchor.constraint(equalTo: toturialVC.view.centerXAnchor).isActive						= true
                summaryLable.topAnchor.constraint(equalTo: dayLable.bottomAnchor, constant: 10).isActive                    = true
                drinkOptionStack.centerXAnchor.constraint(equalTo: toturialVC.view.centerXAnchor, constant: 20).isActive    = true
                drinkOptionStack.topAnchor.constraint(equalTo: summaryLable.bottomAnchor, constant: 20).isActive            = true
                smallDrinkLable.centerXAnchor.constraint(equalTo: drinkOptionStack.subviews[0].centerXAnchor).isActive		= true
                mediumDrinkLable.centerXAnchor.constraint(equalTo: drinkOptionStack.subviews[1].centerXAnchor).isActive		= true
                largeDrinkLable.centerXAnchor.constraint(equalTo: drinkOptionStack.subviews[2].centerXAnchor).isActive		= true
                smallDrinkLable.topAnchor.constraint(equalTo: drinkOptionStack.bottomAnchor).isActive						= true
                mediumDrinkLable.topAnchor.constraint(equalTo: drinkOptionStack.bottomAnchor).isActive						= true
                largeDrinkLable.topAnchor.constraint(equalTo: drinkOptionStack.bottomAnchor).isActive						= true
                settingsButton.leftAnchor.constraint(equalTo: toturialVC.view.leftAnchor, constant: 30).isActive            = true
                settingsButton.bottomAnchor.constraint(equalTo: toturialVC.view.bottomAnchor, constant: -30).isActive		= true
                calendarButton.rightAnchor.constraint(equalTo: toturialVC.view.rightAnchor, constant: -30).isActive			= true
                calendarButton.bottomAnchor.constraint(equalTo: toturialVC.view.bottomAnchor, constant: -30).isActive		= true
                explanationLabel.topAnchor.constraint(equalTo: drinkOptionStack.bottomAnchor,constant: 40).isActive			= true
                explanationLabel.centerXAnchor.constraint(equalTo: toturialVC.view.centerXAnchor).isActive					= true
                
                skipButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.skip(_:))))
                nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextClick(_:))))
                
                nextButton.setTitle("next", for: .normal)
                if darkMode {
                    dayLable.textColor = .white
                } else {
                    dayLable.textColor = .black
                }
                summaryLable.textColor = hexStringToUIColor(hex: "#666666")
                for drink in drinkOptionStack.subviews {
                    let drinkOption = drink as! UIImageView
                    drinkOption.image = drinkOption.image?.grayed
                }
                smallDrinkLable.textColor = hexStringToUIColor(hex: "#666666")
                mediumDrinkLable.textColor = hexStringToUIColor(hex: "#666666")
                largeDrinkLable.textColor = hexStringToUIColor(hex: "#666666")
                settingsButton.tintColor = hexStringToUIColor(hex: "#666666")
                calendarButton.tintColor = hexStringToUIColor(hex: "#666666")
                explanationLabel.text = "This is the current day"
                
                toturialVC.modalPresentationStyle = .fullScreen
                self.present(toturialVC, animated: true, completion: nil)
            case settings.firstIndex(where: {$0.setting == "remove data"}):
                // This will clear all the saved data from past days.
                let clearDataAlert = UIAlertController(title: "Clearing data", message: "are you sure you want to delete all save data?", preferredStyle: .alert)
                clearDataAlert.addAction(UIAlertAction(title: "keep data", style: .cancel, handler: nil))
                clearDataAlert.addAction(UIAlertAction(title: "REMOVE DATA", style: .destructive, handler: {_ in
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()}))
                
                self.present(clearDataAlert, animated: true, completion: nil)
            default:
                var indexPaths 				= [IndexPath]()
                for row in settings[section].options.indices {
                    let indexPath 			= IndexPath(row: row, section: section)
                    indexPaths.append(indexPath)
                }
                let header = tableView.headerView(forSection: section) as! SettingsHeader
                let ioOpend 				= settings[section].isOpened
                settings[section].isOpened 	= !ioOpend
                if ioOpend {
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
            cell.button.removeFromSuperview()
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
            default:
            break
        }
    }
}

extension UIImage {
    var grayed: UIImage {
        guard let ciImage = CIImage(image: self)
            else { return self }
        let filterParameters = [ kCIInputColorKey: CIColor.white, kCIInputIntensityKey: 1.0 ] as [String: Any]
        let grayscale = ciImage.applyingFilter("CIColorMonochrome", parameters: filterParameters)
        return UIImage(ciImage: grayscale)
    }
}
