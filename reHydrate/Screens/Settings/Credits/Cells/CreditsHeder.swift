//
//  creditsHeder.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 13/12/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class CreditsHeder: UITableViewHeaderFooterView {
    let title: UILabel = {
        let lable   = UILabel()
        lable.text  = "Title"
        lable.font  = .title
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled  = false
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setConstraints(){
        self.contentView.addSubview(title)
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive         = true
    }
    
    /**
     Changes the apparentce of the **SettingsHeader** deppending on the users preferents.
     
     # Example #
     ```
     setHeaderAppairents(darkMode)
     ```
     */
    func setAppairents(_ darkMode: Bool){
        if darkMode {
            self.title.textColor = .white
            self.contentView.backgroundColor = UIColor().hexStringToUIColor("212121")
        } else {
            self.title.textColor = .black
            self.contentView.backgroundColor = UIColor().hexStringToUIColor("ebebeb")
        }
    }
}

