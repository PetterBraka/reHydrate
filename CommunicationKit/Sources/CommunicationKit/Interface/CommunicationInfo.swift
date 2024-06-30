//
//  CommunicationInfo.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import Foundation

public struct CommunicationInfo {
    /// Not used by watchOS
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
