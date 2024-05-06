// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import WatchCommunicationKitInterface

public protocol WatchServiceTypeSpying {
    var variableLog: [WatchServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: WatchServiceTypeSpy.VariableName? { get }
    var methodLog: [WatchServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: WatchServiceTypeSpy.MethodCall? { get }
}

public final class WatchServiceTypeSpy: WatchServiceTypeSpying {
    public enum VariableName {
        case delegate
        case currentState
        case isReachable
        case applicationContext
        case receivedApplicationContext
        case isCompanionAppInstalled
        case iOSDeviceNeedsUnlockAfterRebootForReachability
    }

    public enum MethodCall {
        case isSupported
        case activate
        case update(applicationContext: [String : Any])
        case send(message: [String : Any], replyHandler: (([String : Any]) -> Void)?, errorHandler: ((Error) -> Void)?)
        case send(data: Data, replyHandler: ((Data) -> Void)?, errorHandler: ((Error) -> Void)?)
        case transfer(userInfo: [String : Any])
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private let realObject: WatchServiceType
    public init(realObject: WatchServiceType) {
        self.realObject = realObject
    }
}

extension WatchServiceTypeSpy: WatchServiceType {
    public var delegate: WatchDelegateType? {
        get {
            variableLog.append(.delegate)
            return realObject.delegate
        }
        set {
            variableLog.append(.delegate)
            realObject.delegate  = newValue
        }
    }
    public var currentState: CommunicationState {
        get {
            variableLog.append(.currentState)
            return realObject.currentState
        }
        set {
            variableLog.append(.currentState)
            realObject.currentState  = newValue
        }
    }
    public var isReachable: Bool {
        get {
            variableLog.append(.isReachable)
            return realObject.isReachable
        }
        set {
            variableLog.append(.isReachable)
            realObject.isReachable  = newValue
        }
    }
    public var applicationContext: [String : Any] {
        get {
            variableLog.append(.applicationContext)
            return realObject.applicationContext
        }
        set {
            variableLog.append(.applicationContext)
            realObject.applicationContext  = newValue
        }
    }
    public var receivedApplicationContext: [String : Any] {
        get {
            variableLog.append(.receivedApplicationContext)
            return realObject.receivedApplicationContext
        }
        set {
            variableLog.append(.receivedApplicationContext)
            realObject.receivedApplicationContext  = newValue
        }
    }
    public var isCompanionAppInstalled: Bool {
        get {
            variableLog.append(.isCompanionAppInstalled)
            return realObject.isCompanionAppInstalled
        }
        set {
            variableLog.append(.isCompanionAppInstalled)
            realObject.isCompanionAppInstalled  = newValue
        }
    }
    public var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool {
        get {
            variableLog.append(.iOSDeviceNeedsUnlockAfterRebootForReachability)
            return realObject.iOSDeviceNeedsUnlockAfterRebootForReachability
        }
        set {
            variableLog.append(.iOSDeviceNeedsUnlockAfterRebootForReachability)
            realObject.iOSDeviceNeedsUnlockAfterRebootForReachability  = newValue
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
    public func update(applicationContext: [String : Any]) throws -> Void {
        methodLog.append(.update(applicationContext: applicationContext))
        try realObject.update(applicationContext: applicationContext)
    }
    public func send(message: [String : Any], replyHandler: (([String : Any]) -> Void)?, errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.send(message: message, replyHandler: replyHandler, errorHandler: errorHandler))
        realObject.send(message: message, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    public func send(messageData data: Data, replyHandler: ((Data) -> Void)?, errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.send(data: data, replyHandler: replyHandler, errorHandler: errorHandler))
        realObject.send(messageData: data, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    public func transfer(userInfo: [String : Any]) -> CommunicationInfo {
        methodLog.append(.transfer(userInfo: userInfo))
        return realObject.transfer(userInfo: userInfo)
    }
}
