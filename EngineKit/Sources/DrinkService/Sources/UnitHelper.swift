//
//  UnitHelper.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import DrinkServiceInterface
import Foundation

public final class UnitHelper {
    public static func drinkToLiters(_ drink: Drink) -> Double {
        let drinkSize = Measurement(value: drink.size, unit: UnitVolume.milliliters)
        return drinkSize.converted(to: UnitVolume.liters).value
    }
}
