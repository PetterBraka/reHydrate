//
//  ConsumptionService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import DayServiceInterface

final class ConsumptionService: ConsumptionServiceType {
    private var day = Day(date: .now,
                          consumed: 0,
                          goal: 3)
    
    func add(drink: Drink) {
        day.consumed += UnitHelper.drinkToLiters(drink)
    }
    
    func remove(drink: Drink) {
        day.consumed -= UnitHelper.drinkToLiters(drink)
    }
}
