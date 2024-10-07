// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

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

extension EngineMocks {
    public func makeUserPreferenceService() -> (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying) {
        let stub = UserPreferenceServiceTypeStub()
        let spy = UserPreferenceServiceTypeSpy(realObject: stub)

        self.userPreferenceService = spy
        return (stub, spy)
    }

    public func makeUserPreferenceService(_ realObject: UserPreferenceServiceType) -> (realObject: UserPreferenceServiceType, spy: UserPreferenceServiceTypeSpying) {
        let spy = UserPreferenceServiceTypeSpy(realObject: realObject)

        self.userPreferenceService = spy
        return (realObject, spy)
    }

    public func makeUserNotificationService() -> (stub: UserNotificationServiceTypeStubbing, spy: UserNotificationServiceTypeSpying) {
        let stub = UserNotificationServiceTypeStub()
        let spy = UserNotificationServiceTypeSpy(realObject: stub)

        self.userNotificationService = spy
        return (stub, spy)
    }

    public func makeUserNotificationService(_ realObject: UserNotificationServiceType) -> (realObject: UserNotificationServiceType, spy: UserNotificationServiceTypeSpying) {
        let spy = UserNotificationServiceTypeSpy(realObject: realObject)

        self.userNotificationService = spy
        return (realObject, spy)
    }

    public func makeNotificationDelegate() -> (stub: UserNotificationDelegateTypeStubbing, spy: UserNotificationDelegateTypeSpying) {
        let stub = UserNotificationDelegateTypeStub()
        let spy = UserNotificationDelegateTypeSpy(realObject: stub)

        self.notificationDelegate = spy
        return (stub, spy)
    }

    public func makeNotificationDelegate(_ realObject: UserNotificationDelegateType) -> (realObject: UserNotificationDelegateType, spy: UserNotificationDelegateTypeSpying) {
        let spy = UserNotificationDelegateTypeSpy(realObject: realObject)

        self.notificationDelegate = spy
        return (realObject, spy)
    }

    public func makeAppearancePort() -> (stub: AppearancePortTypeStubbing, spy: AppearancePortTypeSpying) {
        let stub = AppearancePortTypeStub()
        let spy = AppearancePortTypeSpy(realObject: stub)

        self.appearancePort = spy
        return (stub, spy)
    }

    public func makeAppearancePort(_ realObject: AppearancePortType) -> (realObject: AppearancePortType, spy: AppearancePortTypeSpying) {
        let spy = AppearancePortTypeSpy(realObject: realObject)

        self.appearancePort = spy
        return (realObject, spy)
    }

    public func makeAlternateIconsService() -> (stub: AlternateIconsServiceTypeStubbing, spy: AlternateIconsServiceTypeSpying) {
        let stub = AlternateIconsServiceTypeStub()
        let spy = AlternateIconsServiceTypeSpy(realObject: stub)

        self.alternateIconsService = spy
        return (stub, spy)
    }

    public func makeAlternateIconsService(_ realObject: AlternateIconsServiceType) -> (realObject: AlternateIconsServiceType, spy: AlternateIconsServiceTypeSpying) {
        let spy = AlternateIconsServiceTypeSpy(realObject: realObject)

        self.alternateIconsService = spy
        return (realObject, spy)
    }

    public func makeOpenUrlService() -> (stub: OpenUrlInterfaceStubbing, spy: OpenUrlInterfaceSpying) {
        let stub = OpenUrlInterfaceStub()
        let spy = OpenUrlInterfaceSpy(realObject: stub)

        self.openUrlService = spy
        return (stub, spy)
    }

    public func makeOpenUrlService(_ realObject: OpenUrlInterface) -> (realObject: OpenUrlInterface, spy: OpenUrlInterfaceSpying) {
        let spy = OpenUrlInterfaceSpy(realObject: realObject)

        self.openUrlService = spy
        return (realObject, spy)
    }

    public func makeHealthService() -> (stub: HealthInterfaceStubbing, spy: HealthInterfaceSpying) {
        let stub = HealthInterfaceStub()
        let spy = HealthInterfaceSpy(realObject: stub)

        self.healthService = spy
        return (stub, spy)
    }

    public func makeHealthService(_ realObject: HealthInterface) -> (realObject: HealthInterface, spy: HealthInterfaceSpying) {
        let spy = HealthInterfaceSpy(realObject: realObject)

        self.healthService = spy
        return (realObject, spy)
    }

    public func makeDayService() -> (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying) {
        let stub = DayServiceTypeStub()
        let spy = DayServiceTypeSpy(realObject: stub)

        self.dayService = spy
        return (stub, spy)
    }

    public func makeDayService(_ realObject: DayServiceType) -> (realObject: DayServiceType, spy: DayServiceTypeSpying) {
        let spy = DayServiceTypeSpy(realObject: realObject)

        self.dayService = spy
        return (realObject, spy)
    }

    public func makeDrinksService() -> (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying) {
        let stub = DrinkServiceTypeStub()
        let spy = DrinkServiceTypeSpy(realObject: stub)

        self.drinksService = spy
        return (stub, spy)
    }

    public func makeDrinksService(_ realObject: DrinkServiceType) -> (realObject: DrinkServiceType, spy: DrinkServiceTypeSpying) {
        let spy = DrinkServiceTypeSpy(realObject: realObject)

        self.drinksService = spy
        return (realObject, spy)
    }

