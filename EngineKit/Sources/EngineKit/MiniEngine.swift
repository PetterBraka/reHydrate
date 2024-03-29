//
//  File.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//

import Foundation
import LoggingService
import UnitServiceInterface
import UnitService
import UserPreferenceServiceInterface
import UserPreferenceService
import DateServiceInterface
import DateService
import DrinkServiceInterface
import DrinkService
import DayServiceInterface
import DayService
import DBKitInterface
import DBKit

// The Mini engine is intended for app extensions (Watch & Widgets)
public final class MiniEngine {
    private let sharedDefaults: UserDefaults
    private let subsystem: String
    
    public init(
        appGroup: String,
        subsystem: String
    ) {
        self.subsystem = subsystem
        
        guard let sharedDefaults = UserDefaults(suiteName: appGroup)
        else {
            fatalError("Shared UserDefaults couldn't be setup")
        }
        self.sharedDefaults = sharedDefaults
    }
    
    private let database: DatabaseType = Database()
    
    public lazy var logger: LoggingService = LoggingService(subsystem: subsystem)
    public lazy var userPreferenceService: UserPreferenceServiceType = UserPreferenceService(defaults: sharedDefaults)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
    public lazy var dateService: DateServiceType = DateService()
    public lazy var dayManager: DayManagerType = DayManager(database: database)
    public lazy var consumptionManager: ConsumptionManagerType = ConsumptionManager(database: database)
    public lazy var drinkManager: DrinkManagerType = DrinkManager(database: database)
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var drinksService: DrinkServiceType = DrinkService(engine: self)
}

extension MiniEngine:
    HasLoggingService,
    HasUnitService,
    HasUserPreferenceService,
    HasDateService,
    HasDayManagerService,
    HasConsumptionManagerService,
    HasDrinkManagerService,
    HasDayService,
    HasDrinksService
{}
