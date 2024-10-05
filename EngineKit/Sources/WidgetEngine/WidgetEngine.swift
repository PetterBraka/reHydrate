//
//  WidgetEngine.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//

import Foundation

import LoggingService
import UserPreferenceServiceInterface
import UserPreferenceService
import DateServiceInterface
import DateService
import UnitServiceInterface
import UnitService
import DayServiceInterface
import DayService
import DBKitInterface
import DBKit
import NotificationCenterServiceInterface
import NotificationCenterService

public final class WidgetEngine {
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
        self.database = Database(appGroup: appGroup)
    }
    
    private let database: DatabaseType
    private let sharedDefaults: UserDefaults
    private let subsystem: String
    
    public lazy var logger: LoggingService = LoggingService(subsystem: subsystem)
    public lazy var userPreferenceService: UserPreferenceServiceType = UserPreferenceService(defaults: sharedDefaults)
    public lazy var consumptionManager: ConsumptionManagerType = ConsumptionManager(database: database)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
    public lazy var dayManager: DayManagerType = DayManager(database: database)
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var dateService: DateServiceType = DateService()
    public lazy var notificationCenter: NotificationCenterType = NotificationCenterService()
}

extension WidgetEngine:
    HasConsumptionManagerService,
    HasUserPreferenceService,
    HasDayManagerService,
    HasLoggingService,
    HasUnitService,
    HasDateService,
    HasDayService,
    HasNotificationCenter
{}
