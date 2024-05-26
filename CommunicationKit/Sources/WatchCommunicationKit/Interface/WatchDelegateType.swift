//
//  WatchDelegateType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import Foundation

public protocol WatchDelegateType {
    func session(activationDidCompleteWith activationState: CommunicationState, error: Error?)
    func sessionCompanionAppInstalledDidChange()
    func sessionReachabilityDidChange()

    func session(didReceiveApplicationContext applicationContext: [String : Any])

    func session(didReceiveMessage message: [String : Any])
    func session(didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void)

    func session(didReceiveMessageData messageData: Data)
    func session(didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void)

    func session(didReceiveUserInfo userInfo: [String : Any])
    func session(didFinish communicationInfo: CommunicationInfo, error: Error?)
}

extension Notification.Name {
    public enum Watch {
        public static let activation = Notification.Name("sessionActivationDidComplete")
        public static let didFinishTransfer = Notification.Name("sessionDidFinish")
        
        public static let companionAppInstalledDidChange = Notification.Name("sessionCompanionAppInstalledDidChange")
        public static let reachabilityDidChange = Notification.Name("sessionReachabilityDidChange")
        public static let didReceiveApplicationContext = Notification.Name("sessionDidReceiveApplicationContext")
        public static let didReceiveMessage = Notification.Name("sessionDidReceiveMessage")
        public static let messageReplay = Notification.Name("messageReplay")
        public static let didReceiveMessageData = Notification.Name("sessionDidReceiveMessageData")
        public static let messageDataReplay = Notification.Name("messageDataReplay")
        public static let didReceiveUserInfo = Notification.Name("sessionDidReceiveUserInfo")
    }
}
