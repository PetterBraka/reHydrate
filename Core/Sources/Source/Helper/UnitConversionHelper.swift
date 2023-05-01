//
//  UnitConversionHelper.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import CoreInterfaceKit

final class UnitConversionHelper {
    static func getLocal(_ day: Day, inMetric: Bool) -> (consumtion: Double, goal: Double) {
        let consumed = day.consumption.convert(
            to: inMetric ? .liters : .imperialPints,
            from: .liters
        )
        let goal = day.goal.convert(
            to: inMetric ? .liters : .imperialPints,
            from: .liters
        )
        return (consumed, goal)
    }

    static func getLocal(_ drink: Drink,
                         withUnit symbol: Bool,
                         inMetric: Bool) -> String {
        let unit: UnitVolume = inMetric ? .milliliters : .imperialPints

        let drinkValue = drink.size.convert(
            to: unit, from: .milliliters
        )
        return drinkValue.clean + (symbol ? unit.symbol : "")
    }
}
