// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoEquatable
// swiftlint:disable all

extension DeliveredNotification: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.date == rhs.date && 
        lhs.request == rhs.request
    }
}

extension NotificationContent: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title && 
        lhs.subtitle == rhs.subtitle && 
        lhs.body == rhs.body && 
        lhs.userInfo.description == rhs.userInfo.description && 
        lhs.categoryIdentifier == rhs.categoryIdentifier
    }
}

extension NotificationRequest: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier && 
        lhs.content == rhs.content && 
        lhs.trigger == rhs.trigger
    }
}

extension NotificationResponse: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.actionIdentifier == rhs.actionIdentifier
    }
}

extension NotificationSettings: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isOn == rhs.isOn && 
        lhs.start == rhs.start && 
        lhs.stop == rhs.stop && 
        lhs.frequency == rhs.frequency
    }
}

extension NotificationTrigger: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.repeats == rhs.repeats && 
        lhs.dateComponents == rhs.dateComponents
    }
}
// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import UserNotificationServiceInterface

public protocol UserNotificationCenterTypeSpying {
    var variableLog: [UserNotificationCenterTypeSpy.VariableName] { get set }
    var lastVariabelCall: UserNotificationCenterTypeSpy.VariableName? { get }
    var methodLog: [UserNotificationCenterTypeSpy.MethodCall] { get set }
    var lastMethodCall: UserNotificationCenterTypeSpy.MethodCall? { get }
    var methodNameLog: [UserNotificationCenterTypeSpy.MethodName] { get set }
}

public final class UserNotificationCenterTypeSpy: UserNotificationCenterTypeSpying {
    public enum VariableName: Equatable {
    }

    public enum MethodCall {
        case requestAuthorization
        case setNotificationCategoriesCategories(categories: Set<NotificationCategory>)
        case notificationCategories
        case addRequest(request: NotificationRequest)
        case pendingNotificationRequests
        case removePendingNotificationRequestsIdentifiers(identifiers: [String])
        case removeAllPendingNotificationRequests
        case deliveredNotifications
        case removeDeliveredNotificationsIdentifiers(identifiers: [String])
        case removeAllDeliveredNotifications
        case setBadgeCountNewBadgeCount(newBadgeCount: Int)
    }

