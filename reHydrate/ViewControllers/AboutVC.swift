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
    
    var darkMode					= true
    var metricUnits					= true
    let helpImage 					= UIImageView.init(image: UIImage.init(named: "toturial-1"))
    var selectedRow: IndexPath 		= IndexPath()
    var settings: [settingOptions] 	= [
        settingOptions(isOpened: false, setting: "appearance", options: ["Light Mode", "Dark Mode"]),
        settingOptions(isOpened: false, setting: "unit system", options: ["Metric System", "Imperial System"]),
        settingOptions(isOpened: false, setting: "change goal", options: ["Goal"]),
        settingOptions(isOpened: false, setting: "how to use", options: []),
        settingOptions(isOpened: false, setting: "remove data", options: [])]
    
    
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
                self.view.addSubview(helpImage)
                
                helpImage.translatesAutoresizingMaskIntoConstraints 								= false
                helpImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive 		= true
                helpImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive 	= true
                helpImage.topAnchor.constraint(equalTo: self.exitButton.bottomAnchor).isActive 		= true
                helpImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive 		= true
                helpImage.isUserInteractionEnabled 													= true
                helpImage.contentMode 																= .scaleAspectFit
                tableView.isHidden 																	= true
            
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

