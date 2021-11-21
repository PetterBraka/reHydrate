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
    
    enum type {
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
    }
    
    var type: type
    var size: Int
}
