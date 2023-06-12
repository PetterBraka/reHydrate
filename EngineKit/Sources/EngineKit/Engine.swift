//
//  Engine.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/06/2023.
//

import DayServiceInterface
import DayService
import DrinkServiceInterface
import DrinkService

public final class Engine {
    public init() {}
    
    public lazy var consumptionService: ConsumptionServiceType = ConsumptionService()
    public lazy var drinksService: DrinkServiceType = DrinkService()
}

extension Engine: HasService {}