    public enum MethodName {
        case requestAuthorization
        case setNotificationCategoriesCategories
        case notificationCategories
        case addRequest
        case pendingNotificationRequests
        case removePendingNotificationRequestsIdentifiers
        case removeAllPendingNotificationRequests
        case deliveredNotifications
        case removeDeliveredNotificationsIdentifiers
        case removeAllDeliveredNotifications
        case setBadgeCountNewBadgeCount
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: UserNotificationCenterType
    public init(realObject: UserNotificationCenterType) {
        self.realObject = realObject
    }
}

extension UserNotificationCenterTypeSpy: UserNotificationCenterType {
    public func requestAuthorization() async throws -> Bool {
        methodNameLog.append(.requestAuthorization)
        methodLog.append(.requestAuthorization)
        return try await realObject.requestAuthorization()
    }
    public func setNotificationCategories(_ categories: Set<NotificationCategory>) -> Void {
        methodNameLog.append(.setNotificationCategoriesCategories)
        methodLog.append(.setNotificationCategoriesCategories(categories: categories))
        realObject.setNotificationCategories(categories)
    }
    public func notificationCategories() async -> Set<NotificationCategory> {
        methodNameLog.append(.notificationCategories)
        methodLog.append(.notificationCategories)
        return await realObject.notificationCategories()
    }
    public func add(_ request: NotificationRequest) async throws -> Void {
        methodNameLog.append(.addRequest)
        methodLog.append(.addRequest(request: request))
        try await realObject.add(request)
    }
    public func pendingNotificationRequests() async -> [NotificationRequest] {
        methodNameLog.append(.pendingNotificationRequests)
        methodLog.append(.pendingNotificationRequests)
        return await realObject.pendingNotificationRequests()
    }
    public func removePendingNotificationRequests(withIdentifiers identifiers: [String]) -> Void {
        methodNameLog.append(.removePendingNotificationRequestsIdentifiers)
        methodLog.append(.removePendingNotificationRequestsIdentifiers(identifiers: identifiers))
        realObject.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    public func removeAllPendingNotificationRequests() -> Void {
        methodNameLog.append(.removeAllPendingNotificationRequests)
        methodLog.append(.removeAllPendingNotificationRequests)
        realObject.removeAllPendingNotificationRequests()
    }
    public func deliveredNotifications() async -> [DeliveredNotification] {
        methodNameLog.append(.deliveredNotifications)
        methodLog.append(.deliveredNotifications)
        return await realObject.deliveredNotifications()
    }
    public func removeDeliveredNotifications(withIdentifiers identifiers: [String]) -> Void {
        methodNameLog.append(.removeDeliveredNotificationsIdentifiers)
        methodLog.append(.removeDeliveredNotificationsIdentifiers(identifiers: identifiers))
        realObject.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    public func removeAllDeliveredNotifications() -> Void {
        methodNameLog.append(.removeAllDeliveredNotifications)
        methodLog.append(.removeAllDeliveredNotifications)
        realObject.removeAllDeliveredNotifications()
    }
    public func setBadgeCount(_ newBadgeCount: Int) async throws -> Void {
        methodNameLog.append(.setBadgeCountNewBadgeCount)
        methodLog.append(.setBadgeCountNewBadgeCount(newBadgeCount: newBadgeCount))
        try await realObject.setBadgeCount(newBadgeCount)
    }
}

extension UserNotificationCenterTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension UserNotificationCenterTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .requestAuthorization: "requestAuthorization"
        case .setNotificationCategoriesCategories(let categories): "setNotificationCategories(categories: \(String(describing: categories)))"
        case .notificationCategories: "notificationCategories"
        case .addRequest(let request): "add(request: \(String(describing: request)))"
        case .pendingNotificationRequests: "pendingNotificationRequests"
        case .removePendingNotificationRequestsIdentifiers(let identifiers): "removePendingNotificationRequests(identifiers: \(String(describing: identifiers)))"
        case .removeAllPendingNotificationRequests: "removeAllPendingNotificationRequests"
        case .deliveredNotifications: "deliveredNotifications"
        case .removeDeliveredNotificationsIdentifiers(let identifiers): "removeDeliveredNotifications(identifiers: \(String(describing: identifiers)))"
        case .removeAllDeliveredNotifications: "removeAllDeliveredNotifications"
        case .setBadgeCountNewBadgeCount(let newBadgeCount): "setBadgeCount(newBadgeCount: \(String(describing: newBadgeCount)))"
        }
    }
}

extension UserNotificationCenterTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .requestAuthorization: "requestAuthorization"
        case .setNotificationCategoriesCategories: "setNotificationCategoriesCategories"
        case .notificationCategories: "notificationCategories"
        case .addRequest: "addRequest"
        case .pendingNotificationRequests: "pendingNotificationRequests"
        case .removePendingNotificationRequestsIdentifiers: "removePendingNotificationRequestsIdentifiers"
        case .removeAllPendingNotificationRequests: "removeAllPendingNotificationRequests"
        case .deliveredNotifications: "deliveredNotifications"
        case .removeDeliveredNotificationsIdentifiers: "removeDeliveredNotificationsIdentifiers"
        case .removeAllDeliveredNotifications: "removeAllDeliveredNotifications"
        case .setBadgeCountNewBadgeCount: "setBadgeCountNewBadgeCount"
        }
    }
}

extension UserNotificationCenterTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.requestAuthorization, .requestAuthorization): true
        case (.setNotificationCategoriesCategories(let lhs_categories), .setNotificationCategoriesCategories(let rhs_categories)): lhs_categories == rhs_categories
        case (.notificationCategories, .notificationCategories): true
        case (.addRequest(let lhs_request), .addRequest(let rhs_request)): lhs_request == rhs_request
        case (.pendingNotificationRequests, .pendingNotificationRequests): true
        case (.removePendingNotificationRequestsIdentifiers(let lhs_identifiers), .removePendingNotificationRequestsIdentifiers(let rhs_identifiers)): lhs_identifiers == rhs_identifiers
        case (.removeAllPendingNotificationRequests, .removeAllPendingNotificationRequests): true
        case (.deliveredNotifications, .deliveredNotifications): true
        case (.removeDeliveredNotificationsIdentifiers(let lhs_identifiers), .removeDeliveredNotificationsIdentifiers(let rhs_identifiers)): lhs_identifiers == rhs_identifiers
        case (.removeAllDeliveredNotifications, .removeAllDeliveredNotifications): true
        case (.setBadgeCountNewBadgeCount(let lhs_newBadgeCount), .setBadgeCountNewBadgeCount(let rhs_newBadgeCount)): lhs_newBadgeCount == rhs_newBadgeCount
        default: false
        }
    }
}

