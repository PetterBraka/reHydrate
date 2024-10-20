//
//  PhoneService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 06/05/2024.
//

import WatchConnectivity
import CommunicationKitInterface

public final class PhoneService: NSObject, PhoneServiceType {
    private var session: WCSession
    
    public var currentState: CommunicationState {
        .init(from: session.activationState)
    }
    public var isReachable: Bool {
        session.isReachable
    }
    public var applicationContext: [CommunicationUserInfo : Any] {
        session.applicationContext.mapKeys()
    }
    public var receivedApplicationContext: [CommunicationUserInfo : Any] {
        session.receivedApplicationContext.mapKeys()
    }
    public var remainingComplicationUserInfoTransfers: Int {
#if os(watchOS)
        0
#else
        session.remainingComplicationUserInfoTransfers
#endif
    }
    
    public var isPaired: Bool {
#if os(watchOS)
        false
#else
        session.isPaired
#endif
    }
    public var watchDirectoryUrl: URL? {
#if os(watchOS)
        nil
#else
        session.watchDirectoryURL
#endif
    }
    public var isWatchAppInstalled: Bool {
#if os(watchOS)
        false
#else
        session.isWatchAppInstalled
#endif
    }
    public var isComplicationEnabled: Bool {
#if os(watchOS)
        false
#else
        session.isComplicationEnabled
#endif
    }
    
    public init(session: WCSession) {
        self.session = session
        
        super.init()
    }
}

extension PhoneService {
    public func isSupported() -> Bool {
        WCSession.isSupported()
    }
    
    public func activate() {
        session.activate()
    }
    
    public func update(applicationContext: [CommunicationUserInfo : Codable]) throws {
        try session.updateApplicationContext(applicationContext.mapKeys())
    }
    
    public func sendMessage(
        _ message: [CommunicationUserInfo : Codable],
        errorHandler: ((any Error) -> Void)? = nil
    ) {
        session.sendMessage(message.mapKeys(), replyHandler: nil, errorHandler: errorHandler)
    }
    
    public func sendData(
        _ data: Data,
        errorHandler: ((any Error) -> Void)? = nil
    ) {
        session.sendMessageData(data, replyHandler: nil, errorHandler: errorHandler)
    }
    
    public func transferComplication(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
#if os(watchOS)
        .init(isCurrentComplicationInfo: false, userInfo: [:], isTransferring: false) {}
#else
        .init(from: session.transferCurrentComplicationUserInfo(userInfo.mapKeys()))
#endif
    }
    
    public func transfer(userInfo: [CommunicationUserInfo : Codable]) -> CommunicationInfo {
#if os(watchOS)
        .init(isCurrentComplicationInfo: false, userInfo: [:], isTransferring: false) {}
#else
        .init(from: session.transferUserInfo(userInfo.mapKeys()))
#endif
    }
}

fileprivate extension CommunicationInfo {
#if os(iOS)
    init(from info: WCSessionUserInfoTransfer) {
        self.init(
            isCurrentComplicationInfo: info.isCurrentComplicationInfo,
            userInfo: info.userInfo,
            isTransferring: info.isTransferring,
            cancel: info.cancel
        )
    }
#endif
}

fileprivate extension Dictionary where Key == CommunicationUserInfo, Value == Codable {
    func mapKeys() -> [String: Data]{
        reduce(into: [String: Data]()) { partialResult, element in
            let encoder = JSONEncoder()
            partialResult[element.key.rawValue] = try? encoder.encode(element.value)
        }
    }
}

fileprivate extension Dictionary where Key == String {
    func mapKeys() -> [CommunicationUserInfo: Any]{
        reduce(into: [CommunicationUserInfo: Any]()) { partialResult, element in
            guard let key = CommunicationUserInfo(rawValue: element.key) else { return }
            partialResult[key] = element.value
        }
    }
}

fileprivate extension Dictionary where Key == AnyHashable {
    func mapKeys() -> [CommunicationUserInfo: Any]{
        reduce(into: [CommunicationUserInfo: Any]()) { partialResult, element in
            guard let key = CommunicationUserInfo(rawValue: "\(element.key)") else { return }
            partialResult[key] = element.value
        }
    }
}

extension CommunicationState {
    public init(from state: WCSessionActivationState) {
        switch state {
        case .activated: self = .activated
        case .inactive: self = .inactive
        case .notActivated: self = .notActivated
        @unknown default: self = .unknown
        }
    }
}
