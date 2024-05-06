// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import WatchCommunicationKitInterface

public protocol PhoneServiceTypeStubbing {
    var delegate_returnValue: PhoneDelegateType? { get set }
    var currentState_returnValue: CommunicationState { get set }
    var isReachable_returnValue: Bool { get set }
    var applicationContext_returnValue: [String : Any] { get set }
    var receivedApplicationContext_returnValue: [String : Any] { get set }
    var isPaired_returnValue: Bool { get set }
    var watchDirectoryUrl_returnValue: URL? { get set }
    var isWatchAppInstalled_returnValue: Bool { get set }
    var isComplicationEnabled_returnValue: Bool { get set }
    var remainingComplicationUserInfoTransfers_returnValue: Int { get set }
    var isSupported_returnValue: Bool { get set }
    var updateApplicationContext_returnValue: Error? { get set }
    var transferComplicationUserInfo_returnValue: CommunicationInfo { get set }
    var transferUserInfo_returnValue: CommunicationInfo { get set }
}

public final class PhoneServiceTypeStub: PhoneServiceTypeStubbing {
    public var delegate_returnValue: PhoneDelegateType? {
        get {
            if delegate_returnValues.isEmpty {
                .default
            } else {
                delegate_returnValues.removeFirst()
            }
        }
        set {
            if let newValue {
                delegate_returnValues.append(newValue)
            }
        }
    }
    private var delegate_returnValues: [PhoneDelegateType?] = []
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
    public var applicationContext_returnValue: [String : Any] {
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
    private var applicationContext_returnValues: [[String : Any]] = []
    public var receivedApplicationContext_returnValue: [String : Any] {
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
    private var receivedApplicationContext_returnValues: [[String : Any]] = []
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
    public var delegate: PhoneDelegateType? { 
        get { delegate_returnValue }
        set { delegate_returnValue = newValue }
    }
    public var currentState: CommunicationState { 
        get { currentState_returnValue }
        set { currentState_returnValue = newValue }
    }
    public var isReachable: Bool { 
        get { isReachable_returnValue }
        set { isReachable_returnValue = newValue }
    }
    public var applicationContext: [String : Any] { 
        get { applicationContext_returnValue }
        set { applicationContext_returnValue = newValue }
    }
    public var receivedApplicationContext: [String : Any] { 
        get { receivedApplicationContext_returnValue }
        set { receivedApplicationContext_returnValue = newValue }
    }
    public var isPaired: Bool { 
        get { isPaired_returnValue }
        set { isPaired_returnValue = newValue }
    }
    public var watchDirectoryUrl: URL? { 
        get { watchDirectoryUrl_returnValue }
        set { watchDirectoryUrl_returnValue = newValue }
    }
    public var isWatchAppInstalled: Bool { 
        get { isWatchAppInstalled_returnValue }
        set { isWatchAppInstalled_returnValue = newValue }
    }
    public var isComplicationEnabled: Bool { 
        get { isComplicationEnabled_returnValue }
        set { isComplicationEnabled_returnValue = newValue }
    }
    public var remainingComplicationUserInfoTransfers: Int { 
        get { remainingComplicationUserInfoTransfers_returnValue }
        set { remainingComplicationUserInfoTransfers_returnValue = newValue }
    }
    public func isSupported() -> Bool {
        isSupported_returnValue
    }

    public func activate() -> Void {
    }

    public func update(applicationContext: [String : Any]) throws -> Void {
        if let updateApplicationContext_returnValue {
            throw updateApplicationContext_returnValue
        }
    }

    public func send(message: [String : Any], replyHandler: (([String : Any]) -> Void)?, errorHandler: ((Error) -> Void)?) -> Void {
    }

    public func send(messageData data: Data, replyHandler: ((Data) -> Void)?, errorHandler: ((Error) -> Void)?) -> Void {
    }

    public func transferComplication(userInfo: [String : Any]) -> CommunicationInfo {
        transferComplicationUserInfo_returnValue
    }

    public func transfer(userInfo: [String : Any]) -> CommunicationInfo {
        transferUserInfo_returnValue
    }

}
