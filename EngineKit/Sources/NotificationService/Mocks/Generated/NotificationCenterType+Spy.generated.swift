// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import NotificationServiceInterface

public protocol NotificationCenterTypeSpying {
    var variableLog: [NotificationCenterTypeSpy.VariableName] { get set }
    var methodLog: [NotificationCenterTypeSpy.MethodName] { get set }
}

public final class NotificationCenterTypeSpy: NotificationCenterTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
            case requestAuthorization
            case setNotificationCategories
            case notificationCategories
            case add
            case pendingNotificationRequests
            case removePendingNotificationRequests_withIdentifiers
            case removeAllPendingNotificationRequests
            case deliveredNotifications
            case removeDeliveredNotifications_withIdentifiers
            case removeAllDeliveredNotifications
            case setBadgeCount
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: NotificationCenterType
    public init(realObject: NotificationCenterType) {
        self.realObject = realObject
    }
}

extension NotificationCenterTypeSpy: NotificationCenterType {
    public func requestAuthorization() async throws -> Bool {
        methodLog.append(.requestAuthorization)
        return try await realObject.requestAuthorization()
    }
    public func setNotificationCategories(_ categories: Set<NotificationCategory>) -> Void {
        methodLog.append(.setNotificationCategories)
        realObject.setNotificationCategories(categories)
    }
    public func notificationCategories() async -> Set<NotificationCategory> {
        methodLog.append(.notificationCategories)
        return await realObject.notificationCategories()
    }
    public func add(_ request: NotificationRequest) async throws -> Void {
        methodLog.append(.add)
        try await realObject.add(request)
    }
    public func pendingNotificationRequests() async -> [NotificationRequest] {
        methodLog.append(.pendingNotificationRequests)
        return await realObject.pendingNotificationRequests()
    }
    public func removePendingNotificationRequests(withIdentifiers identifiers: [String]) -> Void {
        methodLog.append(.removePendingNotificationRequests_withIdentifiers)
        realObject.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    public func removeAllPendingNotificationRequests() -> Void {
        methodLog.append(.removeAllPendingNotificationRequests)
        realObject.removeAllPendingNotificationRequests()
    }
    public func deliveredNotifications() async -> [DeliveredNotification] {
        methodLog.append(.deliveredNotifications)
        return await realObject.deliveredNotifications()
    }
    public func removeDeliveredNotifications(withIdentifiers identifiers: [String]) -> Void {
        methodLog.append(.removeDeliveredNotifications_withIdentifiers)
        realObject.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    public func removeAllDeliveredNotifications() -> Void {
        methodLog.append(.removeAllDeliveredNotifications)
        realObject.removeAllDeliveredNotifications()
    }
    public func setBadgeCount(_ newBadgeCount: Int) async throws -> Void {
        methodLog.append(.setBadgeCount)
        try await realObject.setBadgeCount(newBadgeCount)
    }
}
