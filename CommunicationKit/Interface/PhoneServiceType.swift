//
//  PhoneServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 06/05/2024.
//

import Foundation

public protocol PhoneServiceType {
    var currentState: CommunicationState { get set }
    var isReachable: Bool { get set }
    var applicationContext: [String : Any] { get set }
    var receivedApplicationContext: [String : Any] { get set }
    var isPaired: Bool { get set }
    var watchDirectoryUrl: URL? { get set }
    var isWatchAppInstalled: Bool { get set }
    var isComplicationEnabled: Bool { get set }
    var remainingComplicationUserInfoTransfers: Int { get set }
    
    func isSupported() -> Bool
    func activate()
    func update(applicationContext: [String : Any]) throws
    func send(message: [String : Any], replyHandler: (([String : Any]) -> Void)?, errorHandler: ((Error) -> Void)?)
    func send(messageData data: Data, replyHandler: ((Data) -> Void)?, errorHandler: ((Error) -> Void)?)
    func transferComplication(userInfo: [String : Any]) -> CommunicationInfo
    func transfer(userInfo: [String : Any]) -> CommunicationInfo
}
