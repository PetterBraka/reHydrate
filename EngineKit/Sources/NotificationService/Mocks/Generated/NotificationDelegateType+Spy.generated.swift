// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
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
}
