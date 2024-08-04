// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

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
        case update(applicationContext: [CommunicationUserInfo : Any])
        case send(message: [CommunicationUserInfo : Any], errorHandler: ((Error) -> Void)?)
        case send(data: Data, errorHandler: ((Error) -> Void)?)
        case send(userInfo: [CommunicationUserInfo : Any])
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
    public var applicationContext: [CommunicationUserInfo : Any] {
        get {
            variableLog.append(.applicationContext)
            return realObject.applicationContext
        }
        set {
            variableLog.append(.applicationContext)
            realObject.applicationContext  = newValue
        }
    }
    public var receivedApplicationContext: [CommunicationUserInfo : Any] {
        get {
            variableLog.append(.receivedApplicationContext)
            return realObject.receivedApplicationContext
        }
        set {
            variableLog.append(.receivedApplicationContext)
            realObject.receivedApplicationContext  = newValue
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
    public func update(applicationContext: [CommunicationUserInfo : Any]) throws -> Void {
        methodLog.append(.update(applicationContext: applicationContext))
        try realObject.update(applicationContext: applicationContext)
    }
    public func send(message: [CommunicationUserInfo : Any], errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.send(message: message, errorHandler: errorHandler))
        realObject.send(message: message, errorHandler: errorHandler)
    }
    public func send(messageData data: Data, errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.send(data: data, errorHandler: errorHandler))
        realObject.send(messageData: data, errorHandler: errorHandler)
    }
    public func send(userInfo: [CommunicationUserInfo : Any]) -> CommunicationInfo {
        methodLog.append(.send(userInfo: userInfo))
        return realObject.send(userInfo: userInfo)
    }
}
