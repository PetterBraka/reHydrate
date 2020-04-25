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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(option)
        option.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive 	= true
        option.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive 			= true
        self.backgroundColor 															= .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
