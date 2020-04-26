//
//  SettingOptionCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 24/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class SettingOptionCell: UITableViewCell {
    var darkMode                = Bool()
    var metricUnits				= Bool()
    var setting: String? {
        didSet {
            guard let string 	= setting else {return}
            titleOption.text 		= string
        }
    }
    let titleOption: UILabel 		= {
        let lable 				= UILabel()
        lable.text 				= "test"
        lable.font 				= UIFont(name: "AmericanTypewriter", size: 17)
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
    let activatedOption: UIButton     = {
        let button                = UIButton()
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settCellAppairents(darkMode, true)
        self.addSubview(titleOption)
        self.addSubview(activatedOption)
        settButtonConstraints()
        titleOption.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive 				= true
        titleOption.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive 						= true
        self.backgroundColor 																			= .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubTitle(_ string: String){
        subTitle.text = string
        self.addSubview(subTitle)
        self.removeConstraints(self.constraints)
        titleOption.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive		= true
        titleOption.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive    			= true
        subTitle.leftAnchor.constraint(equalTo: titleOption.leftAnchor, constant: 10).isActive 			= true
        subTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10).isActive			= true
        settButtonConstraints()
    }
    
    /**
     Setting the constraints for the activate button.
     
     # Example #
     ```
     setActivatedButtonConstraints()
     ```
     */
    func settButtonConstraints() {
        activatedOption.widthAnchor.constraint(equalToConstant: 25).isActive                    		= true
        activatedOption.heightAnchor.constraint(equalToConstant: 25).isActive                   		= true
        activatedOption.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive 			= true
        activatedOption.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive 		= true
    }
    
    /**
     Changes the apparentce of the **SettingOptionCell** deppending on the users preferents.
     
     # Example #
     ```
     settCellAppairents(darkMode)
     ```
     */
    func settCellAppairents(_ dark: Bool,_ metric: Bool){
        if dark{
            activatedOption.tintColor     = .lightGray
            titleOption.textColor         = .white
            subTitle.textColor            = .white
            self.backgroundColor = hexStringToUIColor(hex: "#212121")
        } else {
            activatedOption.tintColor     = .black
            titleOption.textColor         = .black
            subTitle.textColor            = .black
            self.backgroundColor          = .white
        }
        switch titleOption.text {
            case "Dark Mode":
                if dark{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case "Light Mode":
                if !dark{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case "Metric System":
                if metric{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
                break
            case "Imperial System":
                if !metric{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
                break
            default:
                break
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
    
}
