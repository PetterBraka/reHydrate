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
import UnitServiceInterface
import UnitService
import UserPreferenceServiceInterface
import UserPreferenceService
import NotificationServiceInterface
import NotificationService
import PortsInterface
import AppearanceServiceInterface
import AppearanceService
import DateServiceInterface
import DateService
import DBKitInterface
import DBKit
import CommunicationKitInterface
import PhoneCommsInterface
import PhoneComms

public final class Engine {
    public init(
        appGroup: String,
        appVersion: String,
        logger: LoggingService,
        database: DatabaseType,
        reminders: [NotificationMessage],
        celebrations: [NotificationMessage],
        userNotificationCenter: UserNotificationCenterType,
        openUrlService: OpenUrlInterface,
        alternateIconsService: AlternateIconsServiceType,
        appearancePort: AppearancePortType,
        healthService: HealthInterface,
        phoneService: PhoneServiceType,
        notificationCenter: NotificationCenter
    ) {
        guard let sharedDefault = UserDefaults(suiteName: appGroup)
        else {
            fatalError("Shared UserDefaults couldn't be setup")
        }
        self.appGroup = appGroup
        self.logger = logger
        self.dayManager = DayManager(database: database)
        self.drinkManager = DrinkManager(database: database)
        self.consumptionManager = ConsumptionManager(database: database)
        self.userPreferenceService = UserPreferenceService(defaults: sharedDefault)
        
        self.appVersion = appVersion
        self.reminders = reminders
        self.celebrations = celebrations
        self.userNotificationCenter = userNotificationCenter
        self.openUrlService = openUrlService
        self.alternateIconsService = alternateIconsService
        self.appearancePort = appearancePort
        self.healthService = healthService
        self.phoneService = phoneService
        self.notificationCenter = notificationCenter
    }
    
    public let appGroup: String
    public var appVersion: String
    private let reminders: [NotificationMessage]
    private let celebrations: [NotificationMessage]
    public let userNotificationCenter: UserNotificationCenterType
    public var didCompleteNotificationAction: (() -> Void)?
    
    public var logger: LoggingService
    public var dayManager: DayManagerType
    public var drinkManager: DrinkManagerType
    public var consumptionManager: ConsumptionManagerType
    public var userPreferenceService: UserPreferenceServiceType
    
    // MARK: Ports
    public var openUrlService: OpenUrlInterface
    public var alternateIconsService: AlternateIconsServiceType
    public var appearancePort: AppearancePortType
    public var healthService: HealthInterface
    public var phoneService: PhoneServiceType
    public var notificationCenter: NotificationCenter
    
    public lazy var notificationService: NotificationServiceType = NotificationService(
        engine: self,
        reminders: reminders,
        celebrations: celebrations,
        userNotificationCenter: userNotificationCenter,
        didComplete: nil
    )
    public lazy var notificationDelegate: NotificationDelegateType = NotificationDelegateService(engine: self, didCompleteAction: didCompleteNotificationAction)
    
    // MARK: Service
    public lazy var drinksService: DrinkServiceType = DrinkService(engine: self)
    public lazy var languageService: LanguageServiceType = LanguageService(engine: self)
    public lazy var dayService: DayServiceType = DayService(engine: self)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
    public lazy var appearanceService: AppearanceServiceType = AppearanceService(engine: self)
    public lazy var dateService: DateServiceType = DateService()
    public lazy var phoneComms: PhoneCommsType = PhoneComms(engine: self, notificationCenter: notificationCenter)
}

extension Engine: HasService & HasPorts & HasAppInfo {}
