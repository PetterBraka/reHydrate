//
//  NotificationCenterPort.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 26/09/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import UserNotificationServiceInterface
import UserNotifications

extension UNUserNotificationCenter: @retroactive UserNotificationCenterType {
    public func requestAuthorization() async throws -> Bool {
        try await requestAuthorization(options: [UNAuthorizationOptions.badge, .sound, .alert])
    }
    
    public func setNotificationCategories(_ categories: Set<NotificationCategory>) {
        let categories: [UNNotificationCategory] = categories.map {
            UNNotificationCategory.init(from: $0)
        }
        setNotificationCategories(Set(categories))
    }
    
    public func notificationCategories() async -> Set<NotificationCategory> {
        let categories: Set<UNNotificationCategory> = await notificationCategories()
        return Set(categories.map { .init(from: $0) })
    }
    
    public func add(_ request: NotificationRequest) async throws {
        try await add(UNNotificationRequest(from: request))
    }
    
    public func pendingNotificationRequests() async -> [NotificationRequest] {
        let requests: [UNNotificationRequest] = await pendingNotificationRequests()
        return requests.map { .init(from: $0) }
    }
    
    public func deliveredNotifications() async -> [DeliveredNotification] {
        let notifications: [UNNotification] = await deliveredNotifications()
        return notifications.map { .init(from: $0) }
    }
}
