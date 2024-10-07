//
//  Notification+Extensions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import UserNotifications
import UserNotificationServiceInterface

extension UNNotificationAction {
    convenience init(from action: NotificationAction) {
        self.init(
            identifier: action.identifier,
            title: action.title,
            icon: nil
        )
    }
}

extension NotificationAction {
    init(from action: UNNotificationAction) {
        self.init(
            identifier: action.identifier,
            title: action.title
        )
    }
}

extension UNNotificationCategory {
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

extension NotificationCategory {
    init(from category: UNNotificationCategory) {
        self.init(
            identifier: category.identifier,
            actions: category.actions.map { .init(from: $0) },
            intentIdentifiers: category.intentIdentifiers
        )
    }
}

extension UNNotificationRequest {
    convenience init(from request: NotificationRequest) {
        self.init(
            identifier: request.identifier,
            content: .create(from: request.content),
            trigger: .create(from: request.trigger)
        )
    }
}

extension NotificationRequest {
    init(from request: UNNotificationRequest) {
        self.init(
            identifier: request.identifier,
            content: .init(from: request.content),
            trigger: .init(from: request.trigger as? UNCalendarNotificationTrigger)
        )
    }
}

extension UNNotificationContent {
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

extension NotificationContent {
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

extension UNNotificationTrigger {
    static func create(from trigger: NotificationTrigger?) -> UNCalendarNotificationTrigger? {
        guard let trigger else { return nil }
        return UNCalendarNotificationTrigger(
            dateMatching: trigger.dateComponents,
            repeats: trigger.repeats
        )
    }
}

extension NotificationTrigger {
    init?(from trigger: UNCalendarNotificationTrigger?) {
        guard let trigger else { return nil }
        self.init(
            repeats: trigger.repeats,
            dateComponents: trigger.dateComponents
        )
    }
}

extension DeliveredNotification {
    init(from notification: UNNotification) {
        self.init(
            date: notification.date,
            request: .init(from: notification.request)
        )
    }
}

extension NotificationResponse {
    init(from response: UNNotificationResponse) {
        self.init(actionIdentifier: response.actionIdentifier)
    }
}
