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
import NotificationServiceInterface
import NotificationService
import PortsInterface

public final class Engine {
    public init(
        reminders: [NotificationMessage],
        celebrations: [NotificationMessage],
        notificationCenter: NotificationCenterType,
        openUrlService: OpenUrlServiceInterface
    ) {
        let project = "reHydrate"
        let appGroup = "group.com.braka.reHydrate.shared"
        guard let sharedDefault = UserDefaults(suiteName: appGroup)
        else {
            fatalError("Shared UserDefaults couldn't be setup")
        }
        logger = LoggingService(subsystem: project)
        database = Database(logger: logger)
        dayManager = DayManager(database: database)
        drinkManager = DrinkManager(database: database)
        consumptionManager = ConsumptionManager(database: database)
        userPreferenceService = UserPreferenceService(defaults: sharedDefault)
        
        self.reminders = reminders
        self.celebrations = celebrations
        self.notificationCenter = notificationCenter
        self.openUrlService = openUrlService
    }
    
    private let reminders: [NotificationMessage]
    private let celebrations: [NotificationMessage]
    public let notificationCenter: NotificationCenterType
    public var didCompleteNotificationAction: (() -> Void)?
    
    public var logger: LoggingService
    public var database: DatabaseType
    public var dayManager: DayManagerType
    public var drinkManager: DrinkManagerType
    public var consumptionManager: ConsumptionManagerType
    public var userPreferenceService: UserPreferenceServiceType
    
    // MARK: Ports
    public var openUrlService: OpenUrlServiceInterface
    
    public lazy var notificationService: NotificationServiceType = NotificationService(
        engine: self,
        reminders: reminders,
        celebrations: celebrations,
        notificationCenter: notificationCenter,
        didComplete: nil
    )
    public lazy var notificationDelegate: NotificationDelegateType = NotificationDelegateService(engine: self, didCompleteAction: didCompleteNotificationAction)
    
    // MARK: Service
    public lazy var drinksService: DrinkServiceType = DrinkService(engine: self)
    public lazy var languageService: LanguageServiceType = LanguageService(engine: self)
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
}

extension Engine: HasService {}
extension Engine: HasPorts {}
