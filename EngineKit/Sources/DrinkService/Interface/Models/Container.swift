//
//  Container.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

public enum Container: String, Codable {
    case small
    case medium
    case large
    
    case health
    
    public var rawValue: String {
        switch self {
        case .small:
            "small"
        case .medium:
            "medium"
        case .large:
            "large"
        case .health:
            "health"
        }
    }
}
