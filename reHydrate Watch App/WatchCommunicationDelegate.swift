//
//  WatchCommunicationDelegate.swift
//  reHydrate Watch App
//
//  Created by Petter vang Brakalsvålet on 25/05/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import WatchConnectivity
import CommunicationKitInterface

final class WatchCommunicationDelegate: NSObject {
    private let notificationCenter: NotificationCenter
    
    init(session: WCSession, notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
        
        super.init()
        session.delegate = self
    }
}

extension WatchCommunicationDelegate: WCSessionDelegate {
    public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
        let userInfo: [CommunicationUserInfo: Any] = [.session: session, .activationState: activationState]
        notificationCenter.post(name: .Shared.activation, object: self, userInfo: userInfo)
    }
    
    public func sessionReachabilityDidChange(_ session: WCSession) {
        let userInfo: [CommunicationUserInfo: Any] = [.session: session]
        notificationCenter.post(name: .Shared.reachabilityDidChange, object: self, userInfo: userInfo)
    }
}

// MARK: Receive context/message/userInfo/data
extension WatchCommunicationDelegate {
    public func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        var userInfo: [String: Any] = applicationContext
        userInfo[CommunicationUserInfo.session.key] = session
        notificationCenter.post(name: .Shared.didReceiveApplicationContext, object: self, userInfo: userInfo)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        
        var userInfo: [String: Any] = message
        userInfo[CommunicationUserInfo.session.key] = session
        notificationCenter.post(name: .Shared.didReceiveMessage, object: self, userInfo: userInfo)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any],
        replyHandler: @escaping ([String : Any]) -> Void
    ) {
        var userInfo: [String: Any] = message
        userInfo[CommunicationUserInfo.session.key] = session
        notificationCenter.post(name: .Shared.didReceiveMessage, object: self, userInfo: userInfo)
        
        notificationCenter.addObserver(forName: .Shared.messageReplay, object: self, queue: .current) { notification in
            if let userInfo = notification.userInfo {
                let reply = userInfo.reduce(into: [:]) { (result, dictionary: (key: AnyHashable, value: Any)) in
                    result["\(dictionary.key)"] = dictionary.value
                }
                replyHandler(reply)
            }
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5) { [self] in
            notificationCenter.removeObserver(self, name: .Shared.messageReplay, object: nil)
        }
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessageData messageData: Data
    ) {
        let userInfo: [CommunicationUserInfo: Any] = [.session: session, .messageData: messageData]
        notificationCenter.post(name: .Shared.didReceiveMessageData, object: self, userInfo: userInfo)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessageData messageData: Data,
        replyHandler: @escaping (Data) -> Void
    ) {
        let userInfo: [CommunicationUserInfo: Any] = [.session: session, .messageData: messageData]
        notificationCenter.post(name: .Shared.didReceiveMessageData, object: self, userInfo: userInfo)
        notificationCenter.addObserver(forName: .Shared.messageDataReplay, object: self, queue: .current) { notification in
            if let data = notification.userInfo?[CommunicationUserInfo.messageData.key] as? Data {
                replyHandler(data)
            }
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5) { [self] in
            notificationCenter.removeObserver(self, name: .Shared.messageDataReplay, object: nil)
        }
    }
    
    public func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String : Any]
    ) {
        var userInfo: [String: Any] = userInfo
        userInfo[CommunicationUserInfo.session.key] = session
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: self, userInfo: userInfo)
    }
}
