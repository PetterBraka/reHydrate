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
        
        sut = Sut(engine: engine, router: router)
    }
    
    override func tearDown() {
        engine = nil
        router = nil
        
        dayService = nil
        unitService = nil
        dateService = nil
        notificationService = nil
        userPreferenceService = nil
        urlService = nil
        
        sut = nil
    }
    
    func test_didAppear() async {
        await sut.perform(action: .didAppear)
        XCTAssertEqual(
            sut.viewModel,
                .init(isLoading: false,
                      isDarkModeOn: false,
                      unitSystem: .metric,
                      goal: 0,
                      notifications: nil,
                      appVersion: "0.0.0-mock",
                      error: nil)
        )
    }
    
    func test_didAppear_withGoal() async {
        dayService.stub.getToday_returnValue = .init(date: .december_8_2021_Wednesday, consumed: 1, goal: 2)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 2
        
        await sut.perform(action: .didAppear)
        XCTAssertEqual(
            sut.viewModel,
            .init(isLoading: false,
                  isDarkModeOn: false,
                  unitSystem: .metric,
                  goal: 2,
                  notifications: nil,
                  appVersion: "0.0.0-mock",
                  error: nil)
        )
        
        XCTAssertEqual(unitService.spy.lastMethodCall, .convert(value: 2, fromUnit: .litres, toUnit: .litres))
    }
    
    func test_didAppear_withImperialGoal() async {
        dayService.stub.getToday_returnValue = .init(date: .december_8_2021_Wednesday, consumed: 1, goal: 2)
        unitService.stub.getUnitSystem_returnValue = .imperial
        unitService.stub.convertValueFromUnitToUnit_returnValue = 3.52
        
        await sut.perform(action: .didAppear)
        XCTAssertEqual(
            sut.viewModel,
            .init(isLoading: false,
                  isDarkModeOn: false,
                  unitSystem: .imperial,
                  goal: 3.52,
                  notifications: nil,
                  appVersion: "0.0.0-mock",
                  error: nil)
        )
        
        XCTAssertEqual(unitService.spy.lastMethodCall, .convert(value: 2, fromUnit: .litres, toUnit: .pint))
    }
    
    func test_didAppear_withNotificationSettings() async {
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59),
            frequency: 30
        )
        givenRanges(with: .december_8_2021_Wednesday, 
                    minFrequency: 30,
                    start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                            Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 54, seconds: 59)),
                    end: (Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0),
                          Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)))
        
        await sut.perform(action: .didAppear)
        XCTAssertEqual(
            sut.viewModel,
            .init(isLoading: false,
                  isDarkModeOn: false,
                  unitSystem: .metric,
                  goal: 0,
                  notifications: .init(
                    frequency: 30,
                    start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
                    startRange: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8,  hours: 23, minutes: 54, seconds: 59),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59),
                    stopRange: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)),
                  appVersion: "0.0.0-mock",
                  error: nil)
        )
    }
    
    func test_didTapBack() async {
        await sut.perform(action: .didTapBack)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: true,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [.showHome])
    }
    
    func test_didTapEditAppIcon() async {
        await sut.perform(action: .didTapEditAppIcon)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: true,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [.showAppIcon])
    }
    
    func test_didTapCredits() async {
        await sut.perform(action: .didTapCredits)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: true,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [.showCredits])
    }
    
    func test_didTapContactMe() async {
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
    
    func test_didTapPrivacy() async {
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
    
    func test_didTapDeveloperInstagram() async {
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
    
    func test_didTapMerchandise() async {
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
    
    func test_didOpenSettings() async {
        urlService.stub.settingsUrl_returnValue = URL(string: "prefs:root=reHydrate")
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
        dateService.stub.getStartDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0)
        dateService.stub.getEndDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
        
        givenRanges(with: .december_8_2021_Wednesday,
                    minFrequency: 5,
                    start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                            Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 54, seconds: 59)),
                    end: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 5, seconds: 0),
                          Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)))
        
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
                    startRange: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0) ... 
                    Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 54, seconds: 59),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59),
                    stopRange: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 5, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
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
    
    func test_didSetRemindersStart_to12() async {
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 5
        )
        
        givenRanges(with: .december_8_2021_Wednesday,
                    minFrequency: 5,
                    start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                            Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0)),
                    end: (Date(year: 2021, month: 12, day: 8, hours: 12, minutes: 5, seconds: 0),
                          Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)))
        givenRanges(with: .december_8_2021_Wednesday,
                    minFrequency: 5,
                    start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                            Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0)),
                    end: (Date(year: 2021, month: 12, day: 8, hours: 12, minutes: 5, seconds: 0),
                          Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)))
        
        await sut.perform(action: .didSetRemindersStart(Date(year: 2021, month: 12, day: 8,
                                                             hours: 12, minutes: 0, seconds: 0)))
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: .init(
                    frequency: 5,
                    start: Date(year: 2021, month: 12, day: 8,  hours: 12, minutes: 0, seconds: 0),
                    startRange: Date(year: 2021, month: 12, day: 8,  hours: 0, minutes: 0, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
                    stopRange: Date(year: 2021, month: 12, day: 8, hours: 12, minutes: 5, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
                ),
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(notificationService.spy.lastMethodCall,
                       .enable(withFrequency: 5, 
                               start: Date(year: 2021, month: 12, day: 8,
                                           hours: 12, minutes: 0, seconds: 0),
                               stop: Date(year: 2021, month: 12, day: 8,
                                          hours: 21, minutes: 0, seconds: 0)))
    }
    
    func test_didSetRemindersStop_to20() async {
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 22, minutes: 0, seconds: 0),
            frequency: 5
        )
        
        givenRanges(with: .december_8_2021_Wednesday,
                    minFrequency: 5,
                   start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                           Date(year: 2021, month: 12, day: 8, hours: 19, minutes: 55, seconds: 0)),
                   end: (Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0),
                         Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)))
        givenRanges(with: .december_8_2021_Wednesday,
                    minFrequency: 5,
                    start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                            Date(year: 2021, month: 12, day: 8, hours: 19, minutes: 55, seconds: 0)),
                    end: (Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0),
                          Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)))
        
        await sut.perform(action: .didSetRemindersStop(Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 0, seconds: 0)))
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: .init(
                    frequency: 5,
                    start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
                    startRange: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 19, minutes: 55, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 0, seconds: 0),
                    stopRange: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
                ),
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(notificationService.spy.lastMethodCall,
                       .enable(withFrequency: 5,
                               start: Date(year: 2021, month: 12, day: 8,
                                           hours: 7, minutes: 0, seconds: 0),
                               stop: Date(year: 2021, month: 12, day: 8,
                                          hours: 20, minutes: 0, seconds: 0)))
    }
    
    func test_didTapIncrementFrequency() async {
        dateService.stub.getStartDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0)
        dateService.stub.getEndDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
        
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 5
        )
        
        givenRanges(with: .december_8_2021_Wednesday,
                    minFrequency: 5,
                    start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                            Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0)),
                    end: (Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0),
                          Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)))
        givenRanges(with: .december_8_2021_Wednesday,
                    minFrequency: 5,
                    start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                            Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0)),
                    end: (Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0),
                          Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)))
        await sut.perform(action: .didTapIncrementFrequency)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: .init(
                    frequency: 10,
                    start: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                    startRange: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59),
                    stopRange: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
                ),
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(
            notificationService.spy.lastMethodCall,
            .enable(withFrequency: 10,
                    start: Date(year: 2021, month: 12, day: 8,
                                hours: 0, minutes: 0, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8,
                               hours: 23, minutes: 59, seconds: 59))
        )
    }
    
    func test_didTapIncrementFrequency_afterDidLoad() async {
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 5
        )
        givenRanges(
            with: .december_8_2021_Wednesday,
            minFrequency: 5,
            start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                    Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0)),
            end: (Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0),
                  Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59))
        )
        await sut.perform(action: .didAppear)
        
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 5
        )
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 5
        )
        
        givenRanges(
            with: .december_8_2021_Wednesday,
            minFrequency: 5,
            start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                    Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0)),
            end: (Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0),
                  Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59))
        )
        givenRanges(
            with: .december_8_2021_Wednesday,
            minFrequency: 5,
            start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                    Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0)),
            end: (Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0),
                  Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59))
        )
        await sut.perform(action: .didTapIncrementFrequency)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: .init(
                    frequency: 10,
                    start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
                    startRange: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
                    stopRange: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
                ),
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(
            notificationService.spy.lastMethodCall,
            .enable(withFrequency: 10,
                    start: Date(year: 2021, month: 12, day: 8,
                                hours: 7, minutes: 0, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8,
                               hours: 21, minutes: 0, seconds: 0))
        )
    }
    
    func test_didTapDecrementFrequency() async {
        dateService.stub.getStartDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0)
        dateService.stub.getEndDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
        
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 15
        )
        
        givenRanges(with: .december_8_2021_Wednesday,
                    minFrequency: 5,
                    start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                            Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 49, seconds: 59)),
                    end: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 10, seconds: 0),
                          Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)))
        givenRanges(with: .december_8_2021_Wednesday,
                    minFrequency: 5,
                    start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                            Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 49, seconds: 59)),
                    end: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 10, seconds: 0),
                          Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)))
        await sut.perform(action: .didTapDecrementFrequency)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: .init(
                    frequency: 10,
                    start: Date(year: 2021, month: 12, day: 8,
                                hours: 0, minutes: 0, seconds: 0),
                    startRange: Date(year: 2021, month: 12, day: 8,
                                     hours: 0, minutes: 0, seconds: 0) ... Date(year: 2021, month: 12, day: 8,
                                                                                hours: 23, minutes: 49, seconds: 59),
                    stop: Date(year: 2021, month: 12, day: 8,
                               hours: 23, minutes: 59, seconds: 59),
                    stopRange: Date(year: 2021, month: 12, day: 8,
                                    hours: 0, minutes: 10, seconds: 0) ... Date(year: 2021, month: 12, day: 8,
                                                                                hours: 23, minutes: 59, seconds: 59)
                ),
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(
            notificationService.spy.lastMethodCall,
            .enable(withFrequency: 10,
                    start: Date(year: 2021, month: 12, day: 8,
                                hours: 0, minutes: 0, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8,
                               hours: 23, minutes: 59, seconds: 59))
        )
    }
    
    func test_didTapDecrementFrequency_afterDidLoad() async {
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 10
        )
        givenRanges(
            with: .december_8_2021_Wednesday,
            minFrequency: 5,
            start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                    Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0)),
            end: (Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0),
                  Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59))
        )
        await sut.perform(action: .didAppear)
        
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 10
        )
        notificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 10
        )
        
        givenRanges(
            with: .december_8_2021_Wednesday,
            minFrequency: 5,
            start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                    Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0)),
            end: (Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0),
                  Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59))
        )
        givenRanges(
            with: .december_8_2021_Wednesday,
            minFrequency: 5,
            start: (Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
                    Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0)),
            end: (Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0),
                  Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59))
        )
        await sut.perform(action: .didTapDecrementFrequency)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: .init(
                    frequency: 5,
                    start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
                    startRange: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 55, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
                    stopRange: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 5, seconds: 0) ...
                    Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
                ),
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(
            notificationService.spy.lastMethodCall,
            .enable(withFrequency: 5,
                    start: Date(year: 2021, month: 12, day: 8,
                                hours: 7, minutes: 0, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8,
                               hours: 21, minutes: 0, seconds: 0))
        )
    }
    
    func test_didTapIncrementGoal() async {
        dayService.stub.increaseGoal_returnValue = .success(0.5)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 0.5
        await sut.perform(action: .didTapIncrementGoal)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0.5,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(dayService.spy.lastMethodCall, .increase(goal: 0.5))
    }
    
    func test_didTapIncrementGoal_afterDidLoad() async {
        dayService.stub.getToday_returnValue = .init(date: .december_8_2021_Wednesday, consumed: 0, goal: 1.5)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 1.5
        notificationService.stub.getSettings_returnValue = .init(isOn: false, start: nil, stop: nil, frequency: nil)
        await sut.perform(action: .didAppear)
        
        dayService.stub.increaseGoal_returnValue = .success(2)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 2
        await sut.perform(action: .didTapIncrementGoal)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 2,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(dayService.spy.lastMethodCall, .increase(goal: 0.5))
    }
    
    func test_didTapDecrementGoal() async {
        dayService.stub.decreaseGoal_returnValue = .success(0.5)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 0.5
        await sut.perform(action: .didTapDecrementGoal)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0.5,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(dayService.spy.lastMethodCall, .decrease(goal: 0.5))
    }
    
    func test_didTapDecrementGoal_afterDidLoad() async {
        dayService.stub.getToday_returnValue = .init(date: .december_8_2021_Wednesday, consumed: 0, goal: 1.5)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 1.5
        notificationService.stub.getSettings_returnValue = .init(isOn: false, start: nil, stop: nil, frequency: nil)
        await sut.perform(action: .didAppear)
        
        dayService.stub.decreaseGoal_returnValue = .success(1)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 1
        await sut.perform(action: .didTapDecrementGoal)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 1,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(dayService.spy.lastMethodCall, .decrease(goal: 0.5))
    }
    
    func test_dismissAlert() async {
        sut.viewModel = .init(
            isLoading: false,
            isDarkModeOn: false,
            unitSystem: .metric,
            goal: 0,
            notifications: nil,
            appVersion: "0.0.0-mock",
            error: .cantOpenUrl
        )
        await sut.perform(action: .dismissAlert)
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil
            )
        )
    }
    
    func test_dismissAlert_forMissing() async {
        notificationService.stub.enableWithFrequencyStartStop_returnValue = .failure(.missingReminders)
        await sut.perform(action: .didSetReminders(true))
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: .missingReminders
            )
        )
        await sut.perform(action: .dismissAlert)
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0-mock",
                error: nil
            )
        )
    }
}

