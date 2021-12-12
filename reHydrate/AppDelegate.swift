//
//  AppDelegate.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 12/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
            if response.actionIdentifier == "small" {
                print("small button was pressed")
//                updateConsumtion(drinkOptions[0])
                completionHandler()
            } else if response.actionIdentifier == "medium"{
                print("medium button was pressed")
//                updateConsumtion(drinkOptions[1])
                completionHandler()
            } else if response.actionIdentifier == "large"{
                print("large button was pressed")
//                updateConsumtion(drinkOptions[2])
                completionHandler()
            } else {
                print("unrecogniced button was pressed")
            }
        }
}
