//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 06/05/2024.
//

import Foundation
import CommunicationKitInterface

extension Int {
    static let `default`: Self = 0
}

extension Bool {
    static let `default`: Self = false
}

extension Optional where Wrapped == URL {
    static let `default`: Self = nil
}

extension Dictionary where Key == CommunicationUserInfo, Value == Any {
    static let `default`: Self = [:]
}

extension CommunicationState {
    static let `default`: Self = .unknown
}

extension CommunicationInfo {
    static let `default`: Self = .init(isCurrentComplicationInfo: false, userInfo: [:], isTransferring: false) {}
}
