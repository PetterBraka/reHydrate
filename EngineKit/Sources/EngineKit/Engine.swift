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
    
    public init() {}
    
    public lazy var database: DatabaseType = Database()
    public lazy var dayManager: DayManagerType = DayManager(database: database)
    
    public lazy var consumptionService: ConsumptionServiceType = ConsumptionService(engine: self)
    public lazy var drinksService: DrinkServiceType = DrinkService()
    public lazy var languageService: LanguageServiceType = LanguageService()
}

extension Engine: HasService {}
