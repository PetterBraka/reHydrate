// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import CommunicationKitInterface

public protocol PhoneServiceTypeSpying {
    var variableLog: [PhoneServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: PhoneServiceTypeSpy.VariableName? { get }
    var methodLog: [PhoneServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: PhoneServiceTypeSpy.MethodCall? { get }
}

public final class PhoneServiceTypeSpy: PhoneServiceTypeSpying {
    public enum VariableName {
        case currentState
        case isReachable
        case applicationContext
        case receivedApplicationContext
        case remainingComplicationUserInfoTransfers
        case isPaired
        case watchDirectoryUrl
        case isWatchAppInstalled
        case isComplicationEnabled
    }

    public enum MethodCall {
        case isSupported
        case activate
        case updateApplicationContext(applicationContext: [CommunicationUserInfo : Codable])
        case sendMessageMessageErrorHandler(message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?)
        case sendDataDataErrorHandler(data: Data, errorHandler: ((Error) -> Void)?)
        case transferComplicationUserInfo(userInfo: [CommunicationUserInfo : Codable])
        case transferUserInfo(userInfo: [CommunicationUserInfo : Codable])
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: PhoneServiceType
    public init(realObject: PhoneServiceType) {
        self.realObject = realObject
    }
}

extension PhoneServiceTypeSpy: PhoneServiceType {
    public var currentState: CommunicationState {
        get {
            variableLog.append(.currentState)
            return realObject.currentState
        }
    }
    public var isReachable: Bool {
        get {
            variableLog.append(.isReachable)
            return realObject.isReachable
        }
    }
    public var applicationContext: [CommunicationUserInfo : Any] {
        get {
            variableLog.append(.applicationContext)
            return realObject.applicationContext
        }
    }
    public var receivedApplicationContext: [CommunicationUserInfo : Any] {
        get {
            variableLog.append(.receivedApplicationContext)
            return realObject.receivedApplicationContext
        }
    }
    public var remainingComplicationUserInfoTransfers: Int {
        get {
            variableLog.append(.remainingComplicationUserInfoTransfers)
            return realObject.remainingComplicationUserInfoTransfers
        }
    }
    public var isPaired: Bool {
        get {
            variableLog.append(.isPaired)
            return realObject.isPaired
        }
    }
    public var watchDirectoryUrl: URL? {
        get {
            variableLog.append(.watchDirectoryUrl)
            return realObject.watchDirectoryUrl
        }
    }
    public var isWatchAppInstalled: Bool {
        get {
            variableLog.append(.isWatchAppInstalled)
            return realObject.isWatchAppInstalled
        }
    }
    public var isComplicationEnabled: Bool {
        get {
            variableLog.append(.isComplicationEnabled)
            return realObject.isComplicationEnabled
        }
    }
    public func isSupported() -> Bool {
        methodLog.append(.isSupported)
        return realObject.isSupported()
    }
    public func activate() -> Void {
        methodLog.append(.activate)
        realObject.activate()
    }
    public func update(applicationContext: [CommunicationUserInfo : Codable]) throws -> Void {
        methodLog.append(.updateApplicationContext(applicationContext: applicationContext))
        try realObject.update(applicationContext: applicationContext)
    }
    public func sendMessage(_ message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.sendMessageMessageErrorHandler(message: message, errorHandler: errorHandler))
        realObject.sendMessage(message, errorHandler: errorHandler)
    }
    public func sendData(_ data: Data, errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.sendDataDataErrorHandler(data: data, errorHandler: errorHandler))
        realObject.sendData(data, errorHandler: errorHandler)
    }
    public func transferComplication(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        methodLog.append(.transferComplicationUserInfo(userInfo: userInfo))
        return realObject.transferComplication(userInfo: userInfo)
    }
    public func transfer(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        methodLog.append(.transferUserInfo(userInfo: userInfo))
        return realObject.transfer(userInfo: userInfo)
    }
}

extension PhoneServiceTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .currentState: "currentState"
        case .isReachable: "isReachable"
        case .applicationContext: "applicationContext"
        case .receivedApplicationContext: "receivedApplicationContext"
        case .remainingComplicationUserInfoTransfers: "remainingComplicationUserInfoTransfers"
        case .isPaired: "isPaired"
        case .watchDirectoryUrl: "watchDirectoryUrl"
        case .isWatchAppInstalled: "isWatchAppInstalled"
        case .isComplicationEnabled: "isComplicationEnabled"
        }
    }
}

extension PhoneServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .isSupported: "isSupported"
        case .activate: "activate"
        case .updateApplicationContext(let applicationContext): "update(\(String(describing: applicationContext)))"
        case .sendMessageMessageErrorHandler(let message, let errorHandler): "sendMessage(\(String(describing: message)), \(String(describing: errorHandler)))"
        case .sendDataDataErrorHandler(let data, let errorHandler): "sendData(\(String(describing: data)), \(String(describing: errorHandler)))"
        case .transferComplicationUserInfo(let userInfo): "transferComplication(\(String(describing: userInfo)))"
        case .transferUserInfo(let userInfo): "transfer(\(String(describing: userInfo)))"
        }
    }
}