import Foundation
import UserNotificationServiceInterface

public protocol UserNotificationDelegateTypeSpying {
    var variableLog: [UserNotificationDelegateTypeSpy.VariableName] { get set }
    var lastVariabelCall: UserNotificationDelegateTypeSpy.VariableName? { get }
    var methodLog: [UserNotificationDelegateTypeSpy.MethodCall] { get set }
    var lastMethodCall: UserNotificationDelegateTypeSpy.MethodCall? { get }
    var methodNameLog: [UserNotificationDelegateTypeSpy.MethodName] { get set }
}

public final class UserNotificationDelegateTypeSpy: UserNotificationDelegateTypeSpying {
    public enum VariableName: Equatable {
    }

    public enum MethodCall {
        case userNotificationCenterCenterResponse(center: UserNotificationCenterType, response: NotificationResponse)
        case userNotificationCenterCenterWillPresent(center: UserNotificationCenterType, willPresent: DeliveredNotification)
        case userNotificationCenterCenterOpenSettingsFor(center: UserNotificationCenterType, openSettingsFor: DeliveredNotification?)
    }

    public enum MethodName {
        case userNotificationCenterCenterResponse
        case userNotificationCenterCenterWillPresent
        case userNotificationCenterCenterOpenSettingsFor
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: UserNotificationDelegateType
    public init(realObject: UserNotificationDelegateType) {
        self.realObject = realObject
    }
}

extension UserNotificationDelegateTypeSpy: UserNotificationDelegateType {
    public func userNotificationCenter(_ center: UserNotificationCenterType, didReceive response: NotificationResponse) async -> Void {
        methodNameLog.append(.userNotificationCenterCenterResponse)
        methodLog.append(.userNotificationCenterCenterResponse(center: center, response: response))
        await realObject.userNotificationCenter(center, didReceive: response)
    }
    public func userNotificationCenter(_ center: UserNotificationCenterType, willPresent: DeliveredNotification) async -> Void {
        methodNameLog.append(.userNotificationCenterCenterWillPresent)
        methodLog.append(.userNotificationCenterCenterWillPresent(center: center, willPresent: willPresent))
        await realObject.userNotificationCenter(center, willPresent: willPresent)
    }
    public func userNotificationCenter(_ center: UserNotificationCenterType, openSettingsFor: DeliveredNotification?) -> Void {
        methodNameLog.append(.userNotificationCenterCenterOpenSettingsFor)
        methodLog.append(.userNotificationCenterCenterOpenSettingsFor(center: center, openSettingsFor: openSettingsFor))
        realObject.userNotificationCenter(center, openSettingsFor: openSettingsFor)
    }
}

extension UserNotificationDelegateTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension UserNotificationDelegateTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .userNotificationCenterCenterResponse(let center, let response): "userNotificationCenter(center: \(String(describing: center)), response: \(String(describing: response)))"
        case .userNotificationCenterCenterWillPresent(let center, let willPresent): "userNotificationCenter(center: \(String(describing: center)), willPresent: \(String(describing: willPresent)))"
        case .userNotificationCenterCenterOpenSettingsFor(let center, let openSettingsFor): "userNotificationCenter(center: \(String(describing: center)), openSettingsFor: \(String(describing: openSettingsFor)))"
        }
    }
}

extension UserNotificationDelegateTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .userNotificationCenterCenterResponse: "userNotificationCenterCenterResponse"
        case .userNotificationCenterCenterWillPresent: "userNotificationCenterCenterWillPresent"
        case .userNotificationCenterCenterOpenSettingsFor: "userNotificationCenterCenterOpenSettingsFor"
        }
    }
}

