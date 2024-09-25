//
//  WatchEngine.swift
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
import CommunicationKitInterface
import WatchCommsInterface
import WatchComms

public final class WatchEngine {
    public init(
        appGroup: String,
        subsystem: String,
        watchService: WatchServiceType,
        notificationCenter: NotificationCenter
    ) {
        self.subsystem = subsystem
        self.appGroup = appGroup
        
        guard let sharedDefaults = UserDefaults(suiteName: appGroup)
        else {
            fatalError("Shared UserDefaults couldn't be setup")
        }
        self.sharedDefaults = sharedDefaults
        self.database = Database(appGroup: appGroup)
        self.watchService = watchService
        self.notificationCenter = notificationCenter
    }
    
    public let appGroup: String
    private let database: DatabaseType
    private let sharedDefaults: UserDefaults
    private let subsystem: String
    
    public let notificationCenter: NotificationCenter
    public var watchService: WatchServiceType
    
    public lazy var logger: LoggingService = LoggingService(subsystem: subsystem)
    public lazy var userPreferenceService: UserPreferenceServiceType = UserPreferenceService(defaults: sharedDefaults)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
    public lazy var dateService: DateServiceType = DateService()
    public lazy var dayManager: DayManagerType = DayManager(database: database)
    public lazy var consumptionManager: ConsumptionManagerType = ConsumptionManager(database: database)
    public lazy var drinkManager: DrinkManagerType = DrinkManager(database: database)
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var drinksService: DrinkServiceType = DrinkService(engine: self)
    public lazy var watchComms: WatchCommsType = WatchComms(engine: self, notificationCenter: notificationCenter)
}

extension WatchEngine:
    HasAppGroup,
    HasLoggingService,
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
