//
//  WatchServiceType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import Foundation

public protocol WatchServiceType {
    var currentState: CommunicationState { get set }
    var isReachable: Bool { get set }
    var applicationContext: [CommunicationUserInfo : Any] { get set }
    var receivedApplicationContext: [CommunicationUserInfo : Any] { get set }
    var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool { get set }
    
    func isSupported() -> Bool
    func activate()
    func update(applicationContext: [CommunicationUserInfo : Any]) throws
    func send(message: [CommunicationUserInfo : Any], errorHandler: ((Error) -> Void)?)
    func send(messageData data: Data, errorHandler: ((Error) -> Void)?)
    func send(userInfo: [CommunicationUserInfo : Any]) -> CommunicationInfo
}
