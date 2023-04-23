//
//  UnitConversionHelper.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import DomainInterface

final class UnitConversionHelper {
    static func getLocal(_ day: Day,
                         settingsRepo: SettingsRepository)
    -> (consumtion: Double, goal: Double) {
        let isMetric = settingsRepo.isMetric

        let consumed = day.consumption.convert(
            to: isMetric ? .liters : .imperialPints,
            from: .liters
        )
        let goal = day.goal.convert(
            to: isMetric ? .liters : .imperialPints,
            from: .liters
        )
        return (consumed, goal)
    }

    static func getLocal(_ drink: Drink,
                         withUnit symbol: Bool,
                         settingsRepo: SettingsRepository) -> String {
        let isMetric = settingsRepo.isMetric
        let toUnit: UnitVolume = isMetric ? .milliliters : .imperialPints

        let drinkValue = drink.size.convert(
            to: toUnit, from: .milliliters
        )
        return drinkValue.clean + (symbol ? toUnit.symbol : "")
    }
}
