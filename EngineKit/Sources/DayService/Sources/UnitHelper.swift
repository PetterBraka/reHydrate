//
//  UnitHelper.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import DayServiceInterface
import Foundation

final class UnitHelper {
    static func drinkToLiters(_ drink: Drink) -> Double {
        let drinkSize = Measurement(value: drink.size, unit: UnitVolume.milliliters)
        return drinkSize.converted(to: UnitVolume.liters).value
    }
}
