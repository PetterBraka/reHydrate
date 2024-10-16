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
import NotificationCenterServiceInterface
import NotificationCenterService

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
        self.database = Database(appGroup: appGroup, logger: logger)
        self.watchService = watchService
    }
    
    public let appGroup: String
    private let database: DatabaseType
    private let sharedDefaults: UserDefaults
    private let subsystem: String
    
    public var watchService: WatchServiceType
    
    public var logger: LoggerServicing
    public lazy var userPreferenceService: UserPreferenceServiceType = UserPreferenceService(defaults: sharedDefaults)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
    public lazy var dateService: DateServiceType = DateService()
    public lazy var dayManager: DayManagerType = DayManager(database: database, logger: logger)
    public lazy var consumptionManager: ConsumptionManagerType = ConsumptionManager(database: database, logger: logger)
    public lazy var drinkManager: DrinkManagerType = DrinkManager(database: database, logger: logger)
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var drinksService: DrinkServiceType = DrinkService(engine: self)
    public lazy var watchComms: WatchCommsType = WatchComms(engine: self, notificationCenter: .default)
    public lazy var notificationCenter: NotificationCenterType = NotificationCenterService(notificationCenter: .default)
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
    HasWatchComms,
    HasNotificationCenter
{}
