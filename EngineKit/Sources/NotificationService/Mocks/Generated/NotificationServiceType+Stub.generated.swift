// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
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
