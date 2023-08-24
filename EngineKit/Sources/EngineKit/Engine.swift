//
//  Engine.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/06/2023.
//

import Foundation
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
        let appGroup = "group.com.braka.reHydrate.shared"
        guard let sharedDefault = UserDefaults(suiteName: appGroup)
        else {
            fatalError("Shared UserDefaults couldn't be setup")
        }
        database = Database()
        dayManager = DayManager(database: database)
        consumptionManager = ConsumptionManager(database: database)
        userPreferenceService = UserPreferenceService(defaults: sharedDefault)
    }
    
    public var database: DatabaseType
    public var dayManager: DayManagerType
    public var consumptionManager: ConsumptionManagerType
    public var userPreferenceService: UserPreferenceServiceType
    
    public lazy var drinksService: DrinkServiceType = DrinkService()
    public lazy var languageService: LanguageServiceType = LanguageService()
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
}

extension Engine: HasService {}
