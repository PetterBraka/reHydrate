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
import LanguageServiceInterface
import LanguageService
import DatabaseServiceInterface
import DatabaseService
import UnitServiceInterface
import UnitService

public final class Engine {
    public init() {
        database = Database()
        dayManager = DayManager(database: database)
        consumptionManager = ConsumptionManager(database: database)
    }
    
    public var database: DatabaseType
    public var dayManager: DayManagerType
    public var consumptionManager: ConsumptionManagerType
    
    public lazy var drinksService: DrinkServiceType = DrinkService()
    public lazy var languageService: LanguageServiceType = LanguageService()
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
}

extension Engine: HasService {}
