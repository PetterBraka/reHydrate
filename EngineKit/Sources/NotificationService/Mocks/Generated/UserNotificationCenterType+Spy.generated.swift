// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import NotificationServiceInterface

public protocol UserNotificationCenterTypeSpying {
    var variableLog: [UserNotificationCenterTypeSpy.VariableName] { get set }
    var lastVariabelCall: UserNotificationCenterTypeSpy.VariableName? { get }
    var methodLog: [UserNotificationCenterTypeSpy.MethodCall] { get set }
    var lastMethodCall: UserNotificationCenterTypeSpy.MethodCall? { get }
}

public final class UserNotificationCenterTypeSpy: UserNotificationCenterTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case requestAuthorization
        case setNotificationCategories(categories: Set<NotificationCategory>)
        case notificationCategories
        case add(request: NotificationRequest)
        case pendingNotificationRequests
        case removePendingNotificationRequests(identifiers: [String])
        case removeAllPendingNotificationRequests
        case deliveredNotifications
        case removeDeliveredNotifications(identifiers: [String])
        case removeAllDeliveredNotifications
        case setBadgeCount(newBadgeCount: Int)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: UserNotificationCenterType
    public init(realObject: UserNotificationCenterType) {
        self.realObject = realObject
    }
}

extension UserNotificationCenterTypeSpy: UserNotificationCenterType {
    public func requestAuthorization() async throws -> Bool {
        methodLog.append(.requestAuthorization)
        return try await realObject.requestAuthorization()
    }
    public func setNotificationCategories(_ categories: Set<NotificationCategory>) -> Void {
        methodLog.append(.setNotificationCategories(categories: categories))
        realObject.setNotificationCategories(categories)
    }
    public func notificationCategories() async -> Set<NotificationCategory> {
        methodLog.append(.notificationCategories)
        return await realObject.notificationCategories()
    }
    public func add(_ request: NotificationRequest) async throws -> Void {
        methodLog.append(.add(request: request))
        try await realObject.add(request)
    }
    public func pendingNotificationRequests() async -> [NotificationRequest] {
        methodLog.append(.pendingNotificationRequests)
        return await realObject.pendingNotificationRequests()
    }
    public func removePendingNotificationRequests(withIdentifiers identifiers: [String]) -> Void {
        methodLog.append(.removePendingNotificationRequests(identifiers: identifiers))
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
        methodLog.append(.removeDeliveredNotifications(identifiers: identifiers))
        realObject.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    public func removeAllDeliveredNotifications() -> Void {
        methodLog.append(.removeAllDeliveredNotifications)
        realObject.removeAllDeliveredNotifications()
    }
    public func setBadgeCount(_ newBadgeCount: Int) async throws -> Void {
        methodLog.append(.setBadgeCount(newBadgeCount: newBadgeCount))
        try await realObject.setBadgeCount(newBadgeCount)
    }
}
