//
//  CommunicationInfo.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import Foundation

public struct CommunicationInfo {
    /// Not used by watchOS
    public let isCurrentComplicationInfo: Bool
    public let userInfo: [String : Any]
    public let isTransferring: Bool
    public let cancel: () -> Void
    
    public init(
        isCurrentComplicationInfo: Bool,
        userInfo: [String : Any],
        isTransferring: Bool,
        cancel: @escaping () -> Void
    ) {
        self.isCurrentComplicationInfo = isCurrentComplicationInfo
        self.userInfo = userInfo
        self.isTransferring = isTransferring
        self.cancel = cancel
    }
}
