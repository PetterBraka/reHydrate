// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
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

    public func getSettings() -> NotificationSettings {
        getSettings_returnValue
    }

}
