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
    
    public var currentState: CommunicationState
    public var isReachable: Bool
    public var applicationContext: [String : Any]
    public var receivedApplicationContext: [String : Any]
    public var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool
    private let notificationCenter = NotificationCenter.default
    
    public init(session: WCSession) {
        self.session = session
        
        self.currentState = .init(from: session.activationState)
        self.isReachable = session.isReachable
        self.applicationContext = session.applicationContext
        self.receivedApplicationContext = session.receivedApplicationContext
        
        self.iOSDeviceNeedsUnlockAfterRebootForReachability = false
        
        super.init()
        self.didReceivedUpdates(from: session)
        self.addDelegateObservers()
    }
    
    deinit {
        self.removeDelegateObservers()
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
    
    public func send(userInfo: [String : Any]) -> CommunicationInfo {
        .init(from: session.transferUserInfo(userInfo))
    }
}

extension WatchService {
    func addDelegateObservers() {
        notificationCenter.addObserver(forName: .Watch.activation,
                                       object: self, queue: .current,
                                       using: activationHandler)
        notificationCenter.addObserver(forName: .Watch.reachabilityDidChange,
                                       object: self, queue: .current,
                                       using: reachabilityDidChangeHandler)
        notificationCenter.addObserver(forName: .Watch.didReceiveApplicationContext,
                                       object: self, queue: .current,
                                       using: didReceiveApplicationContextHandler)
    }
    
    func removeDelegateObservers() {
        notificationCenter.removeObserver(self, name:.Watch.activation, object: nil)
        notificationCenter.removeObserver(self, name:.Watch.reachabilityDidChange, object: nil)
        notificationCenter.removeObserver(self, name:.Watch.didReceiveApplicationContext, object: nil)
    }
    
    func activationHandler(_ notification: Notification) {
        guard let state = notification.userInfo?["activationState"] as? WCSessionActivationState else { return }
        self.currentState = .init(from: state)
    }
    
    func reachabilityDidChangeHandler(_ notification: Notification) {
        guard let session = notification.userInfo?["session"] as? WCSession else { return }
        self.isReachable = session.isReachable
    }
    
    func didReceiveApplicationContextHandler(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        self.applicationContext = userInfo.mapKeyToString()
    }
}

extension Dictionary where Key == AnyHashable {
    func mapKeyToString() -> Dictionary<String, Value> {
        reduce(into: [:]) { (partialResult, dictionary) in
            partialResult["\(dictionary.key)"] = dictionary.value
        }
    }
}
