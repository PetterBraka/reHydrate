//
//  DrinkProtocol.swift
//
//
//  Created by Petter vang Brakalsvålet on 01/05/2023.
//

import Foundation

public protocol DrinkProtocol: Identifiable, Hashable {
    var id: UUID { get }
    var type: DrinkType { get }
    var size: Double { get set }
    var fill: Double { get }
}

public enum DrinkType: Hashable {
    case small
    case medium
    case large

    public var max: Int {
        switch self {
        case .small: return 400
        case .medium: return 700
        case .large: return 1200
        }
    }

    public var min: Int {
        switch self {
        case .small: return 100
        case .medium: return 300
        case .large: return 500
        }
    }
}
