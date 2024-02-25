// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import NotificationServiceInterface

public protocol NotificationCenterTypeStubbing {
    var requestAuthorization_returnValue: Result<Bool, Error> { get set }
    var notificationCategories_returnValue: Set<NotificationCategory> { get set }
    var addRequest_returnValue: Error? { get set }
    var pendingNotificationRequests_returnValue: [NotificationRequest] { get set }
    var deliveredNotifications_returnValue: [DeliveredNotification] { get set }
    var setBadgeCountNewBadgeCount_returnValue: Error? { get set }
}

public final class NotificationCenterTypeStub: NotificationCenterTypeStubbing {
    public var requestAuthorization_returnValue: Result<Bool, Error> = .default
    public var notificationCategories_returnValue: Set<NotificationCategory> = .default
    public var addRequest_returnValue: Error? = nil
    public var pendingNotificationRequests_returnValue: [NotificationRequest] = .default
    public var deliveredNotifications_returnValue: [DeliveredNotification] = .default
    public var setBadgeCountNewBadgeCount_returnValue: Error? = nil

    public init() {}
}

extension NotificationCenterTypeStub: NotificationCenterType {
    public func requestAuthorization() async throws -> Bool {
        switch requestAuthorization_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func setNotificationCategories(_ categories: Set<NotificationCategory>) -> Void {
    }

    public func notificationCategories() async -> Set<NotificationCategory> {
        notificationCategories_returnValue
    }

    public func add(_ request: NotificationRequest) async throws -> Void {
        if let addRequest_returnValue {
            throw addRequest_returnValue
        }
    }

    public func pendingNotificationRequests() async -> [NotificationRequest] {
        pendingNotificationRequests_returnValue
    }

    public func removePendingNotificationRequests(withIdentifiers identifiers: [String]) -> Void {
    }

    public func removeAllPendingNotificationRequests() -> Void {
    }

    public func deliveredNotifications() async -> [DeliveredNotification] {
        deliveredNotifications_returnValue
    }

    public func removeDeliveredNotifications(withIdentifiers identifiers: [String]) -> Void {
    }

    public func removeAllDeliveredNotifications() -> Void {
    }

    public func setBadgeCount(_ newBadgeCount: Int) async throws -> Void {
        if let setBadgeCountNewBadgeCount_returnValue {
            throw setBadgeCountNewBadgeCount_returnValue
        }
    }

}
