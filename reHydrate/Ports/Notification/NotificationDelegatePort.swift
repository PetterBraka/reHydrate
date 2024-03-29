//
//  NotificationDelegatePort.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import NotificationServiceInterface
import UserNotifications

final class NotificationDelegatePort: NSObject {
    public typealias Engine = (
        HasNotificationService
    )
    
    let engine: Engine
    
    init(engine: Engine) {
        self.engine = engine
    }
}

extension NotificationDelegatePort: UNUserNotificationCenterDelegate {
    @MainActor
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        await engine.notificationDelegate.userNotificationCenter(
            center, didReceive: .init(from: response)
        )
    }
    
    @MainActor
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        await engine.notificationDelegate.userNotificationCenter(
            center, willPresent: .init(from: notification)
        )
        return [.banner, .list, .sound]
    }
    
    @MainActor
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        openSettingsFor notification: UNNotification?
    ) {
        if let notification {
            engine.notificationDelegate.userNotificationCenter(
                center,
                openSettingsFor: .init(date: notification.date,
                                       request: .init(from: notification.request))
            )
        } else {
            engine.notificationDelegate.userNotificationCenter(
                center, openSettingsFor: nil
            )
        }
    }
}
