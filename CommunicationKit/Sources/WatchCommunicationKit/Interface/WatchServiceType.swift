//
//  WatchServiceType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import Foundation

public protocol WatchServiceType {
    var delegate: WatchDelegateType? { get set }
    var currentState: CommunicationState { get set }
    var isReachable: Bool { get set }
    var applicationContext: [String : Any] { get set }
    var receivedApplicationContext: [String : Any] { get set }
    
    var isCompanionAppInstalled: Bool { get set }
    var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool { get set }
    
    func isSupported() -> Bool
    func activate()
    func update(applicationContext: [String : Any]) throws
    func send(message: [String : Any], replyHandler: (([String : Any]) -> Void)?, errorHandler: ((Error) -> Void)?)
    func send(messageData data: Data, replyHandler: ((Data) -> Void)?, errorHandler: ((Error) -> Void)?)
    func transfer(userInfo: [String : Any]) -> CommunicationInfo
}
