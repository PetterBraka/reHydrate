// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import WatchCommunicationKitInterface

public protocol PhoneDelegateTypeSpying {
    var variableLog: [PhoneDelegateTypeSpy.VariableName] { get set }
    var lastVariabelCall: PhoneDelegateTypeSpy.VariableName? { get }
    var methodLog: [PhoneDelegateTypeSpy.MethodCall] { get set }
    var lastMethodCall: PhoneDelegateTypeSpy.MethodCall? { get }
}

public final class PhoneDelegateTypeSpy: PhoneDelegateTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case session(activationState: CommunicationState, error: Error?)
        case sessionDidDeactivate
        case sessionDidBecomeInactive
        case sessionWatchStateDidChange
        case sessionReachabilityDidChange
        case session(applicationContext: [String : Any])
        case session(message: [String : Any])
        case session(message: [String : Any], replyHandler: ([String : Any]) -> Void)
        case session(messageData: Data)
        case session(messageData: Data, replyHandler: (Data) -> Void)
        case session(userInfo: [String : Any])
        case session(communicationInfo: CommunicationInfo, error: Error?)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: PhoneDelegateType
    public init(realObject: PhoneDelegateType) {
        self.realObject = realObject
    }
}

extension PhoneDelegateTypeSpy: PhoneDelegateType {
    public func session(activationDidCompleteWith activationState: CommunicationState, error: Error?) -> Void {
        methodLog.append(.session(activationState: activationState, error: error))
        realObject.session(activationDidCompleteWith: activationState, error: error)
    }
    public func sessionDidDeactivate() -> Void {
        methodLog.append(.sessionDidDeactivate)
        realObject.sessionDidDeactivate()
    }
    public func sessionDidBecomeInactive() -> Void {
        methodLog.append(.sessionDidBecomeInactive)
        realObject.sessionDidBecomeInactive()
    }
    public func sessionWatchStateDidChange() -> Void {
        methodLog.append(.sessionWatchStateDidChange)
        realObject.sessionWatchStateDidChange()
    }
    public func sessionReachabilityDidChange() -> Void {
        methodLog.append(.sessionReachabilityDidChange)
        realObject.sessionReachabilityDidChange()
    }
    public func session(didReceiveApplicationContext applicationContext: [String : Any]) -> Void {
        methodLog.append(.session(applicationContext: applicationContext))
        realObject.session(didReceiveApplicationContext: applicationContext)
    }
    public func session(didReceiveMessage message: [String : Any]) -> Void {
        methodLog.append(.session(message: message))
        realObject.session(didReceiveMessage: message)
    }
    public func session(didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) -> Void {
        methodLog.append(.session(message: message, replyHandler: replyHandler))
        realObject.session(didReceiveMessage: message, replyHandler: replyHandler)
    }
    public func session(didReceiveMessageData messageData: Data) -> Void {
        methodLog.append(.session(messageData: messageData))
        realObject.session(didReceiveMessageData: messageData)
    }
    public func session(didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) -> Void {
        methodLog.append(.session(messageData: messageData, replyHandler: replyHandler))
        realObject.session(didReceiveMessageData: messageData, replyHandler: replyHandler)
    }
    public func session(didReceiveUserInfo userInfo: [String : Any]) -> Void {
        methodLog.append(.session(userInfo: userInfo))
        realObject.session(didReceiveUserInfo: userInfo)
    }
    public func session(didFinish communicationInfo: CommunicationInfo, error: Error?) -> Void {
        methodLog.append(.session(communicationInfo: communicationInfo, error: error))
        realObject.session(didFinish: communicationInfo, error: error)
    }
}
