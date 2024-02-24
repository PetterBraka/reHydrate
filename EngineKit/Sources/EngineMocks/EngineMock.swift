//
//  EngineMocks.swift
//
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import LoggingService
import DayServiceInterface
import DayServiceMocks
import DrinkServiceInterface
import DrinkServiceMocks
import LanguageServiceInterface
import LanguageServiceMocks
import UnitServiceInterface
import UnitServiceMocks
import UserPreferenceServiceInterface
import UserPreferenceServiceMocks
import NotificationServiceInterface
import NotificationServiceMocks
import AppearanceServiceInterface
import AppearanceServiceMocks
import PortsInterface
import PortsMocks
import DateServiceInterface
import DateServiceMocks
import DBKitInterface
import DBKitMocks

public final class EngineMocks {
    public init() {}
    
    public var logger: LoggingService = LoggingService(subsystem: "EngineMock")
    public var dayManager: DayManagerType = DayManagerStub()
    public var drinkManager: DrinkManagerType = DrinkManagerStub()
    public var consumptionManager: ConsumptionManagerType = ConsumptionManagerStub()
    public var userPreferenceService: UserPreferenceServiceType = UserPreferenceServiceStub()
    public var notificationService: NotificationServiceType = NotificationServiceStub()
    public var notificationDelegate: NotificationDelegateType = NotificationDelegateStub()
    
    //MARK: Ports
    public var appearancePort: AppearancePortType = AppearancePortStub()
    public var alternateIconsService: AlternateIconsServiceType = AlternateIconsServiceStub()
    public var openUrlService: OpenUrlInterface = OpenUrlServiceStub()
    public var healthService: HealthInterface = HealthServiceStub()
    
    public var dayService: DayServiceType = DayServiceStub()
    public var drinksService: DrinkServiceType = DrinkServiceStub()
    public var languageService: LanguageServiceType = LanguageServiceStub()
    public var unitService: UnitServiceType = UnitServiceStub()
    
    public var appearanceService: AppearanceServiceType = AppearanceServiceTypeStub()
    public var dateService: DateServiceType = DateServiceTypeStub()
}

extension EngineMocks: HasService {}
extension EngineMocks: HasPorts {}
