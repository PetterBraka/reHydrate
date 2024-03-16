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
    public func makeNotificationService() -> (stub: NotificationServiceTypeStubbing, spy: NotificationServiceTypeSpying) {
        let stub = NotificationServiceTypeStub()
        let spy = NotificationServiceTypeSpy(realObject: stub)

        self.notificationService = spy
        return (stub, spy)
    }
    public func makeNotificationDelegate() -> (stub: NotificationDelegateTypeStubbing, spy: NotificationDelegateTypeSpying) {
        let stub = NotificationDelegateTypeStub()
        let spy = NotificationDelegateTypeSpy(realObject: stub)

        self.notificationDelegate = spy
        return (stub, spy)
    }
    public func makeAppearancePort() -> (stub: AppearancePortTypeStubbing, spy: AppearancePortTypeSpying) {
        let stub = AppearancePortTypeStub()
        let spy = AppearancePortTypeSpy(realObject: stub)

        self.appearancePort = spy
        return (stub, spy)
    }
    public func makeAlternateIconsService() -> (stub: AlternateIconsServiceTypeStubbing, spy: AlternateIconsServiceTypeSpying) {
        let stub = AlternateIconsServiceTypeStub()
        let spy = AlternateIconsServiceTypeSpy(realObject: stub)

        self.alternateIconsService = spy
        return (stub, spy)
    }
    public func makeOpenUrlService() -> (stub: OpenUrlInterfaceStubbing, spy: OpenUrlInterfaceSpying) {
        let stub = OpenUrlInterfaceStub()
        let spy = OpenUrlInterfaceSpy(realObject: stub)

        self.openUrlService = spy
        return (stub, spy)
    }
    public func makeHealthService() -> (stub: HealthInterfaceStubbing, spy: HealthInterfaceSpying) {
        let stub = HealthInterfaceStub()
        let spy = HealthInterfaceSpy(realObject: stub)

        self.healthService = spy
        return (stub, spy)
    }
    public func makeDayService() -> (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying) {
        let stub = DayServiceTypeStub()
        let spy = DayServiceTypeSpy(realObject: stub)

        self.dayService = spy
        return (stub, spy)
    }
    public func makeDrinksService() -> (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying) {
        let stub = DrinkServiceTypeStub()
        let spy = DrinkServiceTypeSpy(realObject: stub)

        self.drinksService = spy
        return (stub, spy)
    }
    public func makeLanguageService() -> (stub: LanguageServiceTypeStubbing, spy: LanguageServiceTypeSpying) {
        let stub = LanguageServiceTypeStub()
        let spy = LanguageServiceTypeSpy(realObject: stub)

        self.languageService = spy
        return (stub, spy)
    }
    public func makeUnitService() -> (stub: UnitServiceTypeStubbing, spy: UnitServiceTypeSpying) {
        let stub = UnitServiceTypeStub()
        let spy = UnitServiceTypeSpy(realObject: stub)

        self.unitService = spy
        return (stub, spy)
    }
    public func makeAppearanceService() -> (stub: AppearanceServiceTypeStubbing, spy: AppearanceServiceTypeSpying) {
        let stub = AppearanceServiceTypeStub()
        let spy = AppearanceServiceTypeSpy(realObject: stub)

        self.appearanceService = spy
        return (stub, spy)
    }
    public func makeDateService() -> (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying) {
        let stub = DateServiceTypeStub()
        let spy = DateServiceTypeSpy(realObject: stub)

        self.dateService = spy
        return (stub, spy)
    }
}
