//
//  SettingOptionCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 24/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class SettingOptionCell: UITableViewCell {
    var setting: String? {
        didSet {
            guard let string 	= setting else {return}
            option.text 		= string.capitalized
        }
    }
    let option: UILabel = {
        let lable 			= UILabel()
        lable.text 			= "test"
        lable.textColor 	= UIColor.white
        lable.font 			= UIFont(name: "AmericanTypewriter", size: 17)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
        }()
    var darkMode = Bool()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settCellAppairents(darkMode)
        self.addSubview(option)
        option.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive 	= true
        option.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive 			= true
        self.backgroundColor 															= .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settCellAppairents(_ darkMode: Bool){
        if darkMode {
            option.textColor = .white
            self.backgroundColor = hexStringToUIColor(hex: "#212121")
        } else {
            option.textColor = .black
            self.backgroundColor = .white
        }
    }
    
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
