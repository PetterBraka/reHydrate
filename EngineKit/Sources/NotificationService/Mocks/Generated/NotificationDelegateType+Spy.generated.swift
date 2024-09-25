// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import NotificationServiceInterface

public protocol NotificationDelegateTypeSpying {
    var variableLog: [NotificationDelegateTypeSpy.VariableName] { get set }
    var lastVariabelCall: NotificationDelegateTypeSpy.VariableName? { get }
    var methodLog: [NotificationDelegateTypeSpy.MethodCall] { get set }
    var lastMethodCall: NotificationDelegateTypeSpy.MethodCall? { get }
}

public final class NotificationDelegateTypeSpy: NotificationDelegateTypeSpying {
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
    private var realObject: NotificationDelegateType
    public init(realObject: NotificationDelegateType) {
        self.realObject = realObject
    }
}

extension NotificationDelegateTypeSpy: NotificationDelegateType {
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
