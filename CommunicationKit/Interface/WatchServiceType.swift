//
//  WatchServiceType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import Foundation

public protocol WatchServiceType {
    var currentState: CommunicationState { get }
    var isReachable: Bool { get }
    var applicationContext: [CommunicationUserInfo : Any] { get }
    var receivedApplicationContext: [CommunicationUserInfo : Any] { get }
    var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool { get }
    
    func isSupported() -> Bool
    func activate()
    func update(applicationContext: [CommunicationUserInfo : Codable]) throws
    func send(message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?)
    func send(messageData data: Data, errorHandler: ((Error) -> Void)?)
    func send(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo
}
