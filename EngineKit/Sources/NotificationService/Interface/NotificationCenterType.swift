//
//  NotificationCenterType.swift
//
//
//  Created by Petter vang Brakalsvålet on 26/09/2023.
//

public protocol NotificationCenterType {
    func requestAuthorization() async throws -> Bool
    func setNotificationCategories(_ categories: Set<NotificationCategory>)
    func notificationCategories() async -> Set<NotificationCategory>
    func add(_ request: NotificationRequest) async throws
    func pendingNotificationRequests() async -> [NotificationRequest]
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
    func removeAllPendingNotificationRequests()
    func deliveredNotifications() async -> [DeliveredNotification]
    func removeDeliveredNotifications(withIdentifiers identifiers: [String])
    func removeAllDeliveredNotifications()
    func setBadgeCount(_ newBadgeCount: Int) async throws
}