extension UserNotificationDelegateTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.userNotificationCenterCenterResponse(let lhs_center, let lhs_response), .userNotificationCenterCenterResponse(let rhs_center, let rhs_response)): String(describing: lhs_center) == String(describing: rhs_center) && lhs_response == rhs_response
        case (.userNotificationCenterCenterWillPresent(let lhs_center, let lhs_willPresent), .userNotificationCenterCenterWillPresent(let rhs_center, let rhs_willPresent)): String(describing: lhs_center) == String(describing: rhs_center) && lhs_willPresent == rhs_willPresent
        case (.userNotificationCenterCenterOpenSettingsFor(let lhs_center, let lhs_openSettingsFor), .userNotificationCenterCenterOpenSettingsFor(let rhs_center, let rhs_openSettingsFor)): String(describing: lhs_center) == String(describing: rhs_center) && lhs_openSettingsFor == rhs_openSettingsFor
        default: false
        }
    }
}

import Foundation
import UserNotificationServiceInterface

public protocol UserNotificationServiceTypeSpying {
    var variableLog: [UserNotificationServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: UserNotificationServiceTypeSpy.VariableName? { get }
    var methodLog: [UserNotificationServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: UserNotificationServiceTypeSpy.MethodCall? { get }
    var methodNameLog: [UserNotificationServiceTypeSpy.MethodName] { get set }
}

public final class UserNotificationServiceTypeSpy: UserNotificationServiceTypeSpying {
    public enum VariableName: Equatable {
        case minimumAllowedFrequency
    }

    public enum MethodCall {
        case enableWithFrequencyStartStop(withFrequency: Int, start: Date, stop: Date)
        case disable
        case celebrate
        case getSettings
    }

    public enum MethodName {
        case enableWithFrequencyStartStop
        case disable
        case celebrate
        case getSettings
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
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
        methodNameLog.append(.enableWithFrequencyStartStop)
        methodLog.append(.enableWithFrequencyStartStop(withFrequency: withFrequency, start: start, stop: stop))
        return await realObject.enable(withFrequency: withFrequency, start: start, stop: stop)
    }
    public func disable() -> Void {
        methodNameLog.append(.disable)
        methodLog.append(.disable)
        realObject.disable()
    }
    public func celebrate() async -> Void {
        methodNameLog.append(.celebrate)
        methodLog.append(.celebrate)
        await realObject.celebrate()
    }
    public func getSettings() -> NotificationSettings {
        methodNameLog.append(.getSettings)
        methodLog.append(.getSettings)
        return realObject.getSettings()
    }
}

extension UserNotificationServiceTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .minimumAllowedFrequency: "minimumAllowedFrequency"
        }
    }
}

extension UserNotificationServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .enableWithFrequencyStartStop(let withFrequency, let start, let stop): "enable(withFrequency: \(String(describing: withFrequency)), start: \(String(describing: start)), stop: \(String(describing: stop)))"
        case .disable: "disable"
        case .celebrate: "celebrate"
        case .getSettings: "getSettings"
        }
    }
}

extension UserNotificationServiceTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .enableWithFrequencyStartStop: "enableWithFrequencyStartStop"
        case .disable: "disable"
        case .celebrate: "celebrate"
        case .getSettings: "getSettings"
        }
    }
}

extension UserNotificationServiceTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.enableWithFrequencyStartStop(let lhs_withFrequency, let lhs_start, let lhs_stop), .enableWithFrequencyStartStop(let rhs_withFrequency, let rhs_start, let rhs_stop)): lhs_withFrequency == rhs_withFrequency && lhs_start == rhs_start && lhs_stop == rhs_stop
        case (.disable, .disable): true
        case (.celebrate, .celebrate): true
        case (.getSettings, .getSettings): true
        default: false
        }
    }
}
// MARK: - AutoString
// swiftlint:disable all

import UserNotificationServiceInterface

extension NotificationSettings: CustomStringConvertible {
    public var description: String {
        "NotificationSettings(isOn: \(String(describing: isOn)) start: \(String(describing: start)) stop: \(String(describing: stop)) frequency: \(String(describing: frequency)) )"
    }
}

extension NotificationError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unauthorized: "unauthorized"
        case .invalidDate: "invalidDate"
        case .missingDateComponents: "missingDateComponents"
        case .missingReminders: "missingReminders"
        case .missingCongratulations: "missingCongratulations"
        case .frequencyTooLow: "frequencyTooLow"
        case .alreadySet(let at): "alreadySet(at:\(String(describing: at)))"
        }
    }
}


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
