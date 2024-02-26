//
//  NotificationCenterSpy.swift
//
//
//  Created by Petter vang Brakalsvålet on 26/09/2023.
//

import Foundation
import NotificationServiceInterface

public final class NotificationCenterSpy {
    public enum MethodName {
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
    
    public var methodLog: [MethodName] = []
    private let realObject: NotificationCenterType
    
    public init(realObject: NotificationCenterType) {
        self.realObject = realObject
    }
}

extension NotificationCenterSpy: NotificationCenterType {
    public func requestAuthorization() async throws -> Bool {
        methodLog.append(.requestAuthorization)
        return try await realObject.requestAuthorization()
    }
    
    public func setNotificationCategories(_ categories: Set<NotificationCategory>) {
        methodLog.append(.setNotificationCategories)
        realObject.setNotificationCategories(categories)
    }
    
    public func notificationCategories() async -> Set<NotificationCategory> {
        methodLog.append(.notificationCategories)
        return await realObject.notificationCategories()
    }
    
    public func add(_ request: NotificationRequest) async throws {
        methodLog.append(.add)
        try await realObject.add(request)
    }
    
    public func pendingNotificationRequests() async -> [NotificationRequest] {
        methodLog.append(.pendingNotificationRequests)
        return await realObject.pendingNotificationRequests()
    }
    
    public func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        methodLog.append(.removePendingNotificationRequests)
        realObject.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    public func removeAllPendingNotificationRequests() {
        methodLog.append(.removeAllPendingNotificationRequests)
        realObject.removeAllPendingNotificationRequests()
    }
    
    public func deliveredNotifications() async -> [DeliveredNotification] {
        methodLog.append(.deliveredNotifications)
        return await realObject.deliveredNotifications()
    }
    
    public func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
        methodLog.append(.removeDeliveredNotifications)
        realObject.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    
    public func removeAllDeliveredNotifications() {
        methodLog.append(.removeAllDeliveredNotifications)
        realObject.removeAllDeliveredNotifications()
    }
    
    public func setBadgeCount(_ newBadgeCount: Int) async throws {
        methodLog.append(.setBadgeCount)
        try await realObject.setBadgeCount(newBadgeCount)
    }
}
