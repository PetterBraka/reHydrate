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
        case remainingComplicationUserInfoTransfers
        case isPaired
        case watchDirectoryUrl
        case isWatchAppInstalled
        case isComplicationEnabled
    }

    public enum MethodCall {
        case isSupported
        case activate
        case update(applicationContext: [CommunicationUserInfo : Codable])
        case send(message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?)
        case send(data: Data, errorHandler: ((Error) -> Void)?)
        case transferComplication(userInfo: [CommunicationUserInfo : Codable])
        case transfer(userInfo: [CommunicationUserInfo : Codable])
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
        methodLog.append(.update(applicationContext: applicationContext))
        try realObject.update(applicationContext: applicationContext)
    }
    public func send(message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.send(message: message, errorHandler: errorHandler))
        realObject.send(message: message, errorHandler: errorHandler)
    }
    public func send(messageData data: Data, errorHandler: ((Error) -> Void)?) -> Void {
        methodLog.append(.send(data: data, errorHandler: errorHandler))
        realObject.send(messageData: data, errorHandler: errorHandler)
    }
    public func transferComplication(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        methodLog.append(.transferComplication(userInfo: userInfo))
        return realObject.transferComplication(userInfo: userInfo)
    }
    public func transfer(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        methodLog.append(.transfer(userInfo: userInfo))
        return realObject.transfer(userInfo: userInfo)
    }
}
