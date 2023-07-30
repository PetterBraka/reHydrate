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
import DatabaseServiceInterface
import DatabaseService

public final class Engine {
    public init() {}
    
    private let database = Database()
    
    public lazy var consumptionService: ConsumptionServiceType = ConsumptionService()
    public lazy var drinksService: DrinkServiceType = DrinkService()
    public lazy var dayManager: DayManagerType = DayManager(database: database)
}

extension Engine: HasService {}
