//
//  EngineMocks.swift
//
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import EngineKit
import LoggingService
import DayServiceInterface
import DayServiceMocks
import DrinkServiceInterface
import DrinkServiceMocks
import LanguageServiceInterface
import LanguageServiceMocks
import DatabaseServiceInterface
import DatabaseServiceMocks
import UnitServiceInterface
import UnitServiceMocks
import UserPreferenceServiceInterface
import UserPreferenceServiceMocks
import NotificationServiceInterface
import NotificationServiceMocks

public final class EngineMocks {
    public init() {}
    
    public var logger: LoggingService = LoggingService(subsystem: "EngineMock")
    public var database: DatabaseType = DatabaseStub()
    public var dayManager: DayManagerType = DayManagerStub()
    public var consumptionManager: ConsumptionManagerType = ConsumptionManagerStub()
    public var userPreferenceService: UserPreferenceServiceType = UserPreferenceServiceStub()
    public var notificationService: NotificationServiceType = NotificationServiceStub()
    public var notificationDelegate: NotificationDelegate = NotificationDelegateStub()
    
    public var dayService: DayServiceType = DayServiceStub()
    public var drinksService: DrinkServiceType = DrinkServiceStub()
    public var languageService: LanguageServiceType = LanguageServiceStub()
    public var unitService: UnitServiceType = UnitServiceStub()
}

extension EngineMocks: HasService {}
