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
    var applicationContext: [CommunicationUserInfo : Any] { get set }
    var receivedApplicationContext: [CommunicationUserInfo : Any] { get set }
    var isPaired: Bool { get set }
    var watchDirectoryUrl: URL? { get set }
    var isWatchAppInstalled: Bool { get set }
    var isComplicationEnabled: Bool { get set }
    var remainingComplicationUserInfoTransfers: Int { get set }
    
    func isSupported() -> Bool
    func activate()
    func update(applicationContext: [CommunicationUserInfo : Any]) throws
    func send(message: [CommunicationUserInfo : Any], errorHandler: ((Error) -> Void)?)
    func send(messageData data: Data, errorHandler: ((Error) -> Void)?)
    func transferComplication(userInfo: [CommunicationUserInfo : Any]) -> CommunicationInfo
    func transfer(userInfo: [CommunicationUserInfo : Any]) -> CommunicationInfo
}
