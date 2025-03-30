//
//  CommunicationUserInfo.swift
//
//
//  Created by Petter vang Brakalsvålet on 30/06/2024.
//

public enum CommunicationUserInfo: String, CaseIterable, Sendable {
    case session
    case messageData
    case activationState
    
    case day
    case drinks
    case unitSystem
    
    public var key: String { rawValue }
}
