// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

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
        case isPaired
        case watchDirectoryUrl
        case isWatchAppInstalled
        case isComplicationEnabled
        case remainingComplicationUserInfoTransfers
    }

    public enum MethodCall {
        case isSupported
        case activate
        case update(applicationContext: [String : Any])
        case send(message: [String : Any], replyHandler: (([String : Any]) -> Void)?, errorHandler: ((Error) -> Void)?)
        case send(data: Data, replyHandler: ((Data) -> Void)?, errorHandler: ((Error) -> Void)?)
        case transferComplication(userInfo: [String : Any])
        case transfer(userInfo: [String : Any])
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
    public var isPaired: Bool {
        get {
            variableLog.append(.isPaired)
            return realObject.isPaired
        }
        set {
            variableLog.append(.isPaired)
            realObject.isPaired  = newValue
        }
    }
    public var watchDirectoryUrl: URL? {
        get {
            variableLog.append(.watchDirectoryUrl)
            return realObject.watchDirectoryUrl
        }
        set {
            variableLog.append(.watchDirectoryUrl)
            realObject.watchDirectoryUrl  = newValue
        }
    }
    public var isWatchAppInstalled: Bool {
        get {
            variableLog.append(.isWatchAppInstalled)
            return realObject.isWatchAppInstalled
        }
        set {
            variableLog.append(.isWatchAppInstalled)
            realObject.isWatchAppInstalled  = newValue
        }
    }
    public var isComplicationEnabled: Bool {
        get {
            variableLog.append(.isComplicationEnabled)
            return realObject.isComplicationEnabled
        }
        set {
            variableLog.append(.isComplicationEnabled)
            realObject.isComplicationEnabled  = newValue
        }
    }
    public var remainingComplicationUserInfoTransfers: Int {
        get {
            variableLog.append(.remainingComplicationUserInfoTransfers)
            return realObject.remainingComplicationUserInfoTransfers
        }
        set {
            variableLog.append(.remainingComplicationUserInfoTransfers)
            realObject.remainingComplicationUserInfoTransfers  = newValue
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
    public func transferComplication(userInfo: [String : Any]) -> CommunicationInfo {
        methodLog.append(.transferComplication(userInfo: userInfo))
        return realObject.transferComplication(userInfo: userInfo)
    }
    public func transfer(userInfo: [String : Any]) -> CommunicationInfo {
        methodLog.append(.transfer(userInfo: userInfo))
        return realObject.transfer(userInfo: userInfo)
    }
}
