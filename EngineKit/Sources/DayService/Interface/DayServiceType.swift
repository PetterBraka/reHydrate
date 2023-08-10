//
//  ConsumptionServiceType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import DrinkServiceInterface

public protocol DayServiceType {
    func getToday() async -> Day
    func add(drink: Drink) -> Double
    func remove(drink: Drink) -> Double
}
