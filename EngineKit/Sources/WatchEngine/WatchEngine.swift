//
//  WatchEngine.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//

import Foundation
import LoggingKit
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
import CommunicationKitInterface
import WatchCommsInterface
import WatchComms

public final class WatchEngine {
    public init(
        appGroup: String,
        subsystem: String,
        watchService: WatchServiceType
    ) {
        self.subsystem = subsystem
        self.appGroup = appGroup
        
        guard let sharedDefaults = UserDefaults(suiteName: appGroup)
        else {
            fatalError("Shared UserDefaults couldn't be setup")
        }
        self.sharedDefaults = sharedDefaults
        self.logger = LoggerService(subsystem: subsystem)
        let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)
        let container = Database.createContainer(path: path, schema: .init([DayEntity.self, DrinkEntity.self, ConsumptionEntity.self]))
        
        dayManager = DayManager(container: container, logger: logger)
        consumptionManager = ConsumptionManager(container: container, logger: logger)
        drinkManager = DrinkManager(container: container, logger: logger)
        
        self.watchService = watchService
    }
    
    public let appGroup: String
    private let sharedDefaults: UserDefaults
    private let subsystem: String
    
    public var dayManager: DayManagerType
    public var consumptionManager: ConsumptionManagerType
    public var drinkManager: DrinkManagerType
    public var watchService: WatchServiceType
    
    public var logger: LoggerServicing
    public lazy var userPreferenceService: UserPreferenceServiceType = UserPreferenceService(defaults: sharedDefaults)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
    public lazy var dateService: DateServiceType = DateService()
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var drinksService: DrinkServiceType = DrinkService(engine: self)
    public lazy var watchComms: WatchCommsType = WatchComms(engine: self, notificationCenter: .default)
}

extension WatchEngine:
    HasAppGroup,
    HasLoggerService,
    HasUnitService,
    HasUserPreferenceService,
    HasDateService,
    HasDayManagerService,
    HasConsumptionManagerService,
    HasDrinkManagerService,
    HasDayService,
    HasDrinksService,
    HasWatchService,
    HasWatchComms
{}
