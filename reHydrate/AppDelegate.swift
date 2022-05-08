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
            using: DispatchQueue(label: "background.fetch.health.data")) { task in
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
        scheduleAppRefresh()

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        let presistentController = MainAssembler.shared.container.resolve(PersistenceControllerProtocol.self)!
        let context =  presistentController.newBackgroundContext()
        let viewModel = HomeViewModel(presistenceController: presistentController,
                                      context: context)

        let operations = [
            BlockOperation {
                viewModel.fetchHealthData()
            }
        ]

        let lastOperation = operations.last!

        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        lastOperation.completionBlock = {
            task.setTaskCompleted(success: !lastOperation.isCancelled)
        }

        queue.addOperations(operations, waitUntilFinished: false)
    }

    func scheduleAppRefresh() {
        do {
            let request = BGAppRefreshTaskRequest(identifier: "com.braka.reHydrate.fetchHealth")
            request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 30)
            try BGTaskScheduler.shared.submit(request)
            print("Task has been submitted.\nRequested task: \(request)")
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
