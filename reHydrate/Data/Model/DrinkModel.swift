//
//  DrinkModel.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import Foundation
import CoreInterfaceKit

extension DrinkModel: DomainMappable {
    public func toDomainModel() -> Drink {
        let drinkOption: DrinkType
        switch Int(size) {
        case DrinkType.small.min ... DrinkType.small.max:
            drinkOption = .small
        case DrinkType.medium.min ... DrinkType.medium.max:
            drinkOption = .medium
        case DrinkType.large.min ... DrinkType.large.max:
            drinkOption = .large
        default:
            drinkOption = .medium
        }
        return Drink(id: id ?? UUID(),
                     type: drinkOption,
                     size: size)
    }
    
    public func update(with item: Drink) {
        id = item.id
        size = item.size
    }
}
