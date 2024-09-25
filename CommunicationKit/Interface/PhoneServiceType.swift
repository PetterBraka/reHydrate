//
//  PhoneServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 06/05/2024.
//

import Foundation

public protocol PhoneServiceType {
    var currentState: CommunicationState { get }
    var isReachable: Bool { get }
    var applicationContext: [CommunicationUserInfo : Any] { get }
    var receivedApplicationContext: [CommunicationUserInfo : Any] { get }
    var remainingComplicationUserInfoTransfers: Int { get }
    var isPaired: Bool { get }
    var watchDirectoryUrl: URL? { get }
    var isWatchAppInstalled: Bool { get }
    var isComplicationEnabled: Bool { get }
    
    func isSupported() -> Bool
    func activate()
    func update(applicationContext: [CommunicationUserInfo : Codable]) throws
    func sendMessage(_ message: [CommunicationUserInfo : Codable], errorHandler: ((Error) -> Void)?)
    func sendData(_ data: Data, errorHandler: ((Error) -> Void)?)
    func transferComplication(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo
    func transfer(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo
}
