// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import CommunicationKitInterface

public protocol WatchServiceTypeStubbing {
    var currentState_returnValue: CommunicationState { get set }
    var isReachable_returnValue: Bool { get set }
    var applicationContext_returnValue: [CommunicationUserInfo : Any] { get set }
    var receivedApplicationContext_returnValue: [CommunicationUserInfo : Any] { get set }
    var iOSDeviceNeedsUnlockAfterRebootForReachability_returnValue: Bool { get set }
    var isSupported_returnValue: Bool { get set }
    var updateApplicationContext_returnValue: Error? { get set }
    var sendUserInfoUserInfo_returnValue: CommunicationInfo { get set }
}

public final class WatchServiceTypeStub: WatchServiceTypeStubbing {
    public var currentState_returnValue: CommunicationState {
        get {
            if currentState_returnValues.isEmpty {
                .default
            } else {
                currentState_returnValues.removeFirst()
            }
        }
        set {
            currentState_returnValues.append(newValue)
        }
    }
    private var currentState_returnValues: [CommunicationState] = []
    public var isReachable_returnValue: Bool {
        get {
            if isReachable_returnValues.isEmpty {
                .default
            } else {
                isReachable_returnValues.removeFirst()
            }
        }
        set {
            isReachable_returnValues.append(newValue)
        }
    }
    private var isReachable_returnValues: [Bool] = []
    public var applicationContext_returnValue: [CommunicationUserInfo : Any] {
        get {
            if applicationContext_returnValues.isEmpty {
                .default
            } else {
                applicationContext_returnValues.removeFirst()
            }
        }
        set {
            applicationContext_returnValues.append(newValue)
        }
    }
    private var applicationContext_returnValues: [[CommunicationUserInfo : Any]] = []
    public var receivedApplicationContext_returnValue: [CommunicationUserInfo : Any] {
        get {
            if receivedApplicationContext_returnValues.isEmpty {
                .default
            } else {
                receivedApplicationContext_returnValues.removeFirst()
            }
        }
        set {
            receivedApplicationContext_returnValues.append(newValue)
        }
    }
    private var receivedApplicationContext_returnValues: [[CommunicationUserInfo : Any]] = []
    public var iOSDeviceNeedsUnlockAfterRebootForReachability_returnValue: Bool {
        get {
            if iOSDeviceNeedsUnlockAfterRebootForReachability_returnValues.isEmpty {
                .default
            } else {
                iOSDeviceNeedsUnlockAfterRebootForReachability_returnValues.removeFirst()
            }
        }
        set {
            iOSDeviceNeedsUnlockAfterRebootForReachability_returnValues.append(newValue)
        }
    }
    private var iOSDeviceNeedsUnlockAfterRebootForReachability_returnValues: [Bool] = []
    public var isSupported_returnValue: Bool {
        get {
            if isSupported_returnValues.isEmpty {
                .default
            } else {
                isSupported_returnValues.removeFirst()
            }
        }
        set {
            isSupported_returnValues.append(newValue)
        }
    }
    private var isSupported_returnValues: [Bool] = []
    public var updateApplicationContext_returnValue: Error? {
        get {
            if updateApplicationContext_returnValues.isEmpty {
                nil
            } else {
                updateApplicationContext_returnValues.removeFirst()
            }
        }
        set {
            updateApplicationContext_returnValues.append(newValue)
        }
    }
    private var updateApplicationContext_returnValues: [Error?] = []
    public var sendUserInfoUserInfo_returnValue: CommunicationInfo {
        get {
            if sendUserInfoUserInfo_returnValues.isEmpty {
                .default
            } else {
                sendUserInfoUserInfo_returnValues.removeFirst()
            }
        }
        set {
            sendUserInfoUserInfo_returnValues.append(newValue)
        }
    }
    private var sendUserInfoUserInfo_returnValues: [CommunicationInfo] = []

    public init() {}
}

extension WatchServiceTypeStub: WatchServiceType {
    public var currentState: CommunicationState { currentState_returnValue }
    public var isReachable: Bool { isReachable_returnValue }
    public var applicationContext: [CommunicationUserInfo : Any] { applicationContext_returnValue }
    public var receivedApplicationContext: [CommunicationUserInfo : Any] { receivedApplicationContext_returnValue }
    public var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool { iOSDeviceNeedsUnlockAfterRebootForReachability_returnValue }
    public func isSupported() -> Bool {
        isSupported_returnValue
    }

    public func activate() -> Void {
    }

    public func update(applicationContext: [CommunicationUserInfo : Codable]) throws -> Void {
        if let updateApplicationContext_returnValue {
            throw updateApplicationContext_returnValue
        }
    }

    public func sendMessage(_ message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?) -> Void {
    }

    public func sendData(_ data: Data, errorHandler: ((Error) -> Void)?) -> Void {
    }

    public func sendUserInfo(_ userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        sendUserInfoUserInfo_returnValue
    }

}
