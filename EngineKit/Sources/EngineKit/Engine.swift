//
//  Engine.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/06/2023.
//

import Foundation
import LoggingService
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
import UserPreferenceServiceInterface
import UserPreferenceService

public final class Engine {
    public init() {
        let project = "reHydrate"
        let appGroup = "group.com.braka.reHydrate.shared"
        guard let sharedDefault = UserDefaults(suiteName: appGroup)
        else {
            fatalError("Shared UserDefaults couldn't be setup")
        }
        logger = LoggingService(subsystem: project)
        database = Database(logger: logger)
        dayManager = DayManager(database: database)
        consumptionManager = ConsumptionManager(database: database)
        userPreferenceService = UserPreferenceService(defaults: sharedDefault)
    }
    
    public var logger: LoggingService
    public var database: DatabaseType
    public var dayManager: DayManagerType
    public var consumptionManager: ConsumptionManagerType
    public var userPreferenceService: UserPreferenceServiceType
    
    public lazy var drinksService: DrinkServiceType = DrinkService()
    public lazy var languageService: LanguageServiceType = LanguageService(engine: self)
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
}

extension Engine: HasService {}
