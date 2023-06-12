//
//  ConsumptionServiceType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import DrinkServiceInterface

public protocol ConsumptionServiceType {
    func add(drink: Drink) -> Double
    func remove(drink: Drink) -> Double
}
