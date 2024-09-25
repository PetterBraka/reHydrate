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
        case update(applicationContext: [CommunicationUserInfo : Codable])
        case sendMessage(message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?)
        case sendData(data: Data, errorHandler: ((Error) -> Void)?)
        case sendUserInfo(userInfo: [CommunicationUserInfo : Codable])
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
        methodLog.append(.update(applicationContext: applicationContext))
        try realObject.update(applicationContext: applicationContext)
    }
    public func sendMessage(_ message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.sendMessage(message: message, errorHandler: errorHandler))
        realObject.sendMessage(message, errorHandler: errorHandler)
    }
    public func sendData(_ data: Data, errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.sendData(data: data, errorHandler: errorHandler))
        realObject.sendData(data, errorHandler: errorHandler)
    }
    public func sendUserInfo(_ userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        methodLog.append(.sendUserInfo(userInfo: userInfo))
        return realObject.sendUserInfo(userInfo)
    }
}
