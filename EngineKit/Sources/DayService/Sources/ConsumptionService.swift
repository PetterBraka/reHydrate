//
//  ConsumptionService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import DayServiceInterface
import DrinkServiceInterface
import DrinkService

public final class ConsumptionService: ConsumptionServiceType {
    private var day = Day(date: .now,
                          consumed: 0,
                          goal: 3)
    
    public init() {}
    
    public func add(drink: Drink) -> Double {
        day.consumed += UnitHelper.drinkToLiters(drink)
        return day.consumed
    }
    
    public func remove(drink: Drink) -> Double {
        day.consumed -= UnitHelper.drinkToLiters(drink)
        if day.consumed < 0 {
            day.consumed = 0
        }
        return day.consumed
    }
}
