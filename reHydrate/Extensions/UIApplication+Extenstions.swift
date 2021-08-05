//
//  UIApplication+Extenstions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 30/05/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

extension UIApplication {
    
    /**
     Will check if it is the first time the app is ever launched on this phone
     
     - returns: **Bool** true if its the first time false if not.
     
     # Example #
     ```
     if UIApplication.isFirstLaunch() {
     print("first time to launch this app")
     //Do something
     }
     ```
     */
    class func isFirstLaunch() -> Bool {
        if !Defaults[\.lastVersion] {
            Defaults[\.lastVersion] = true
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}

