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
        button.setImage( UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
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
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled 	= true
        self.backgroundView 			= {
            let background 				= UIView()
            background.backgroundColor 	= .none
            return background
        }()
        contentView.addSubview(container)
        container.addSubview(title)
        container.addSubview(button)
        title.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 10).isActive       = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive							= true
        button.widthAnchor.constraint(equalToConstant: 50).isActive								= true
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
    
}
