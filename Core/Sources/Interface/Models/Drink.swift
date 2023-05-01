//
//  Drink.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

public struct Drink: Identifiable, Hashable {
    public let id: UUID

    public let type: Option
    public var size: Double

    public var fill: Double {
        size / Double(type.max)
    }
    
    public init(id: UUID = UUID(),
                type: Option,
                size: Double) {
        self.id = id
        self.type = type
        self.size = size
    }

    public enum Option {
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
}