import Foundation
import CommunicationKitInterface

public protocol WatchServiceTypeSpying {
    var variableLog: [WatchServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: WatchServiceTypeSpy.VariableName? { get }
    var methodLog: [WatchServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: WatchServiceTypeSpy.MethodCall? { get }
}

public final class WatchServiceTypeSpy: WatchServiceTypeSpying {
    public enum VariableName {
        case currentState
        case isReachable
        case applicationContext
        case receivedApplicationContext
        case iOSDeviceNeedsUnlockAfterRebootForReachability
    }

    public enum MethodCall {
        case isSupported
        case activate
        case updateApplicationContext(applicationContext: [CommunicationUserInfo : Codable])
        case sendMessageMessageErrorHandler(message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?)
        case sendDataDataErrorHandler(data: Data, errorHandler: ((Error) -> Void)?)
        case sendUserInfoUserInfo(userInfo: [CommunicationUserInfo : Codable])
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: WatchServiceType
    public init(realObject: WatchServiceType) {
        self.realObject = realObject
    }
}

extension WatchServiceTypeSpy: WatchServiceType {
    public var currentState: CommunicationState {
        get {
            variableLog.append(.currentState)
            return realObject.currentState
        }
    }
    public var isReachable: Bool {
        get {
            variableLog.append(.isReachable)
            return realObject.isReachable
        }
    }
    public var applicationContext: [CommunicationUserInfo : Any] {
        get {
            variableLog.append(.applicationContext)
            return realObject.applicationContext
        }
    }
    public var receivedApplicationContext: [CommunicationUserInfo : Any] {
        get {
            variableLog.append(.receivedApplicationContext)
            return realObject.receivedApplicationContext
        }
    }
    public var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool {
        get {
            variableLog.append(.iOSDeviceNeedsUnlockAfterRebootForReachability)
            return realObject.iOSDeviceNeedsUnlockAfterRebootForReachability
        }
    }
    public func isSupported() -> Bool {
        methodLog.append(.isSupported)
        return realObject.isSupported()
    }
    public func activate() -> Void {
        methodLog.append(.activate)
        realObject.activate()
    }
    public func update(applicationContext: [CommunicationUserInfo : Codable]) throws -> Void {
        methodLog.append(.updateApplicationContext(applicationContext: applicationContext))
        try realObject.update(applicationContext: applicationContext)
    }
    public func sendMessage(_ message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.sendMessageMessageErrorHandler(message: message, errorHandler: errorHandler))
        realObject.sendMessage(message, errorHandler: errorHandler)
    }
    public func sendData(_ data: Data, errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.sendDataDataErrorHandler(data: data, errorHandler: errorHandler))
        realObject.sendData(data, errorHandler: errorHandler)
    }
    public func sendUserInfo(_ userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        methodLog.append(.sendUserInfoUserInfo(userInfo: userInfo))
        return realObject.sendUserInfo(userInfo)
    }
}

extension WatchServiceTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .currentState: "currentState"
        case .isReachable: "isReachable"
        case .applicationContext: "applicationContext"
        case .receivedApplicationContext: "receivedApplicationContext"
        case .iOSDeviceNeedsUnlockAfterRebootForReachability: "iOSDeviceNeedsUnlockAfterRebootForReachability"
        }
    }
}

extension WatchServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .isSupported: "isSupported"
        case .activate: "activate"
        case .updateApplicationContext(let applicationContext): "update(\(String(describing: applicationContext)))"
        case .sendMessageMessageErrorHandler(let message, let errorHandler): "sendMessage(\(String(describing: message)), \(String(describing: errorHandler)))"
        case .sendDataDataErrorHandler(let data, let errorHandler): "sendData(\(String(describing: data)), \(String(describing: errorHandler)))"
        case .sendUserInfoUserInfo(let userInfo): "sendUserInfo(\(String(describing: userInfo)))"
        }
    }
}
// MARK: - AutoString
// swiftlint:disable all

import CommunicationKitInterface

extension CommunicationUserInfo: CustomStringConvertible {
    public var description: String {
        switch self {
        case .session: "session"
        case .messageData: "messageData"
        case .activationState: "activationState"
        case .day: "day"
        case .drinks: "drinks"
        case .unitSystem: "unitSystem"
        }
    }
}


// MARK: - AutoStub
// swiftlint:disable all  
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

    public func sendMessage(_ message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?) -> Void {
    }

    public func sendData(_ data: Data, errorHandler: ((Error) -> Void)?) -> Void {
    }

    public func transferComplication(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        transferComplicationUserInfo_returnValue
    }

    public func transfer(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        transferUserInfo_returnValue
    }

}
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
