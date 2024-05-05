//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/05/2024.
//

import WatchConnectivity

public enum CommunicationState: Sendable {
    case activated
    case inactive
    case notActivated
    case unowned
}

extension CommunicationState {
    public init(from state: WCSessionActivationState) {
        switch state {
        case .activated: self = .activated
        case .inactive: self = .inactive
        case .notActivated: self = .notActivated
        @unknown default: self = .unowned
        }
    }
}
