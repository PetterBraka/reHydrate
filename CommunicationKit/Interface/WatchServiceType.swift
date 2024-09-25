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
    func sendMessage(_ message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?)
    func sendData(_ data: Data, errorHandler: ((Error) -> Void)?)
    func sendUserInfo(_ userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo
}
