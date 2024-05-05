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
    
#if os(iOS)
    public var isPaired: Bool
    public var watchDirectoryUrl: URL?
    public var isWatchAppInstalled: Bool
    public var isComplicationEnabled: Bool
    public var remainingComplicationUserInfoTransfers: Int
#endif
    
#if os(watchOS)
    public var isCompanionAppInstalled: Bool
    public var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool
#endif
    
    public init(session: WCSession, delegate: WatchDelegateType?) {
        self.session = session
        self.delegate = delegate
        
        self.currentState = .init(from: session.activationState)
        self.isReachable = session.isReachable
        self.applicationContext = session.applicationContext
        self.receivedApplicationContext = session.receivedApplicationContext
        
#if os(iOS)
        self.isPaired = session.isPaired
        self.watchDirectoryUrl = nil
        self.isWatchAppInstalled = session.isWatchAppInstalled
        self.isComplicationEnabled = session.isComplicationEnabled
        self.remainingComplicationUserInfoTransfers = session.remainingComplicationUserInfoTransfers
#endif
        
#if os(watchOS)
        self.isCompanionAppInstalled = session.isCompanionAppInstalled
        self.iOSDeviceNeedsUnlockAfterRebootForReachability = session.iOSDeviceNeedsUnlockAfterRebootForReachability
#endif
        
        super.init()
        self.session.delegate = self
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

#if os(iOS)
    public func transferComplication(userInfo: [String : Any]) -> CommunicationInfo {
        .init(from: session.transferCurrentComplicationUserInfo(userInfo))
    }
#endif
    
    public func transfer(userInfo: [String : Any]) -> CommunicationInfo {
        .init(from: session.transferUserInfo(userInfo))
    }
}
