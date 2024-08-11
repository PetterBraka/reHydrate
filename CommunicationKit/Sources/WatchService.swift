//
//  WatchCommunicationService.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import WatchConnectivity
import CommunicationKitInterface

public final class WatchService: NSObject, WatchServiceType {
    private var session: WCSession
    
    public var currentState: CommunicationState {
        .init(from: session.activationState)
    }
    public var isReachable: Bool {
        session.isReachable
    }
    public var applicationContext: [CommunicationUserInfo : Any] {
        session.applicationContext.mapKeys()
    }
    public var receivedApplicationContext: [CommunicationUserInfo : Any] {
        session.receivedApplicationContext.mapKeys()
    }
    public var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool {
#if os(watchOS)
        session.iOSDeviceNeedsUnlockAfterRebootForReachability
#else
        false
#endif
    }
    
    public init(session: WCSession) {
        self.session = session
        super.init()
    }
}

extension WatchService {
    public func isSupported() -> Bool {
        WCSession.isSupported()
    }
    
    public func activate() {
        session.activate()
    }
    
    public func update(applicationContext: [CommunicationUserInfo : Codable]) throws {
        try session.updateApplicationContext(applicationContext.mapKeys())
    }
    
    public func sendMessage(
        _ message: [CommunicationUserInfo : Codable],
        errorHandler: ((any Error) -> Void)? = nil
    ) {
        session.sendMessage(message.mapKeys(), replyHandler: nil, errorHandler: errorHandler)
    }
    
    public func sendData(
        _ data: Data,
        errorHandler: ((any Error) -> Void)? = nil
    ) {
        session.sendMessageData(data, replyHandler: nil, errorHandler: errorHandler)
    }
    
    public func sendUserInfo(_ userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
        .init(from: session.transferUserInfo(userInfo.mapKeys()))
    }
}

fileprivate extension CommunicationInfo {
    init(from info: WCSessionUserInfoTransfer) {
        self.init(
            isCurrentComplicationInfo: false,
            userInfo: info.userInfo,
            isTransferring: info.isTransferring,
            cancel: info.cancel
        )
    }
}

fileprivate extension Dictionary where Key == CommunicationUserInfo, Value == Codable {
    func mapKeys() -> [String: Value]{
        reduce(into: [String: Value]()) { partialResult, element in
            let encoder = JSONEncoder()
            partialResult[element.key.rawValue] = try? encoder.encode(element.value)
        }
    }
}

fileprivate extension Dictionary where Key == String {
    func mapKeys() -> [CommunicationUserInfo: Value]{
        reduce(into: [CommunicationUserInfo: Value]()) { partialResult, element in
            guard let key = CommunicationUserInfo(rawValue: element.key) else { return }
            partialResult[key] = element.value
        }
    }
}

fileprivate extension Dictionary where Key == AnyHashable {
    func mapKeys() -> [CommunicationUserInfo: Value]{
        reduce(into: [CommunicationUserInfo: Value]()) { partialResult, element in
            guard let key = CommunicationUserInfo(rawValue: "\(element.key)") else { return }
            partialResult[key] = element.value
        }
    }
}
