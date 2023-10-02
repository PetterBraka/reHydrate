//
//  NotificationCenterPort.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 26/09/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import NotificationServiceInterface
import UserNotifications

extension UNUserNotificationCenter: NotificationCenterType {
    public func requestAuthorization() async throws -> Bool {
        try await requestAuthorization(options: [UNAuthorizationOptions.badge, .sound])
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

private extension UNNotificationAction {
    convenience init(from action: NotificationAction) {
        self.init(
            identifier: action.identifier,
            title: action.title,
            icon: nil
        )
    }
}

private extension NotificationAction {
    init(from action: UNNotificationAction) {
        self.init(
            identifier: action.identifier,
            title: action.title
        )
    }
}

private extension UNNotificationCategory {
    convenience init(from category: NotificationCategory) {
        self.init(
            identifier: category.identifier,
            actions: category.actions.map { .init(from: $0) },
            intentIdentifiers: category.intentIdentifiers,
            hiddenPreviewsBodyPlaceholder: nil,
            categorySummaryFormat: nil
        )
    }
}

private extension NotificationCategory {
    init(from category: UNNotificationCategory) {
        self.init(
            identifier: category.identifier,
            actions: category.actions.map { .init(from: $0) },
            intentIdentifiers: category.intentIdentifiers
        )
    }
}

private extension UNNotificationRequest {
    convenience init(from request: NotificationRequest) {
        self.init(
            identifier: request.identifier,
            content: .create(from: request.content),
            trigger: .create(from: request.trigger)
        )
    }
}

private extension NotificationRequest {
    init(from request: UNNotificationRequest) {
        self.init(
            identifier: request.identifier,
            content: .init(from: request.content),
            trigger: .init(from: request.trigger as? UNCalendarNotificationTrigger)
        )
    }
}

private extension UNNotificationContent {
    static func create(from content: NotificationContent) -> UNMutableNotificationContent{
        let mutableContent = UNMutableNotificationContent()
        mutableContent.title = content.title
        mutableContent.subtitle = content.subtitle
        mutableContent.body = content.body
        mutableContent.categoryIdentifier = content.categoryIdentifier
        mutableContent.userInfo = content.userInfo
        return mutableContent
    }
}

private extension NotificationContent {
    init(from content: UNNotificationContent) {
        self.init(
            title: content.title,
            subtitle: content.subtitle,
            body: content.body,
            categoryIdentifier: content.categoryIdentifier,
            userInfo: content.userInfo
        )
    }
}

private extension UNNotificationTrigger {
    static func create(from trigger: NotificationTrigger?) -> UNCalendarNotificationTrigger? {
        guard let trigger else { return nil }
        return UNCalendarNotificationTrigger(
            dateMatching: trigger.dateComponents,
            repeats: trigger.repeats
        )
    }
}

private extension NotificationTrigger {
    init?(from trigger: UNCalendarNotificationTrigger?) {
        guard let trigger else { return nil }
        self.init(
            repeats: trigger.repeats,
            dateComponents: trigger.dateComponents
        )
    }
}

private extension DeliveredNotification {
    init(from notification: UNNotification) {
        self.init(
            date: notification.date,
            request: .init(from: notification.request)
        )
    }
}
