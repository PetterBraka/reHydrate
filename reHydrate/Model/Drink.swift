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

    enum Option {
        case small
        case medium
        case large

        func getImage() -> Image {
            switch self {
            case .small: return Image.cup
            case .medium: return Image.bottle
            case .large: return Image.largeBottle
            }
        }

        func getMax() -> Int {
            switch self {
            case .small: return 400
            case .medium: return 700
            case .large: return 1200
            }
        }

        func getMin() -> Int {
            switch self {
            case .small: return 100
            case .medium: return 300
            case .large: return 500
            }
        }
    }

    var type: Option?
    var size: Double
}
