// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
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
