//
//  CommunicationInfo.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import Foundation
import WatchConnectivity

#if os(iOS)
public struct CommunicationInfo {
    var isCurrentComplicationInfo: Bool
    var userInfo: [String : Any]
    var isTransferring: Bool
    
    public init(
        isCurrentComplicationInfo: Bool,
        userInfo: [String : Any],
        isTransferring: Bool
    ) {
        self.isCurrentComplicationInfo = isCurrentComplicationInfo
        self.userInfo = userInfo
        self.isTransferring = isTransferring
    }
}
#endif

#if os(watchOS)
public struct CommunicationInfo {
    var userInfo: [String : Any]
    var isTransferring: Bool
    
    init(
        userInfo: [String : Any],
        isTransferring: Bool
    ) {
        self.userInfo = userInfo
        self.isTransferring = isTransferring
    }
}
#endif

extension CommunicationInfo {
    public init(from info: WCSessionUserInfoTransfer) {
        #if os(iOS)
        self.init(
            isCurrentComplicationInfo: info.isCurrentComplicationInfo,
            userInfo: info.userInfo,
            isTransferring: info.isTransferring
        )
        #else
        self.init(
            userInfo: info.userInfo,
            isTransferring: info.isTransferring
        )
        #endif
    }
}
