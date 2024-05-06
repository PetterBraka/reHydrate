//
//  PhoneService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 06/05/2024.
//

import WatchConnectivity
import WatchCommunicationKitInterface

public final class PhoneService: NSObject, PhoneServiceType {
    private var session: WCSession
    public var delegate: WatchDelegateType?
    
    public var currentState: CommunicationState
    public var isReachable: Bool
    public var applicationContext: [String : Any]
    public var receivedApplicationContext: [String : Any]
    
    public var isPaired: Bool
    public var watchDirectoryUrl: URL?
    public var isWatchAppInstalled: Bool
    public var isComplicationEnabled: Bool
    public var remainingComplicationUserInfoTransfers: Int
    
    public init(session: WCSession, delegate: WatchDelegateType?) {
        self.session = session
        self.delegate = delegate
        
        self.currentState = .init(from: session.activationState)
        self.isReachable = session.isReachable
        self.applicationContext = session.applicationContext
        self.receivedApplicationContext = session.receivedApplicationContext
        
        self.isPaired = false
        self.watchDirectoryUrl = nil
        self.isWatchAppInstalled = false
        self.isComplicationEnabled = false
        self.remainingComplicationUserInfoTransfers = 0
        
        super.init()
        self.session.delegate = self
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
    
    public func update(applicationContext: [String : Any]) throws {
        try session.updateApplicationContext(applicationContext)
    }
    
    public func send(
        message: [String : Any],
        replyHandler: (([String : Any]) -> Void)?,
        errorHandler: ((any Error) -> Void)? = nil
    ) {
        session.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
    public func send(
        messageData data: Data,
        replyHandler: ((Data) -> Void)?,
        errorHandler: ((any Error) -> Void)? = nil
    ) {
        session.sendMessageData(data, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
    public func transferComplication(userInfo: [String : Any]) -> CommunicationInfo {
#if os(watchOS)
        .init(isCurrentComplicationInfo: false, userInfo: [:], isTransferring: false)
#else
        .init(from: session.transferCurrentComplicationUserInfo(userInfo))
#endif
    }
    
    public func transfer(userInfo: [String : Any]) -> CommunicationInfo {
        .init(from: session.transferUserInfo(userInfo))
    }
}
