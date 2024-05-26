//
//  CommunicationDelegate.swift
//  reHydrate Watch App
//
//  Created by Petter vang Brakalsvålet on 25/05/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import WatchConnectivity

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
        let userInfo = ["state": activationState]
        notificationCenter.post(name: .Watch.activation, object: self, userInfo: userInfo)
    }
    
    public func sessionCompanionAppInstalledDidChange(_ session: WCSession) {
        notificationCenter.post(name: .Watch.companionAppInstalledDidChange, object: self, userInfo: nil)
    }
    
    public func sessionReachabilityDidChange(_ session: WCSession) {
        notificationCenter.post(name: .Watch.reachabilityDidChange, object: self, userInfo: nil)
    }
}

// MARK: Receive context/message/userInfo/data
extension CommunicationDelegate {
    public func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        notificationCenter.post(name: .Watch.didReceiveApplicationContext, object: self, userInfo: applicationContext)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        notificationCenter.post(name: .Watch.didReceiveMessage, object: self, userInfo: message)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any],
        replyHandler: @escaping ([String : Any]) -> Void
    ) {
        notificationCenter.post(name: .Watch.didReceiveMessage, object: self, userInfo: message)
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
        let userInfo = ["data" : messageData]
        notificationCenter.post(name: .Watch.didReceiveMessageData, object: self, userInfo: userInfo)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessageData messageData: Data,
        replyHandler: @escaping (Data) -> Void
    ) {
        let userInfo = ["data" : messageData]
        notificationCenter.post(name: .Watch.didReceiveMessageData, object: self, userInfo: userInfo)
        notificationCenter.addObserver(forName: .Watch.messageDataReplay, object: self, queue: .current) { notification in
            if let data = notification.userInfo?["data"] as? Data {
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
        notificationCenter.post(name: .Watch.didReceiveUserInfo, object: self, userInfo: userInfo)
    }
    
    public func session(
        _ session: WCSession,
        didFinish userInfoTransfer: WCSessionUserInfoTransfer,
        error: (any Error)?
    ) {
        let userInfo = if let error {
            ["error" : error]
        } else {
            [:]
        }
        notificationCenter.post(name: .Watch.didFinishTransfer, object: self, userInfo: userInfo)
    }
}
