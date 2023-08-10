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

public final class Engine {
    
    public init() {
        database = Database()
        dayManager = DayManager(database: database)
    }
    
    public let database: DatabaseType
    public let dayManager: DayManagerType
    
    public lazy var consumptionService: ConsumptionServiceType = ConsumptionService(engine: self)
    public lazy var drinksService: DrinkServiceType = DrinkService()
    public lazy var languageService: LanguageServiceType = LanguageService()
    public lazy var dayService: DayServiceType = DayService(engine: self)
}

extension Engine: HasService {}
