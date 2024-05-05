//
//  WatchDelegateType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import Foundation

public protocol WatchDelegateType {
    func session(activationDidCompleteWith activationState: CommunicationState, error: Error?)

#if os(iOS)
    func sessionDidDeactivate()
    func sessionDidBecomeInactive()
    func sessionWatchStateDidChange()
#endif
#if os(watchOS)
    func sessionCompanionAppInstalledDidChange()
#endif
    func sessionReachabilityDidChange()

    func session(didReceiveApplicationContext applicationContext: [String : Any])

    func session(didReceiveMessage message: [String : Any])
    func session(didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void)

    func session(didReceiveMessageData messageData: Data)
    func session(didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void)

    func session(didReceiveUserInfo userInfo: [String : Any])
    func session(didFinish communicationInfo: CommunicationInfo, error: Error?)
}
