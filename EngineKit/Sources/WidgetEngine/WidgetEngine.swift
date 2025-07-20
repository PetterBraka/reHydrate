//
//  WidgetEngine.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//

import Foundation
import SwiftData
import LoggingKit
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
        self.logger = LoggerService(subsystem: subsystem)
        self.sharedDefaults = sharedDefaults
        
        let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)
        let container = Database.createContainer(path: path, schema: .init([DayEntity.self, DrinkEntity.self, ConsumptionEntity.self]))
        
        consumptionManager = ConsumptionManager(container: container, logger: logger)
        dayManager = DayManager(container: container, logger: logger)
    }
    
    private let sharedDefaults: UserDefaults
    private let subsystem: String
    public var logger: LoggerServicing
    
    public var consumptionManager: ConsumptionManagerType
    public var dayManager: DayManagerType
    
    public lazy var userPreferenceService: UserPreferenceServiceType = UserPreferenceService(defaults: sharedDefaults)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var dateService: DateServiceType = DateService()
}

extension WidgetEngine:
    HasConsumptionManagerService,
    HasUserPreferenceService,
    HasDayManagerService,
    HasLoggerService,
    HasUnitService,
    HasDateService,
    HasDayService
{}
