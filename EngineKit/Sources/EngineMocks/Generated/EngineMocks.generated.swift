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

    public func makeNotificationService() -> (stub: NotificationServiceTypeStubbing, spy: NotificationServiceTypeSpying) {
        let stub = NotificationServiceTypeStub()
        let spy = NotificationServiceTypeSpy(realObject: stub)

        self.notificationService = spy
        return (stub, spy)
    }

    public func makeNotificationService(_ realObject: NotificationServiceType) -> (realObject: NotificationServiceType, spy: NotificationServiceTypeSpying) {
        let spy = NotificationServiceTypeSpy(realObject: realObject)

        self.notificationService = spy
        return (realObject, spy)
    }

    public func makeNotificationDelegate() -> (stub: NotificationDelegateTypeStubbing, spy: NotificationDelegateTypeSpying) {
        let stub = NotificationDelegateTypeStub()
        let spy = NotificationDelegateTypeSpy(realObject: stub)

        self.notificationDelegate = spy
        return (stub, spy)
    }

    public func makeNotificationDelegate(_ realObject: NotificationDelegateType) -> (realObject: NotificationDelegateType, spy: NotificationDelegateTypeSpying) {
        let spy = NotificationDelegateTypeSpy(realObject: realObject)

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

}
