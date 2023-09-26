//
//  File.swift
//
//
//  Created by Petter vang Brakalsvålet on 26/09/2023.
//

import Foundation
import UserNotifications
import NotificationServiceInterface

final class NotificationCenterSpy {
    enum MethodName {
        case requestAuthorization
        case setNotificationCategories
        case notificationCategories
        case add
        case pendingNotificationRequests
        case removePendingNotificationRequests
        case removeAllPendingNotificationRequests
        case deliveredNotifications
        case removeDeliveredNotifications
        case removeAllDeliveredNotifications
        case setBadgeCount
    }
    
    var methodLog: [MethodName] = []
    let realObject: UNUserNotificationCenter
    
    init(realObject: UNUserNotificationCenter) {
        self.realObject = realObject
    }
}

extension NotificationCenterSpy: NotificationCenterType {
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        methodLog.append(.requestAuthorization)
        return try await realObject.requestAuthorization(options: options)
    }
    
    func setNotificationCategories(_ categories: Set<UNNotificationCategory>) {
        methodLog.append(.setNotificationCategories)
        realObject.setNotificationCategories(categories)
    }
    
    func notificationCategories() async -> Set<UNNotificationCategory> {
        methodLog.append(.notificationCategories)
        return await realObject.notificationCategories()
    }
    
    func add(_ request: UNNotificationRequest) async throws {
        methodLog.append(.add)
        try await realObject.add(request)
    }
    
    func pendingNotificationRequests() async -> [UNNotificationRequest] {
        methodLog.append(.pendingNotificationRequests)
        return await realObject.pendingNotificationRequests()
    }
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        methodLog.append(.removePendingNotificationRequests)
        realObject.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func removeAllPendingNotificationRequests() {
        methodLog.append(.removeAllPendingNotificationRequests)
        realObject.removeAllPendingNotificationRequests()
    }
    
    func deliveredNotifications() async -> [UNNotification] {
        methodLog.append(.deliveredNotifications)
        return await realObject.deliveredNotifications()
    }
    
    func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
        methodLog.append(.removeDeliveredNotifications)
        realObject.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    
    func removeAllDeliveredNotifications() {
        methodLog.append(.removeAllDeliveredNotifications)
        realObject.removeAllDeliveredNotifications()
    }
    
    func setBadgeCount(_ newBadgeCount: Int) async throws {
        methodLog.append(.setBadgeCount)
        try await realObject.setBadgeCount(newBadgeCount)
    }
}
