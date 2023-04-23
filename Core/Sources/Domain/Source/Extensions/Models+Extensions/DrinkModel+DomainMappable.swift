//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 23/04/2023.
//

import Data
import DataInterface
import DomainInterface

extension DrinkModel: DomainMappable {
    public func toDomainModel() throws -> Drink {
        guard let id
        else {
            throw MappingError.proppertyWasNil
        }
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
        return Drink(id: id,
                     type: drinkOption,
                     size: size)
    }
    
    public func update(with item: Drink) {
        id = item.id
        size = item.size
    }
}
