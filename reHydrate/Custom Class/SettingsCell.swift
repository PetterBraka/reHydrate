//
//  SettingsCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 22/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    @IBOutlet weak var settingLable: UILabel!
    
    enum settingsOptions: String {
        case darkMode = "dark mode"
        case howToUse = "how to use"
        case unitSystem = "unit"
        case changeGoal = "change goal"
        case removeData = "remove old data"
    }
    
    
    func setLabels(_ setting: String){
        settingLable.text = setting.uppercased()
        
        switch setting {
            case settingsOptions.darkMode.rawValue:
                let settingSwitch = UISwitch.init()
                settingSwitch.isOn = true
                self.addSubview(settingSwitch)
            
                settingSwitch.translatesAutoresizingMaskIntoConstraints = false
                settingSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
                settingSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            case settingsOptions.unitSystem.rawValue:
                
                let dropDownButton = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                dropDownButton.setTitle("liters", for: .normal)
                self.addSubview(dropDownButton)
                
                dropDownButton.translatesAutoresizingMaskIntoConstraints = false
                dropDownButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
                dropDownButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                break
            default:
            break
        }
        
    }

}
