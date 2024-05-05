//
//  WatchCommunicationService+delegate.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import WatchConnectivity

private extension WatchService {
    func didReceivedUpdates(from session: WCSession) {
        self.currentState = .init(from: session.activationState)
        self.isReachable = session.isReachable
#if os(watchOS)
        self.iOSDeviceNeedsUnlockAfterRebootForReachability = session.iOSDeviceNeedsUnlockAfterRebootForReachability
#endif
#if os(iOS)
        self.isPaired = session.isPaired
        self.watchDirectoryUrl = session.watchDirectoryURL
        self.isWatchAppInstalled = session.isWatchAppInstalled
        self.isComplicationEnabled = session.isComplicationEnabled
#endif
    }
}

extension WatchService: WCSessionDelegate {
    public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
        didReceivedUpdates(from: session)
        self.delegate?.session(activationDidCompleteWith: self.currentState, error: error)
    }
    
#if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        didReceivedUpdates(from: session)
        delegate?.sessionDidBecomeInactive()
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        didReceivedUpdates(from: session)
        delegate?.sessionDidDeactivate()
    }
    
    public func sessionWatchStateDidChange(_ session: WCSession) {
        didReceivedUpdates(from: session)
        delegate?.sessionWatchStateDidChange()
    }
#endif
    
#if os(watchOS)
    public func sessionCompanionAppInstalledDidChange(_ session: WCSession) {
        didReceivedUpdates(from: session)
        delegate?.sessionCompanionAppInstalledDidChange()
    }
#endif
    
    public func sessionReachabilityDidChange(_ session: WCSession) {
        didReceivedUpdates(from: session)
        delegate?.sessionReachabilityDidChange()
    }
}

// MARK: Receive context/message/userInfo/data
extension WatchService {
    public func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        didReceivedUpdates(from: session)
        delegate?.session(didReceiveApplicationContext: applicationContext)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        didReceivedUpdates(from: session)
        delegate?.session(didReceiveMessage: message)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any],
        replyHandler: @escaping ([String : Any]) -> Void
    ) {
        didReceivedUpdates(from: session)
        delegate?.session(didReceiveMessage: message, replyHandler: replyHandler)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessageData messageData: Data
    ) {
        didReceivedUpdates(from: session)
        delegate?.session(didReceiveMessageData: messageData)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessageData messageData: Data,
        replyHandler: @escaping (Data) -> Void
    ) {
        didReceivedUpdates(from: session)
        delegate?.session(didReceiveMessageData: messageData, replyHandler: replyHandler)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String : Any]
    ) {
        didReceivedUpdates(from: session)
        delegate?.session(didReceiveUserInfo: userInfo)
    }
    
    public func session(
        _ session: WCSession,
        didFinish userInfoTransfer: WCSessionUserInfoTransfer,
        error: (any Error)?
    ) {
        didReceivedUpdates(from: session)
        delegate?.session(didFinish: .init(from: userInfoTransfer), error: error)
    }
}

