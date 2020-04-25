//
//  SettingsHeader.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 22/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class SettingsHeader: UITableViewHeaderFooterView {
    var setting: settingOptions? {
        didSet {
            guard let setting = setting else {return}
            self.title.text = setting.setting.uppercased()
        }
    }
    var title: UILabel 	= {
        let lable 		= UILabel()
        lable.text 		= "Test"
        lable.font 		= UIFont(name: "AmericanTypewriter", size: 20)
        lable.textColor = .white
        lable.translatesAutoresizingMaskIntoConstraints		= false
        return lable
    }()
    var button: UIButton 	= {
        let button			= UIButton()
        button.tintColor    = .lightGray
        button.setTitle("", for: .normal)
        button.setBackgroundImage( UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints	= false
        return button
    }()
    var container: UIView = {
       let view 				= UIView()
        view.clipsToBounds		= true
        view.backgroundColor	= .none
        view.isUserInteractionEnabled						= true
        view.translatesAutoresizingMaskIntoConstraints		= false
        return view
    }()
    var darkMode = Bool()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled 	= true
        self.backgroundView 			= {
            let background 				= UIView()
            background.backgroundColor 	= .none
            return background
        }()
        setHeaderAppairents(darkMode)
        contentView.addSubview(container)
        container.addSubview(title)
        container.addSubview(button)
        title.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 10).isActive       = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive							= true
        button.widthAnchor.constraint(equalToConstant: 25).isActive								= true
        button.rightAnchor.constraint(equalTo: container.rightAnchor).isActive    				= true
        button.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive					= true
        
        container.topAnchor.constraint(equalTo:contentView.topAnchor).isActive                 	= true
        container.leftAnchor.constraint(equalTo:contentView.leftAnchor).isActive 				= true
        container.rightAnchor.constraint(equalTo:contentView.rightAnchor).isActive             	= true
        container.bottomAnchor.constraint(equalTo:contentView.bottomAnchor).isActive         	= true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setHeaderAppairents(_ darkMode: Bool){
        if darkMode {
            button.tintColor = .lightGray
            title.textColor = .white
            container.backgroundColor = hexStringToUIColor(hex: "#212121")
        } else {
            button.tintColor = .black
            title.textColor = .black
            container.backgroundColor = .white
        }
        if title.text == String("remove data").uppercased(){
            title.textColor = .systemRed
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
