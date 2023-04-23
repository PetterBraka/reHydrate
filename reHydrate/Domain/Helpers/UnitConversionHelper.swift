//
//  UnitConversionHelper.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

final class UnitConversionHelper {
    static func getLocal(_ day: Day) -> (consumtion: Double, goal: Double) {
        let settingRepo: SettingsRepository = MainAssembler.resolve()
        let isMetric = settingRepo.isMetric

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
                         withUnit symbol: Bool) -> String {
        let settingRepo: SettingsRepository = MainAssembler.resolve()
        let isMetric = settingRepo.isMetric
        let toUnit: UnitVolume = isMetric ? .milliliters : .imperialPints

        let drinkValue = drink.size.convert(
            to: toUnit, from: .milliliters
        )
        return drinkValue.clean + (symbol ? toUnit.symbol : "")
    }
}
