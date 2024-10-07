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
import UserNotificationServiceInterface
import UserNotificationServiceMocks
import AppearanceServiceInterface
import AppearanceServiceMocks
import PortsInterface
import PortsMocks
import DateServiceInterface
import DateServiceMocks
import DBKitInterface
import DBKitMocks
import CommunicationKitInterface
import CommunicationKitMocks
import PhoneCommsInterface
import PhoneCommsMocks
import WatchCommsInterface
import WatchCommsMocks
import NotificationCenterServiceInterface
import NotificationCenterServiceMocks

public final class EngineMocks {
    public init() {}
    
    public var logger: LoggingService = LoggingService(subsystem: "EngineMock")
    public var dayManager: DayManagerType = DayManagerStub()
    public var drinkManager: DrinkManagerType = DrinkManagerStub()
    public var consumptionManager: ConsumptionManagerType = ConsumptionManagerStub()
    public var userPreferenceService: UserPreferenceServiceType = UserPreferenceServiceTypeStub()
    public var userNotificationService: UserNotificationServiceType = UserNotificationServiceTypeStub()
    public var notificationDelegate: UserNotificationDelegateType = UserNotificationDelegateTypeStub()
    
    //MARK: Ports
    public var appearancePort: AppearancePortType = AppearancePortTypeStub()
    public var alternateIconsService: AlternateIconsServiceType = AlternateIconsServiceTypeStub()
    public var openUrlService: OpenUrlInterface = OpenUrlInterfaceStub()
    public var healthService: HealthInterface = HealthInterfaceStub()
    
    public var dayService: DayServiceType = DayServiceTypeStub()
    public var drinksService: DrinkServiceType = DrinkServiceTypeStub()
    public var languageService: LanguageServiceType = LanguageServiceTypeStub()
    public var unitService: UnitServiceType = UnitServiceTypeStub()
    
    public var appearanceService: AppearanceServiceType = AppearanceServiceTypeStub()
    public var dateService: DateServiceType = DateServiceTypeStub()
    public var phoneService: PhoneServiceType = PhoneServiceTypeStub()
    public var watchService: WatchServiceType = WatchServiceTypeStub()
    public var phoneComms: PhoneCommsType = PhoneCommsTypeStub()
    public var watchComms: WatchCommsType = WatchCommsTypeStub()
    public var notificationCenter: NotificationCenterType = NotificationCenterTypeStub()
}

extension EngineMocks: HasService {}
extension EngineMocks: HasPorts {}
