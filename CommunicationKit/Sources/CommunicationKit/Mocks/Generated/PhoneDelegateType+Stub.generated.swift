// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import CommunicationKitInterface

public protocol PhoneDelegateTypeStubbing {
}

public final class PhoneDelegateTypeStub: PhoneDelegateTypeStubbing {

    public init() {}
}

extension PhoneDelegateTypeStub: PhoneDelegateType {
    public func session(activationDidCompleteWith activationState: CommunicationState, error: Error?) -> Void {
    }

    public func sessionDidDeactivate() -> Void {
    }

    public func sessionDidBecomeInactive() -> Void {
    }

    public func sessionWatchStateDidChange() -> Void {
    }

    public func sessionReachabilityDidChange() -> Void {
    }

    public func session(didReceiveApplicationContext applicationContext: [String : Any]) -> Void {
    }

    public func session(didReceiveMessage message: [String : Any]) -> Void {
    }

    public func session(didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) -> Void {
    }

    public func session(didReceiveMessageData messageData: Data) -> Void {
    }

    public func session(didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) -> Void {
    }

    public func session(didReceiveUserInfo userInfo: [String : Any]) -> Void {
    }

    public func session(didFinish communicationInfo: CommunicationInfo, error: Error?) -> Void {
    }

}
