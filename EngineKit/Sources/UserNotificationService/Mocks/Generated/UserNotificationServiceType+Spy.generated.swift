// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

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
    public func getSettings() -> NotificationSettings {
        methodLog.append(.getSettings)
        return realObject.getSettings()
    }
}
