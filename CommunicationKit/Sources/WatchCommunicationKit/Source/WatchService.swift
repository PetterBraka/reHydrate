//
//  WatchCommunicationService.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import WatchConnectivity
import WatchCommunicationKitInterface

public final class WatchService: NSObject, WatchServiceType {
    private var session: WCSession
    public var delegate: WatchDelegateType?
    
    public var currentState: CommunicationState
    public var isReachable: Bool
    public var applicationContext: [String : Any]
    public var receivedApplicationContext: [String : Any]
    public var isCompanionAppInstalled: Bool
    public var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool
    
    public init(session: WCSession, delegate: WatchDelegateType?) {
        self.session = session
        self.delegate = delegate
        
        self.currentState = .init(from: session.activationState)
        self.isReachable = session.isReachable
        self.applicationContext = session.applicationContext
        self.receivedApplicationContext = session.receivedApplicationContext
        
        self.isCompanionAppInstalled = false
        self.iOSDeviceNeedsUnlockAfterRebootForReachability = false
        
        super.init()
        self.session.delegate = self
        self.didReceivedUpdates(from: session)
    }
    
    func didReceivedUpdates(from session: WCSession) {
        self.currentState = .init(from: session.activationState)
        self.isReachable = session.isReachable
#if os(watchOS)
        self.iOSDeviceNeedsUnlockAfterRebootForReachability = session.iOSDeviceNeedsUnlockAfterRebootForReachability
#endif
    }
}

extension WatchService {
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
    
    public func transfer(userInfo: [String : Any]) -> CommunicationInfo {
        .init(from: session.transferUserInfo(userInfo))
    }
}
