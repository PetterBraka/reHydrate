// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import UserNotificationServiceInterface

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

import Foundation
import UserNotificationServiceInterface

public protocol UserNotificationDelegateTypeSpying {
    var variableLog: [UserNotificationDelegateTypeSpy.VariableName] { get set }
    var lastVariabelCall: UserNotificationDelegateTypeSpy.VariableName? { get }
    var methodLog: [UserNotificationDelegateTypeSpy.MethodCall] { get set }
    var lastMethodCall: UserNotificationDelegateTypeSpy.MethodCall? { get }
}

public final class UserNotificationDelegateTypeSpy: UserNotificationDelegateTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case userNotificationCenter(center: UserNotificationCenterType, response: NotificationResponse)
        case userNotificationCenter(center: UserNotificationCenterType, willPresent: DeliveredNotification)
        case userNotificationCenter(center: UserNotificationCenterType, openSettingsFor: DeliveredNotification?)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: UserNotificationDelegateType
    public init(realObject: UserNotificationDelegateType) {
        self.realObject = realObject
    }
}

extension UserNotificationDelegateTypeSpy: UserNotificationDelegateType {
    public func userNotificationCenter(_ center: UserNotificationCenterType, didReceive response: NotificationResponse) async -> Void {
        methodLog.append(.userNotificationCenter(center: center, response: response))
        await realObject.userNotificationCenter(center, didReceive: response)
    }
    public func userNotificationCenter(_ center: UserNotificationCenterType, willPresent: DeliveredNotification) async -> Void {
        methodLog.append(.userNotificationCenter(center: center, willPresent: willPresent))
        await realObject.userNotificationCenter(center, willPresent: willPresent)
    }
    public func userNotificationCenter(_ center: UserNotificationCenterType, openSettingsFor: DeliveredNotification?) -> Void {
        methodLog.append(.userNotificationCenter(center: center, openSettingsFor: openSettingsFor))
        realObject.userNotificationCenter(center, openSettingsFor: openSettingsFor)
    }
}

import Foundation
import UserNotificationServiceInterface

public protocol UserNotificationServiceTypeSpying {
    var variableLog: [UserNotificationServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: UserNotificationServiceTypeSpy.VariableName? { get }
    var methodLog: [UserNotificationServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: UserNotificationServiceTypeSpy.MethodCall? { get }
}

public final class UserNotificationServiceTypeSpy: UserNotificationServiceTypeSpying {
    public enum VariableName {
        case minimumAllowedFrequency
    }

    public enum MethodCall {
        case enable(withFrequency: Int, start: Date, stop: Date)
        case disable
        case celebrate
        case getSettings
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: UserNotificationServiceType
    public init(realObject: UserNotificationServiceType) {
        self.realObject = realObject
    }
}

extension UserNotificationServiceTypeSpy: UserNotificationServiceType {
    public var minimumAllowedFrequency: Int {
        get {
            variableLog.append(.minimumAllowedFrequency)
            return realObject.minimumAllowedFrequency
        }
    }
    public func enable(withFrequency: Int, start: Date, stop: Date) async -> Result<Void, NotificationError> {
        methodLog.append(.enable(withFrequency: withFrequency, start: start, stop: stop))
        return await realObject.enable(withFrequency: withFrequency, start: start, stop: stop)
    }
    public func disable() -> Void {
        methodLog.append(.disable)
        realObject.disable()
    }
    public func celebrate() async -> Void {
        methodLog.append(.celebrate)
        await realObject.celebrate()
    }
    public func getSettings() -> NotificationSettings {
        methodLog.append(.getSettings)
        return realObject.getSettings()
    }
}
// MARK: - AutoString
// swiftlint:disable all



// MARK: - AutoStub
// swiftlint:disable all  
import Foundation
import UserNotificationServiceInterface

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
import Foundation
import UserNotificationServiceInterface

public protocol UserNotificationDelegateTypeStubbing {
}

public final class UserNotificationDelegateTypeStub: UserNotificationDelegateTypeStubbing {

    public init() {}
}

extension UserNotificationDelegateTypeStub: UserNotificationDelegateType {
    public func userNotificationCenter(_ center: UserNotificationCenterType, didReceive response: NotificationResponse) async -> Void {
    }

    public func userNotificationCenter(_ center: UserNotificationCenterType, willPresent: DeliveredNotification) async -> Void {
    }

    public func userNotificationCenter(_ center: UserNotificationCenterType, openSettingsFor: DeliveredNotification?) -> Void {
    }

}
import Foundation
import UserNotificationServiceInterface

public protocol UserNotificationServiceTypeStubbing {
    var minimumAllowedFrequency_returnValue: Int { get set }
    var enableWithFrequencyStartStop_returnValue: Result<Void, NotificationError> { get set }
    var getSettings_returnValue: NotificationSettings { get set }
}

public final class UserNotificationServiceTypeStub: UserNotificationServiceTypeStubbing {
    public var minimumAllowedFrequency_returnValue: Int {
        get {
            if minimumAllowedFrequency_returnValues.isEmpty {
                .default
            } else {
                minimumAllowedFrequency_returnValues.removeFirst()
            }
        }
        set {
            minimumAllowedFrequency_returnValues.append(newValue)
        }
    }
    private var minimumAllowedFrequency_returnValues: [Int] = []
    public var enableWithFrequencyStartStop_returnValue: Result<Void, NotificationError> {
        get {
            if enableWithFrequencyStartStop_returnValues.isEmpty {
                .default
            } else {
                enableWithFrequencyStartStop_returnValues.removeFirst()
            }
        }
        set {
            enableWithFrequencyStartStop_returnValues.append(newValue)
        }
    }
    private var enableWithFrequencyStartStop_returnValues: [Result<Void, NotificationError>] = []
    public var getSettings_returnValue: NotificationSettings {
        get {
            if getSettings_returnValues.isEmpty {
                .default
            } else {
                getSettings_returnValues.removeFirst()
            }
        }
        set {
            getSettings_returnValues.append(newValue)
        }
    }
    private var getSettings_returnValues: [NotificationSettings] = []

    public init() {}
}

extension UserNotificationServiceTypeStub: UserNotificationServiceType {
    public var minimumAllowedFrequency: Int { minimumAllowedFrequency_returnValue }
    public func enable(withFrequency: Int, start: Date, stop: Date) async -> Result<Void, NotificationError> {
        enableWithFrequencyStartStop_returnValue
    }

    public func disable() -> Void {
    }

    public func celebrate() async -> Void {
    }

    public func getSettings() -> NotificationSettings {
        getSettings_returnValue
    }

}
