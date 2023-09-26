//
//  NotificationCenterType.swift
//
//
//  Created by Petter vang Brakalsvålet on 26/09/2023.
//

import UserNotifications

public protocol NotificationCenterType {
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func setNotificationCategories(_ categories: Set<UNNotificationCategory>)
    func notificationCategories() async -> Set<UNNotificationCategory>
    func add(_ request: UNNotificationRequest) async throws
    func pendingNotificationRequests() async -> [UNNotificationRequest]
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
    func removeAllPendingNotificationRequests()
    func deliveredNotifications() async -> [UNNotification]
    func removeDeliveredNotifications(withIdentifiers identifiers: [String])
    func removeAllDeliveredNotifications()
    func setBadgeCount(_ newBadgeCount: Int) async throws
}