    public func makeLanguageService() -> (stub: LanguageServiceTypeStubbing, spy: LanguageServiceTypeSpying) {
        let stub = LanguageServiceTypeStub()
        let spy = LanguageServiceTypeSpy(realObject: stub)

        self.languageService = spy
        return (stub, spy)
    }

    public func makeLanguageService(_ realObject: LanguageServiceType) -> (realObject: LanguageServiceType, spy: LanguageServiceTypeSpying) {
        let spy = LanguageServiceTypeSpy(realObject: realObject)

        self.languageService = spy
        return (realObject, spy)
    }

    public func makeUnitService() -> (stub: UnitServiceTypeStubbing, spy: UnitServiceTypeSpying) {
        let stub = UnitServiceTypeStub()
        let spy = UnitServiceTypeSpy(realObject: stub)

        self.unitService = spy
        return (stub, spy)
    }

    public func makeUnitService(_ realObject: UnitServiceType) -> (realObject: UnitServiceType, spy: UnitServiceTypeSpying) {
        let spy = UnitServiceTypeSpy(realObject: realObject)

        self.unitService = spy
        return (realObject, spy)
    }

    public func makeAppearanceService() -> (stub: AppearanceServiceTypeStubbing, spy: AppearanceServiceTypeSpying) {
        let stub = AppearanceServiceTypeStub()
        let spy = AppearanceServiceTypeSpy(realObject: stub)

        self.appearanceService = spy
        return (stub, spy)
    }

    public func makeAppearanceService(_ realObject: AppearanceServiceType) -> (realObject: AppearanceServiceType, spy: AppearanceServiceTypeSpying) {
        let spy = AppearanceServiceTypeSpy(realObject: realObject)

        self.appearanceService = spy
        return (realObject, spy)
    }

    public func makeDateService() -> (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying) {
        let stub = DateServiceTypeStub()
        let spy = DateServiceTypeSpy(realObject: stub)

        self.dateService = spy
        return (stub, spy)
    }

    public func makeDateService(_ realObject: DateServiceType) -> (realObject: DateServiceType, spy: DateServiceTypeSpying) {
        let spy = DateServiceTypeSpy(realObject: realObject)

        self.dateService = spy
        return (realObject, spy)
    }

    public func makePhoneService() -> (stub: PhoneServiceTypeStubbing, spy: PhoneServiceTypeSpying) {
        let stub = PhoneServiceTypeStub()
        let spy = PhoneServiceTypeSpy(realObject: stub)

        self.phoneService = spy
        return (stub, spy)
    }

    public func makePhoneService(_ realObject: PhoneServiceType) -> (realObject: PhoneServiceType, spy: PhoneServiceTypeSpying) {
        let spy = PhoneServiceTypeSpy(realObject: realObject)

        self.phoneService = spy
        return (realObject, spy)
    }

    public func makeWatchService() -> (stub: WatchServiceTypeStubbing, spy: WatchServiceTypeSpying) {
        let stub = WatchServiceTypeStub()
        let spy = WatchServiceTypeSpy(realObject: stub)

        self.watchService = spy
        return (stub, spy)
    }

    public func makeWatchService(_ realObject: WatchServiceType) -> (realObject: WatchServiceType, spy: WatchServiceTypeSpying) {
        let spy = WatchServiceTypeSpy(realObject: realObject)

        self.watchService = spy
        return (realObject, spy)
    }

    public func makePhoneComms() -> (stub: PhoneCommsTypeStubbing, spy: PhoneCommsTypeSpying) {
        let stub = PhoneCommsTypeStub()
        let spy = PhoneCommsTypeSpy(realObject: stub)

        self.phoneComms = spy
        return (stub, spy)
    }

    public func makePhoneComms(_ realObject: PhoneCommsType) -> (realObject: PhoneCommsType, spy: PhoneCommsTypeSpying) {
        let spy = PhoneCommsTypeSpy(realObject: realObject)

        self.phoneComms = spy
        return (realObject, spy)
    }

    public func makeWatchComms() -> (stub: WatchCommsTypeStubbing, spy: WatchCommsTypeSpying) {
        let stub = WatchCommsTypeStub()
        let spy = WatchCommsTypeSpy(realObject: stub)

        self.watchComms = spy
        return (stub, spy)
    }

    public func makeWatchComms(_ realObject: WatchCommsType) -> (realObject: WatchCommsType, spy: WatchCommsTypeSpying) {
        let spy = WatchCommsTypeSpy(realObject: realObject)

        self.watchComms = spy
        return (realObject, spy)
    }

    public func makeNotificationCenter() -> (stub: NotificationCenterTypeStubbing, spy: NotificationCenterTypeSpying) {
        let stub = NotificationCenterTypeStub()
        let spy = NotificationCenterTypeSpy(realObject: stub)

        self.notificationCenter = spy
        return (stub, spy)
    }

    public func makeNotificationCenter(_ realObject: NotificationCenterType) -> (realObject: NotificationCenterType, spy: NotificationCenterTypeSpying) {
        let spy = NotificationCenterTypeSpy(realObject: realObject)

        self.notificationCenter = spy
        return (realObject, spy)
    }

}
