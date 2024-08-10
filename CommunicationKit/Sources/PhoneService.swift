//
//  PhoneService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 06/05/2024.
//

import WatchConnectivity
import CommunicationKitInterface

public final class PhoneService: NSObject, PhoneServiceType {
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
    public var remainingComplicationUserInfoTransfers: Int {
#if os(watchOS)
        0
#else
        session.remainingComplicationUserInfoTransfers
#endif
    }
    
    public var isPaired: Bool
    public var watchDirectoryUrl: URL?
    public var isWatchAppInstalled: Bool
    public var isComplicationEnabled: Bool
    
    public init(session: WCSession) {
        self.session = session
        
        self.isPaired = false
        self.watchDirectoryUrl = nil
        self.isWatchAppInstalled = false
        self.isComplicationEnabled = false
        
        super.init()
        self.didReceivedUpdates(from: session)
    }
    
    internal func didReceivedUpdates(from session: WCSession) {
        #if os(watchOS)
        #else
        self.isPaired = session.isPaired
        self.watchDirectoryUrl = session.watchDirectoryURL
        self.isWatchAppInstalled = session.isWatchAppInstalled
        self.isComplicationEnabled = session.isComplicationEnabled
        #endif
    }
}

extension PhoneService {
    public func isSupported() -> Bool {
        WCSession.isSupported()
    }
    
    public func activate() {
        session.activate()
    }
    
    public func update(applicationContext: [CommunicationUserInfo : Codable]) throws {
        try session.updateApplicationContext(applicationContext.mapKeys())
    }
    
    public func send(
        message: [CommunicationUserInfo : Codable],
        errorHandler: ((any Error) -> Void)? = nil
    ) {
        session.sendMessage(message.mapKeys(), replyHandler: nil, errorHandler: errorHandler)
    }
    
    public func send(
        messageData data: Data,
        errorHandler: ((any Error) -> Void)? = nil
    ) {
        session.sendMessageData(data, replyHandler: nil, errorHandler: errorHandler)
    }
    
    public func transferComplication(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
#if os(watchOS)
        .init(isCurrentComplicationInfo: false, userInfo: [:], isTransferring: false) {}
#else
        .init(from: session.transferCurrentComplicationUserInfo(userInfo.mapKeys()))
#endif
    }
    
    public func transfer(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
#if os(watchOS)
        .init(isCurrentComplicationInfo: false, userInfo: [:], isTransferring: false) {}
#else
        .init(from: session.transferUserInfo(userInfo.mapKeys()))
#endif
    }
}

fileprivate extension CommunicationInfo {
#if os(iOS)
    init(from info: WCSessionUserInfoTransfer) {
        self.init(
            isCurrentComplicationInfo: info.isCurrentComplicationInfo,
            userInfo: info.userInfo,
            isTransferring: info.isTransferring,
            cancel: info.cancel
        )
    }
#endif
}

fileprivate extension Dictionary where Key == CommunicationUserInfo, Value == Codable {
    func mapKeys() -> [String: Data]{
        reduce(into: [String: Data]()) { partialResult, element in
            let encoder = JSONEncoder()
            partialResult[element.key.rawValue] = try? encoder.encode(element.value)
        }
    }
}

fileprivate extension Dictionary where Key == String {
    func mapKeys() -> [CommunicationUserInfo: Any]{
        reduce(into: [CommunicationUserInfo: Any]()) { partialResult, element in
            guard let key = CommunicationUserInfo(rawValue: element.key) else { return }
            partialResult[key] = element.value
        }
    }
}

fileprivate extension Dictionary where Key == AnyHashable {
    func mapKeys() -> [CommunicationUserInfo: Any]{
        reduce(into: [CommunicationUserInfo: Any]()) { partialResult, element in
            guard let key = CommunicationUserInfo(rawValue: "\(element.key)") else { return }
            partialResult[key] = element.value
        }
    }
}
