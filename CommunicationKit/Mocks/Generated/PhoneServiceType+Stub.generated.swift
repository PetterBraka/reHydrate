// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import CommunicationKitInterface

public protocol PhoneServiceTypeStubbing {
    var currentState_returnValue: CommunicationState { get set }
    var isReachable_returnValue: Bool { get set }
    var applicationContext_returnValue: [CommunicationUserInfo : Any] { get set }
    var receivedApplicationContext_returnValue: [CommunicationUserInfo : Any] { get set }
    var remainingComplicationUserInfoTransfers_returnValue: Int { get set }
    var isPaired_returnValue: Bool { get set }
    var watchDirectoryUrl_returnValue: URL? { get set }
    var isWatchAppInstalled_returnValue: Bool { get set }
    var isComplicationEnabled_returnValue: Bool { get set }
    var isSupported_returnValue: Bool { get set }
    var updateApplicationContext_returnValue: Error? { get set }
    var transferComplicationUserInfo_returnValue: CommunicationInfo { get set }
    var transferUserInfo_returnValue: CommunicationInfo { get set }
}

public final class PhoneServiceTypeStub: PhoneServiceTypeStubbing {
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
    public var remainingComplicationUserInfoTransfers_returnValue: Int {
        get {
            if remainingComplicationUserInfoTransfers_returnValues.isEmpty {
                .default
            } else {
                remainingComplicationUserInfoTransfers_returnValues.removeFirst()
            }
        }
        set {
            remainingComplicationUserInfoTransfers_returnValues.append(newValue)
        }
    }
    private var remainingComplicationUserInfoTransfers_returnValues: [Int] = []
    public var isPaired_returnValue: Bool {
        get {
            if isPaired_returnValues.isEmpty {
                .default
            } else {
                isPaired_returnValues.removeFirst()
            }
        }
        set {
            isPaired_returnValues.append(newValue)
        }
    }
    private var isPaired_returnValues: [Bool] = []
    public var watchDirectoryUrl_returnValue: URL? {
        get {
            if watchDirectoryUrl_returnValues.isEmpty {
                .default
            } else {
                watchDirectoryUrl_returnValues.removeFirst()
            }
        }
        set {
            if let newValue {
                watchDirectoryUrl_returnValues.append(newValue)
            }
        }
    }
    private var watchDirectoryUrl_returnValues: [URL?] = []
    public var isWatchAppInstalled_returnValue: Bool {
        get {
            if isWatchAppInstalled_returnValues.isEmpty {
                .default
            } else {
                isWatchAppInstalled_returnValues.removeFirst()
            }
        }
        set {
            isWatchAppInstalled_returnValues.append(newValue)
        }
    }
    private var isWatchAppInstalled_returnValues: [Bool] = []
    public var isComplicationEnabled_returnValue: Bool {
        get {
            if isComplicationEnabled_returnValues.isEmpty {
                .default
            } else {
                isComplicationEnabled_returnValues.removeFirst()
            }
        }
        set {
            isComplicationEnabled_returnValues.append(newValue)
        }
    }
    private var isComplicationEnabled_returnValues: [Bool] = []
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
    public var transferComplicationUserInfo_returnValue: CommunicationInfo {
        get {
            if transferComplicationUserInfo_returnValues.isEmpty {
                .default
            } else {
                transferComplicationUserInfo_returnValues.removeFirst()
            }
        }
        set {
            transferComplicationUserInfo_returnValues.append(newValue)
        }
    }
    private var transferComplicationUserInfo_returnValues: [CommunicationInfo] = []
    public var transferUserInfo_returnValue: CommunicationInfo {
        get {
            if transferUserInfo_returnValues.isEmpty {
                .default
            } else {
                transferUserInfo_returnValues.removeFirst()
            }
        }
        set {
            transferUserInfo_returnValues.append(newValue)
        }
    }
    private var transferUserInfo_returnValues: [CommunicationInfo] = []

    public init() {}
}

extension PhoneServiceTypeStub: PhoneServiceType {
    public var currentState: CommunicationState { currentState_returnValue }
    public var isReachable: Bool { isReachable_returnValue }
    public var applicationContext: [CommunicationUserInfo : Any] { applicationContext_returnValue }
    public var receivedApplicationContext: [CommunicationUserInfo : Any] { receivedApplicationContext_returnValue }
    public var remainingComplicationUserInfoTransfers: Int { remainingComplicationUserInfoTransfers_returnValue }
    public var isPaired: Bool { isPaired_returnValue }
    public var watchDirectoryUrl: URL? { watchDirectoryUrl_returnValue }
    public var isWatchAppInstalled: Bool { isWatchAppInstalled_returnValue }
    public var isComplicationEnabled: Bool { isComplicationEnabled_returnValue }
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

    public func send(message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?) -> Void {
    }

    public func send(messageData data: Data, errorHandler: ((Error) -> Void)?) -> Void {
    }

    public func transferComplication(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        transferComplicationUserInfo_returnValue
    }

    public func transfer(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        transferUserInfo_returnValue
    }

}
