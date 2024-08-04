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
    public var applicationContext: [CommunicationUserInfo : Any]
    public var receivedApplicationContext: [CommunicationUserInfo : Any]
    public var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool
    private let notificationCenter = NotificationCenter.default
    
    public init(session: WCSession) {
        self.session = session
        
        self.currentState = .init(from: session.activationState)
        self.isReachable = session.isReachable
        self.applicationContext = session.applicationContext.mapKeys()
        self.receivedApplicationContext = session.receivedApplicationContext.mapKeys()
        
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
    
    public func send(userInfo: [CommunicationUserInfo : Any]) -> CommunicationInfo {
        .init(from: session.transferUserInfo(userInfo.mapKeys()))
    }
}

extension WatchService {
    func addDelegateObservers() {
        notificationCenter.addObserver(forName: .Shared.activation,
                                       object: self, queue: .current,
                                       using: activationHandler)
        notificationCenter.addObserver(forName: .Shared.reachabilityDidChange,
                                       object: self, queue: .current,
                                       using: reachabilityDidChangeHandler)
        notificationCenter.addObserver(forName: .Shared.didReceiveApplicationContext,
                                       object: self, queue: .current,
                                       using: didReceiveApplicationContextHandler)
    }
    
    func removeDelegateObservers() {
        notificationCenter.removeObserver(self, name:.Shared.activation, object: nil)
        notificationCenter.removeObserver(self, name:.Shared.reachabilityDidChange, object: nil)
        notificationCenter.removeObserver(self, name:.Shared.didReceiveApplicationContext, object: nil)
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
        self.applicationContext = userInfo.mapKeys()
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
