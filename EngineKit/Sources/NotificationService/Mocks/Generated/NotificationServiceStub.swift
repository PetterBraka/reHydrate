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
    public func requestAuthorization() throws -> Bool {
        switch requestAuthorization_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func setNotificationCategories(_ categories: Set<NotificationCategory>) -> Void {
    }

    public func notificationCategories() -> Set<NotificationCategory> {
        notificationCategories_returnValue
    }

    public func add(_ request: NotificationRequest) throws -> Void {
        if let addRequest_returnValue {
            throw addRequest_returnValue
        }
    }

    public func pendingNotificationRequests() -> [NotificationRequest] {
        pendingNotificationRequests_returnValue
    }

    public func removePendingNotificationRequests(withIdentifiers identifiers: [String]) -> Void {
    }

    public func removeAllPendingNotificationRequests() -> Void {
    }

    public func deliveredNotifications() -> [DeliveredNotification] {
        deliveredNotifications_returnValue
    }

    public func removeDeliveredNotifications(withIdentifiers identifiers: [String]) -> Void {
    }

    public func removeAllDeliveredNotifications() -> Void {
    }

    public func setBadgeCount(_ newBadgeCount: Int) throws -> Void {
        if let setBadgeCountNewBadgeCount_returnValue {
            throw setBadgeCountNewBadgeCount_returnValue
        }
    }

}

import Foundation
import NotificationServiceInterface

public protocol NotificationDelegateTypeStubbing {
}

public final class NotificationDelegateTypeStub: NotificationDelegateTypeStubbing {

    public init() {}
}

extension NotificationDelegateTypeStub: NotificationDelegateType {
    public func userNotificationCenter(_ center: NotificationCenterType, didReceive response: NotificationResponse) -> Void {
    }

    public func userNotificationCenter(_ center: NotificationCenterType, willPresent: DeliveredNotification) -> Void {
    }

    public func userNotificationCenter(_ center: NotificationCenterType, openSettingsFor: DeliveredNotification?) -> Void {
    }

}

import Foundation
import NotificationServiceInterface

public protocol NotificationServiceTypeStubbing {
    var minimumAllowedFrequency_returnValue: Int { get set }
    var enableWithFrequencyStartStop_returnValue: Result<Void, NotificationError> { get set }
    var getSettings_returnValue: NotificationSettings { get set }
}

public final class NotificationServiceTypeStub: NotificationServiceTypeStubbing {
    public var minimumAllowedFrequency_returnValue: Int = .default
    public var enableWithFrequencyStartStop_returnValue: Result<Void, NotificationError> = .default
    public var getSettings_returnValue: NotificationSettings = .default

    public init() {}
}

extension NotificationServiceTypeStub: NotificationServiceType {
    public var minimumAllowedFrequency: Int { minimumAllowedFrequency_returnValue }
    public func enable(withFrequency: Int, start: Date, stop: Date) -> Result<Void, NotificationError> {
        enableWithFrequencyStartStop_returnValue
    }

    public func disable() -> Void {
    }

    public func getSettings() -> NotificationSettings {
        getSettings_returnValue
    }

}

