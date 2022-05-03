//
//  AppDelegate.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 12/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import Firebase
import UIKit
import UserNotifications
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    private var tasks = Set<AnyCancellable>()

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.braka.reHydrate.fetchHealth",
            using: DispatchQueue(label: "FetchingHealth", qos: .background)) { task in
                self.handleHealthRefresh(task)
            }

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert]) { granted, _ in
            print("Access \(granted)")
        }
        return true
    }

    private func handleHealthRefresh(_ task: BGTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        let navigateTo: (AppState) -> Void = {_ in }
        let homeViewModel = MainAssembler.shared.container.resolve(HomeViewModel.self,
                                                                   argument: navigateTo)!
        homeViewModel.futureFetchHealthData()
            .sink { _ in
                task.setTaskCompleted(success: true)
            }.store(in: &tasks)
        print("Doing background jobs")
        scheduleAppRefresh()
    }

    func scheduleAppRefresh() {
        do {
            let request = BGAppRefreshTaskRequest(identifier: "com.braka.reHydrate.fetchHealth")
            request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60 * 1)
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print(error)
        }
    }

    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent _: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        completionHandler([.sound, .banner, .list])
    }

    func userNotificationCenter(_: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "small" {
            print("small button was pressed")
            NotificationCenter.default.post(name: .addedSmallDrink, object: nil)
            completionHandler()
        } else if response.actionIdentifier == "medium" {
            print("medium button was pressed")
            NotificationCenter.default.post(name: .addedMediumDrink, object: nil)
            completionHandler()
        } else if response.actionIdentifier == "large" {
            print("large button was pressed")
            NotificationCenter.default.post(name: .addedLargeDrink, object: nil)
            completionHandler()
        } else {
            print("unrecogniced button was pressed")
        }
    }
}
