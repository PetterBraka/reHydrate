//
//  SettingsPresentationTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 24/02/2024.
//

import XCTest
import TestHelper
import PortsMocks
import EngineMocks
import DayServiceMocks
import UnitServiceMocks
import DateServiceMocks
import NotificationServiceMocks
import UserPreferenceServiceMocks
@testable import PresentationKit

final class SettingsPresentationTests: XCTestCase {
    fileprivate typealias Sut = Screen.Settings.Presenter
    private var sut: Sut!
    
    private var engine: EngineMocks!
    private var router: RouterSpy!
    private var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    private var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    private var unitService: (stub: UnitServiceTypeStubbing, spy: UnitServiceTypeSpying)!
    private var notificationService: (stub: NotificationServiceTypeStubbing, spy: NotificationServiceTypeSpying)!
    private var userPreferenceService: (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying)!
    private var urlService: (stub: OpenUrlInterfaceStubbing, spy: OpenUrlInterfaceSpying)!
    
    override func setUp() {
        engine = EngineMocks()
        router = RouterSpy()
        
        dayService = engine.makeDayService()
        unitService = engine.makeUnitService()
        dateService = engine.makeDateService()
        notificationService = engine.makeNotificationService()
        userPreferenceService = engine.makeUserPreferenceService()
        urlService = engine.makeOpenUrlService()
    }
    
    
    func test_didTapBack() async {
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didTapBack)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [.showHome])
    }
    
    func test_didTapEditAppIcon_() async {
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didTapEditAppIcon)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [.showAppIcon])
    }
    
    func test_didTapCredits_() async {
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didTapCredits)
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [.showCredits])
    }
    
    func test_didTapContactMe_() async {
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didTapContactMe)
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(
            urlService.spy.methodLog,
            [.email(
                email: "Petter.braka+reHydrate@gmail.com", cc: nil, bcc: nil,
                subject: "reHydrate query - v0.0.0-mock", body: nil
            )]
        )
    }
    
    func test_didTapPrivacy_() async {
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didTapPrivacy)
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(urlService.spy.methodLog, 
                       [.open(url: URL(string: "https://github.com/PetterBraka/reHydrate/blob/master/Privacy-Policy.md")!)])
    }
    
    func test_didTapDeveloperInstagram_() async {
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didTapDeveloperInstagram)
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(urlService.spy.methodLog, 
                       [.open(url: URL(string:"https://www.instagram.com/braka.coding/")!)])
    }
    
    func test_didTapMerchandise_() async {
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didTapMerchandise)
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(urlService.spy.methodLog, 
                       [.open(url: URL(string:"https://www.redbubble.com/people/petter-braka/shop")!)])
    }
    
    func test_didOpenSettings_() async {
        urlService.stub.settingsUrl_returnValue = URL(string: "prefs:root=reHydrate")
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didOpenSettings)
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(urlService.spy.methodLog, [.open(url: URL(string: "prefs:root=reHydrate")!)])
    }
    
    func test_didSetDarkMode_on() async {
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didSetDarkMode(true))
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: true,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
    }
    
    func test_didSetDarkMode_off() async {
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didSetDarkMode(false))
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
    }
    
    func test_didSetUnitSystem_metric() async {
        userPreferenceService.stub.getKey_returnValue = "imperial"
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didSetUnitSystem(.metric))
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
    }
    
    func test_didSetUnitSystem_imperial() async {
        userPreferenceService.stub.getKey_returnValue = "metric"
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didSetUnitSystem(.imperial))
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .imperial,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
    }
    
    func test_didSetReminders_on() async {
        let sut = Sut(engine: engine, router: router)
        
        notificationService.stub.minimumAllowedFrequency_returnValue = 5
        dateService.stub.now_returnValue = .december_8_2021_Wednesday
        dateService.stub.getStartDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0)
        dateService.stub.getEndDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
        
        dateService.stub.now_returnValue = .december_8_2021_Wednesday
        dateService.stub.getStartDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0)
        dateService.stub.getEndDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.getDateValueComponentDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 54, seconds: 59)
        dateService.stub.getDateValueComponentDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 5, seconds: 0)
        
        await sut.perform(action: .didSetReminders(true))
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: .init(
                    frequency: 5,
                    start: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                    startRange: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0) ... Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 54, seconds: 59),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59),
                    stopRange: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 5, seconds: 0) ... Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
                ),
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
    }
    
    func test_didSetReminders_off() async {
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59),
            frequency: 45
        )
        let sut = Sut(engine: engine, router: router)
        try! await Task.sleep(for: .milliseconds(100))
        
        await sut.perform(action: .didSetReminders(false))
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
    }
}

extension OpenUrlInterfaceSpy.MethodCall: Equatable {
    public static func == (lhs: OpenUrlInterfaceSpy.MethodCall, rhs: OpenUrlInterfaceSpy.MethodCall) -> Bool {
        switch (lhs, rhs) {
        case let (.open(lhsUrl), .open(url: rhsUrl)):
            lhsUrl == rhsUrl
        case let (.email(lhsEmail, lhsCc, lhsBcc, lhsSubject, lhsBody),
            .email(rhsEmail, rhsCc, rhsBcc, rhsSubject, rhsBody)):
            lhsEmail == rhsEmail &&
            lhsCc == rhsCc &&
            lhsBcc == rhsBcc &&
            lhsSubject == rhsSubject &&
            lhsBody == rhsBody
        case (.open, .email), (.email, .open):
            false
        }
    }
}
