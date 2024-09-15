//
//  WatchWidgetEngine.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//

import UserPreferenceServiceInterface
import DateServiceInterface
import UnitServiceInterface
import DayServiceInterface
import DBKitInterface

import UserPreferenceService
import LoggingService
import UnitService
import DateService
import DayService
import Foundation
import DBKit

public final class WatchWidgetEngine {
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
    private let sharedDefaults: UserDefaults
    private let subsystem: String
    
    public lazy var logger: LoggingService = LoggingService(subsystem: subsystem)
    public lazy var userPreferenceService: UserPreferenceServiceType = UserPreferenceService(defaults: sharedDefaults)
    public lazy var consumptionManager: ConsumptionManagerType = ConsumptionManager(database: database)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
    public lazy var dayManager: DayManagerType = DayManager(database: database)
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var dateService: DateServiceType = DateService()
}

extension WatchWidgetEngine:
    HasConsumptionManagerService,
    HasUserPreferenceService,
    HasDayManagerService,
    HasLoggingService,
    HasUnitService,
    HasDateService,
    HasDayService
{}
