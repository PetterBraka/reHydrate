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
    
    public var currentState: CommunicationState
    public var isReachable: Bool
    public var applicationContext: [CommunicationUserInfo : Any]
    public var receivedApplicationContext: [CommunicationUserInfo : Any]
    
    public var isPaired: Bool
    public var watchDirectoryUrl: URL?
    public var isWatchAppInstalled: Bool
    public var isComplicationEnabled: Bool
    public var remainingComplicationUserInfoTransfers: Int
    
    public init(session: WCSession) {
        self.session = session
        
        self.currentState = .init(from: session.activationState)
        self.isReachable = session.isReachable
        self.applicationContext = session.applicationContext.mapKeys()
        self.receivedApplicationContext = session.receivedApplicationContext.mapKeys()
        
        self.isPaired = false
        self.watchDirectoryUrl = nil
        self.isWatchAppInstalled = false
        self.isComplicationEnabled = false
        self.remainingComplicationUserInfoTransfers = 0
        
        super.init()
        self.didReceivedUpdates(from: session)
    }
    
    internal func didReceivedUpdates(from session: WCSession) {
        self.currentState = .init(from: session.activationState)
        self.isReachable = session.isReachable
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
    
    public func update(applicationContext: [CommunicationUserInfo : Any]) throws {
        try session.updateApplicationContext(applicationContext.mapKeys())
    }
    
    public func send(
        message: [CommunicationUserInfo : Any],
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
    
    public func transferComplication(userInfo: [CommunicationUserInfo : Any]) -> CommunicationInfo {
#if os(watchOS)
        .init(isCurrentComplicationInfo: false, userInfo: [:], isTransferring: false)
#else
        .init(from: session.transferCurrentComplicationUserInfo(userInfo.mapKeys()))
#endif
    }
    
    public func transfer(userInfo: [CommunicationUserInfo : Any]) -> CommunicationInfo {
#if os(watchOS)
        .init(isCurrentComplicationInfo: false, userInfo: [:], isTransferring: false)
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
            isTransferring: info.isTransferring
        )
    }
#endif
}

fileprivate extension Dictionary where Key == CommunicationUserInfo {
    func mapKeys() -> [String: Value]{
        reduce(into: [String: Value]()) { partialResult, element in
            partialResult[element.key.rawValue] = element.value
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
