// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

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
