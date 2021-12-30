//
//  AppDelegate.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 12/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
            center.requestAuthorization(options: [.sound, .alert]) { granted, _ in
                print("Access \(granted)")
            }
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification, withCompletionHandler
                                completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner, .list])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
            if response.actionIdentifier == "small" {
                print("small button was pressed")
                NotificationCenter.default.post(name: .addedSmallDrink, object: nil)
                completionHandler()
            } else if response.actionIdentifier == "medium"{
                print("medium button was pressed")
                NotificationCenter.default.post(name: .addedMediumDrink, object: nil)
                completionHandler()
            } else if response.actionIdentifier == "large"{
                print("large button was pressed")
                NotificationCenter.default.post(name: .addedLargeDrink, object: nil)
                completionHandler()
            } else {
                print("unrecogniced button was pressed")
            }
        }
}