private extension SettingsPresentationTests {
    func givenRanges(with now: Date, minFrequency: Int, start: (start: Date, end: Date), end: (start: Date, end: Date)) {
        dateService.stub.now_returnValue = now
        
        notificationService.stub.minimumAllowedFrequency_returnValue = minFrequency
        
        dateService.stub.getStartDate_returnValue = start.start
        dateService.stub.getEndDate_returnValue = end.end
        
        dateService.stub.getDateValueComponentDate_returnValue = start.end
        dateService.stub.getDateValueComponentDate_returnValue = end.start
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

extension NotificationServiceTypeSpy.MethodCall: Equatable {
    public static func == (lhs: NotificationServiceTypeSpy.MethodCall, rhs: NotificationServiceTypeSpy.MethodCall) -> Bool {
        switch (lhs, rhs) {
        case let (.enable(lhsFrequency, lhsStart, lhsStop), .enable(rhsFrequency, rhsStart, rhsStop)):
            lhsFrequency == rhsFrequency &&
            lhsStart == rhsStart &&
            lhsStop == rhsStop
        case (.disable, .disable), (.getSettings, .getSettings):
            true
        default:
            false
        }
    }
}

extension UnitServiceTypeSpy.MethodCall: Equatable {
    public static func == (lhs: UnitServiceTypeSpy.MethodCall, rhs: UnitServiceTypeSpy.MethodCall) -> Bool {
        switch (lhs, rhs) {
        case let (.set(lhsUnitSystem), .set(rhsUnitSystem)):
            lhsUnitSystem == rhsUnitSystem
        case (.getUnitSystem, .getUnitSystem):
            true
        case let (.convert(lhsValue, lhsFromUnit, lhsToUnit), .convert(rhsValue, rhsFromUnit, rhsToUnit)):
            lhsValue == rhsValue &&
            lhsFromUnit == rhsFromUnit &&
            lhsToUnit == rhsToUnit
        default:
            false
        }
    }
}

extension Screen.Settings.Presenter.ViewModel: CustomStringConvertible {
    public var description: String {
        """

isLoading: \(isLoading),
isDarkModeOn: \(isDarkModeOn),
unitSystem: \(unitSystem),
goal: \(goal),
notifications: {
    frequency: \(String(describing: notifications?.frequency)),
    start: \(String(describing: notifications?.start)),
    startRange: \(String(describing: notifications?.startRange)),
    stop: \(String(describing: notifications?.stop)),
    stopRange: \(String(describing: notifications?.stopRange))
},
appVersion: \(appVersion),
error: \(String(describing: error))

"""
    }
}
