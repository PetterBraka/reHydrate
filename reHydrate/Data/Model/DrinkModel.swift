//
//  DrinkModel.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import Foundation

extension DrinkModel: DomainMappable {
    func toDomainModel() -> Drink {
        let drinkOption: Drink.Option
        switch Int(size) {
        case Drink.Option.small.min ... Drink.Option.small.max:
            drinkOption = .small
        case Drink.Option.medium.min ... Drink.Option.medium.max:
            drinkOption = .medium
        case Drink.Option.large.min ... Drink.Option.large.max:
            drinkOption = .large
        default:
            drinkOption = .medium
        }
        return Drink(id: id ?? UUID(),
                     type: drinkOption,
                     size: size)
    }

    func updateCoreDataModel(_ drink: Drink) {
        id = drink.id
        size = drink.size
    }
}
