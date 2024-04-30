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
    public var minimumAllowedFrequency_returnValue: Int {
        get {
            if minimumAllowedFrequency_returnValues.count > 0 {
                let value = minimumAllowedFrequency_returnValues.removeFirst()
                if minimumAllowedFrequency_returnValues.isEmpty {
                    minimumAllowedFrequency_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return minimumAllowedFrequency_returnValues.first ?? .default
            }
        }
        set {
            minimumAllowedFrequency_returnValues.append(newValue)
        }
    }
    private var minimumAllowedFrequency_returnValues: [Int] = []
    public var enableWithFrequencyStartStop_returnValue: Result<Void, NotificationError> {
        get {
            if enableWithFrequencyStartStop_returnValues.count > 0 {
                let value = enableWithFrequencyStartStop_returnValues.removeFirst()
                if enableWithFrequencyStartStop_returnValues.isEmpty {
                    enableWithFrequencyStartStop_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return enableWithFrequencyStartStop_returnValues.first ?? .default
            }
        }
        set {
            enableWithFrequencyStartStop_returnValues.append(newValue)
        }
    }
    private var enableWithFrequencyStartStop_returnValues: [Result<Void, NotificationError>] = []
    public var getSettings_returnValue: NotificationSettings {
        get {
            if getSettings_returnValues.count > 0 {
                let value = getSettings_returnValues.removeFirst()
                if getSettings_returnValues.isEmpty {
                    getSettings_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return getSettings_returnValues.first ?? .default
            }
        }
        set {
            getSettings_returnValues.append(newValue)
        }
    }
    private var getSettings_returnValues: [NotificationSettings] = []

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
