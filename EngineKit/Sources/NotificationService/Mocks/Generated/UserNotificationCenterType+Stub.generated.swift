// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import NotificationServiceInterface

public protocol UserNotificationCenterTypeStubbing {
    var requestAuthorization_returnValue: Result<Bool, Error> { get set }
    var notificationCategories_returnValue: Set<NotificationCategory> { get set }
    var addRequest_returnValue: Error? { get set }
    var pendingNotificationRequests_returnValue: [NotificationRequest] { get set }
    var deliveredNotifications_returnValue: [DeliveredNotification] { get set }
    var setBadgeCountNewBadgeCount_returnValue: Error? { get set }
}

public final class UserNotificationCenterTypeStub: UserNotificationCenterTypeStubbing {
    public var requestAuthorization_returnValue: Result<Bool, Error> {
        get {
            if requestAuthorization_returnValues.isEmpty {
                .default
            } else {
                requestAuthorization_returnValues.removeFirst()
            }
        }
        set {
            requestAuthorization_returnValues.append(newValue)
        }
    }
    private var requestAuthorization_returnValues: [Result<Bool, Error>] = []
    public var notificationCategories_returnValue: Set<NotificationCategory> {
        get {
            if notificationCategories_returnValues.isEmpty {
                .default
            } else {
                notificationCategories_returnValues.removeFirst()
            }
        }
        set {
            notificationCategories_returnValues.append(newValue)
        }
    }
    private var notificationCategories_returnValues: [Set<NotificationCategory>] = []
    public var addRequest_returnValue: Error? {
        get {
            if addRequest_returnValues.isEmpty {
                nil
            } else {
                addRequest_returnValues.removeFirst()
            }
        }
        set {
            addRequest_returnValues.append(newValue)
        }
    }
    private var addRequest_returnValues: [Error?] = []
    public var pendingNotificationRequests_returnValue: [NotificationRequest] {
        get {
            if pendingNotificationRequests_returnValues.isEmpty {
                .default
            } else {
                pendingNotificationRequests_returnValues.removeFirst()
            }
        }
        set {
            pendingNotificationRequests_returnValues.append(newValue)
        }
    }
    private var pendingNotificationRequests_returnValues: [[NotificationRequest]] = []
    public var deliveredNotifications_returnValue: [DeliveredNotification] {
        get {
            if deliveredNotifications_returnValues.isEmpty {
                .default
            } else {
                deliveredNotifications_returnValues.removeFirst()
            }
        }
        set {
            deliveredNotifications_returnValues.append(newValue)
        }
    }
    private var deliveredNotifications_returnValues: [[DeliveredNotification]] = []
    public var setBadgeCountNewBadgeCount_returnValue: Error? {
        get {
            if setBadgeCountNewBadgeCount_returnValues.isEmpty {
                nil
            } else {
                setBadgeCountNewBadgeCount_returnValues.removeFirst()
            }
        }
        set {
            setBadgeCountNewBadgeCount_returnValues.append(newValue)
        }
    }
    private var setBadgeCountNewBadgeCount_returnValues: [Error?] = []

    public init() {}
}

extension UserNotificationCenterTypeStub: UserNotificationCenterType {
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
