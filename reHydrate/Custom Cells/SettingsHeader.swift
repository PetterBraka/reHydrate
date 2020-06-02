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
        let lable       = UILabel()
        lable.text      = "Test"
        lable.font      = UIFont(name: "AmericanTypewriter", size: 18)
        lable.textColor = .white
        lable.translatesAutoresizingMaskIntoConstraints	= false
        return lable
    }()
    var container: UIView = {
       let view              = UIView()
        view.clipsToBounds   = true
        view.backgroundColor = .lightGray
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints	= false
        return view
    }()
    var darkMode = Bool()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled  = true
        self.backgroundView            = {
            let background             = UIView()
            background.backgroundColor = .none
            return background
        }()
        setHeaderAppairents(darkMode)
        contentView.addSubview(container)
        container.addSubview(title)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Setting all the constraints for the views.
     
     # Example #
     ```
     container.addSubview(title)
     container.addSubview(button)
     setConstraints()
     ```
     */
    fileprivate func setConstraints() {
        title.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 10).isActive = true
        title.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive         = true
        
        container.topAnchor.constraint(equalTo:contentView.topAnchor).isActive            = true
        container.leftAnchor.constraint(equalTo:contentView.leftAnchor).isActive          = true
        container.rightAnchor.constraint(equalTo:contentView.rightAnchor).isActive        = true
        container.bottomAnchor.constraint(equalTo:contentView.bottomAnchor).isActive      = true
    }
    
    /**
     Changes the apparentce of the **SettingsHeader** deppending on the users preferents.
     
     # Example #
     ```
     setHeaderAppairents(darkMode)
     ```
     */
    func setHeaderAppairents(_ darkMode: Bool){
        if darkMode {
            title.textColor = .white
            container.backgroundColor = UIColor().hexStringToUIColor("#404040")
        } else {
            title.textColor = .black
            container.backgroundColor = UIColor().hexStringToUIColor("#d9d9d9")
        }
    }
}
