//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import Foundation
import DrinkServiceInterface

extension Drink {
    static let `default` = Drink(id: UUID().uuidString, size: -999, container: .small)
}

extension Array where Element == Drink {
    static let `default` = [Drink.default]
}
