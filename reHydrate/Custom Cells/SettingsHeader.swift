//
//  SettingsHeader.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 22/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class SettingsHeader: UITableViewHeaderFooterView {
    var darkMode = Bool()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled  = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            self.contentView.backgroundColor = UIColor().hexStringToUIColor("212121")
        } else {
            self.contentView.backgroundColor = UIColor().hexStringToUIColor("ebebeb")
        }
    }
}
