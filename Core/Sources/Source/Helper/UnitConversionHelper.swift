//
//  UnitConversionHelper.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import CoreInterfaceKit
import Foundation

public enum UnitConversionHelper {
    public static func getLocal(_ day: any DayProtocol,
                                inMetric: Bool) -> (consumtion: Double, goal: Double)
    {
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

    public static func getLocal(_ drink: any DrinkProtocol,
                                withUnit symbol: Bool,
                                inMetric: Bool) -> String
    {
        let unit: UnitVolume = inMetric ? .milliliters : .imperialPints

        let drinkValue = drink.size.convert(
            to: unit, from: .milliliters
        )
        return drinkValue.clean + (symbol ? unit.symbol : "")
    }
}
