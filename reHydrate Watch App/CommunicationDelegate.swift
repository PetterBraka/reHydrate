//
//  CommunicationDelegate.swift
//  reHydrate Watch App
//
//  Created by Petter vang Brakalsvålet on 25/05/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import WatchConnectivity
import CommunicationKitInterface

final class CommunicationDelegate: NSObject, WCSessionDelegate {
    private let notificationCenter: NotificationCenter
    
    init(session: WCSession, notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
        
        super.init()
        session.delegate = self
    }
}

extension CommunicationDelegate {
    public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
        let userInfo: [CommunicationUserInfo: Any] = [.session: session, .activationState: activationState]
        notificationCenter.post(name: .Watch.activation, object: self, userInfo: userInfo)
    }
    
    public func sessionReachabilityDidChange(_ session: WCSession) {
        let userInfo: [CommunicationUserInfo: Any] = [.session: session]
        notificationCenter.post(name: .Watch.reachabilityDidChange, object: self, userInfo: userInfo)
    }
}

// MARK: Receive context/message/userInfo/data
extension CommunicationDelegate {
    public func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        var userInfo: [String: Any] = applicationContext
        userInfo[CommunicationUserInfo.session.key] = session
        notificationCenter.post(name: .Watch.didReceiveApplicationContext, object: self, userInfo: userInfo)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        
        var userInfo: [String: Any] = message
        userInfo[CommunicationUserInfo.session.key] = session
        notificationCenter.post(name: .Watch.didReceiveMessage, object: self, userInfo: userInfo)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any],
        replyHandler: @escaping ([String : Any]) -> Void
    ) {
        var userInfo: [String: Any] = message
        userInfo[CommunicationUserInfo.session.key] = session
        notificationCenter.post(name: .Watch.didReceiveMessage, object: self, userInfo: userInfo)
        
        notificationCenter.addObserver(forName: .Watch.messageReplay, object: self, queue: .current) { notification in
            if let userInfo = notification.userInfo {
                let reply = userInfo.reduce(into: [:]) { (result, dictionary: (key: AnyHashable, value: Any)) in
                    result["\(dictionary.key)"] = dictionary.value
                }
                replyHandler(reply)
            }
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5) { [self] in
            notificationCenter.removeObserver(self, name: .Watch.messageReplay, object: nil)
        }
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessageData messageData: Data
    ) {
        let userInfo: [CommunicationUserInfo: Any] = [.session: session, .messageData: messageData]
        notificationCenter.post(name: .Watch.didReceiveMessageData, object: self, userInfo: userInfo)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessageData messageData: Data,
        replyHandler: @escaping (Data) -> Void
    ) {
        let userInfo: [CommunicationUserInfo: Any] = [.session: session, .messageData: messageData]
        notificationCenter.post(name: .Watch.didReceiveMessageData, object: self, userInfo: userInfo)
        notificationCenter.addObserver(forName: .Watch.messageDataReplay, object: self, queue: .current) { notification in
            if let data = notification.userInfo?[CommunicationUserInfo.messageData.key] as? Data {
                replyHandler(data)
            }
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5) { [self] in
            notificationCenter.removeObserver(self, name: .Watch.messageDataReplay, object: nil)
        }
    }
    
    public func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String : Any]
    ) {
        var userInfo: [String: Any] = userInfo
        userInfo[CommunicationUserInfo.session.key] = session
        notificationCenter.post(name: .Watch.didReceiveUserInfo, object: self, userInfo: userInfo)
    }
}
