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
import CommunicationKitInterface
import CommunicationKitMocks
import PhoneCommsInterface
import PhoneCommsMocks
import WatchCommsInterface
import WatchCommsMocks

public final class EngineMocks {
    public init() {}
    
    public var appVersion: String = "0.0.0-mock"
    public var appGroup: String = "com.testing"
    
    public var logger: LoggingService = LoggingService(subsystem: "EngineMock")
    public var dayManager: DayManagerType = DayManagerStub()
    public var drinkManager: DrinkManagerType = DrinkManagerStub()
    public var consumptionManager: ConsumptionManagerType = ConsumptionManagerStub()
    public var userPreferenceService: UserPreferenceServiceType = UserPreferenceServiceTypeStub()
    public var notificationService: NotificationServiceType = NotificationServiceTypeStub()
    public var notificationDelegate: NotificationDelegateType = NotificationDelegateTypeStub()
    
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
}

extension EngineMocks: HasService {}
extension EngineMocks: HasPorts {}
extension EngineMocks: HasAppInfo {}
