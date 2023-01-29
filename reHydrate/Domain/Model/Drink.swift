//
//  Drink.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct Drink: Identifiable, Hashable {
    var id = UUID()

    var type: Option
    var size: Double

    var fill: Double {
        size / Double(type.max)
    }
    
    enum Option {
        case small
        case medium
        case large

        func getImage(with fill: Double) -> Image {
            switch self {
            case .small: return .getGlass(with: fill)
            case .medium: return .getBottle(with: fill)
            case .large: return .getReusableBottle(with: fill)
            }
        }

        var max: Int {
            switch self {
            case .small: return 400
            case .medium: return 700
            case .large: return 1200
            }
        }

        var min: Int {
            switch self {
            case .small: return 100
            case .medium: return 300
            case .large: return 500
            }
        }
    }
}
