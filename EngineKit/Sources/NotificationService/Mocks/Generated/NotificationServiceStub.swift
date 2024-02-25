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
}// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import NotificationServiceInterface

public protocol NotificationDelegateTypeSpying {
    var variableLog: [NotificationDelegateTypeSpy.VariableName] { get set }
    var methodLog: [NotificationDelegateTypeSpy.MethodName] { get set }
}

public final class NotificationDelegateTypeSpy: NotificationDelegateTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
            case userNotificationCenter_didReceive
            case userNotificationCenter_willPresent
            case userNotificationCenter_openSettingsFor
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: NotificationDelegateType
    public init(realObject: NotificationDelegateType) {
        self.realObject = realObject
    }
}

extension NotificationDelegateTypeSpy: NotificationDelegateType {
    public func userNotificationCenter(_ center: NotificationCenterType, didReceive response: NotificationResponse) async -> Void {
        methodLog.append(.userNotificationCenter_didReceive)
        await realObject.userNotificationCenter(center, didReceive: response)
    }
    public func userNotificationCenter(_ center: NotificationCenterType, willPresent: DeliveredNotification) async -> Void {
        methodLog.append(.userNotificationCenter_willPresent)
        await realObject.userNotificationCenter(center, willPresent: willPresent)
    }
    public func userNotificationCenter(_ center: NotificationCenterType, openSettingsFor: DeliveredNotification?) -> Void {
        methodLog.append(.userNotificationCenter_openSettingsFor)
        realObject.userNotificationCenter(center, openSettingsFor: openSettingsFor)
    }
}// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import NotificationServiceInterface

public protocol NotificationServiceTypeSpying {
    var variableLog: [NotificationServiceTypeSpy.VariableName] { get set }
    var methodLog: [NotificationServiceTypeSpy.MethodName] { get set }
}

public final class NotificationServiceTypeSpy: NotificationServiceTypeSpying {
    public enum VariableName {
            case minimumAllowedFrequency
    }

    public enum MethodName {
            case enable_withFrequency_start_stop
            case disable
            case getSettings
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: NotificationServiceType
    public init(realObject: NotificationServiceType) {
        self.realObject = realObject
    }
}

extension NotificationServiceTypeSpy: NotificationServiceType {
    public var minimumAllowedFrequency: Int {
        get {
            variableLog.append(.minimumAllowedFrequency)
            return realObject.minimumAllowedFrequency
        }
    }
    public func enable(withFrequency: Int, start: Date, stop: Date) async -> Result<Void, NotificationError> {
        methodLog.append(.enable_withFrequency_start_stop)
        return await realObject.enable(withFrequency: withFrequency, start: start, stop: stop)
    }
    public func disable() -> Void {
        methodLog.append(.disable)
        realObject.disable()
    }
    public func getSettings() -> NotificationSettings {
        methodLog.append(.getSettings)
        return realObject.getSettings()
    }
}
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

import Foundation
import NotificationServiceInterface

public protocol NotificationDelegateTypeStubbing {
}

public final class NotificationDelegateTypeStub: NotificationDelegateTypeStubbing {

    public init() {}
}

extension NotificationDelegateTypeStub: NotificationDelegateType {
    public func userNotificationCenter(_ center: NotificationCenterType, didReceive response: NotificationResponse) async -> Void {
    }

    public func userNotificationCenter(_ center: NotificationCenterType, willPresent: DeliveredNotification) async -> Void {
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
    public func enable(withFrequency: Int, start: Date, stop: Date) async -> Result<Void, NotificationError> {
        enableWithFrequencyStartStop_returnValue
    }

    public func disable() -> Void {
    }

    public func getSettings() -> NotificationSettings {
        getSettings_returnValue
    }

}

