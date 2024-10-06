//
//  SettingsPresentationTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 24/02/2024.
//

import XCTest
import TestHelper
import PortsInterface
import PortsMocks
import EngineMocks
import DayServiceMocks
import UnitServiceMocks
import DateServiceMocks
import UserNotificationServiceMocks
import UserPreferenceServiceMocks
import PhoneCommsMocks
@testable import PresentationKit

final class SettingsPresentationTests: XCTestCase {
    fileprivate typealias Sut = Screen.Settings.Presenter
    private var sut: Sut!
    
    private var engine: EngineMocks!
    private var router: RouterSpy!
    private var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    private var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    private var unitService: (stub: UnitServiceTypeStubbing, spy: UnitServiceTypeSpying)!
    private var userNotificationService: (stub: UserNotificationServiceTypeStubbing, spy: UserNotificationServiceTypeSpying)!
    private var userPreferenceService: (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying)!
    private var urlService: (stub: OpenUrlInterfaceStubbing, spy: OpenUrlInterfaceSpying)!
    private var phoneComms: (stub: PhoneCommsTypeStubbing, spy: PhoneCommsTypeSpying)!
    
    override func setUp() {
        engine = EngineMocks()
        router = RouterSpy()
        
        dayService = engine.makeDayService()
        unitService = engine.makeUnitService()
        dateService = engine.makeDateService()
        userNotificationService = engine.makeUserNotificationService()
        userPreferenceService = engine.makeUserPreferenceService()
        urlService = engine.makeOpenUrlService()
        phoneComms = engine.makePhoneComms()
        
        sut = Sut(engine: engine, router: router)
    }
    
    override func tearDown() {
        engine = nil
        router = nil
        
        dayService = nil
        unitService = nil
        dateService = nil
        userNotificationService = nil
        userPreferenceService = nil
        urlService = nil
        
        sut = nil
    }
    
    func test_didAppear() async {
        dayService.stub.getToday_returnValue = .init(date: .december_8_2021_Wednesday, consumed: 0, goal: 0)
        await sut.perform(action: .didAppear)
        XCTAssertEqual(
            sut.viewModel,
                .init(isLoading: false,
                      isDarkModeOn: false,
                      unitSystem: .metric,
                      goal: 0,
                      notifications: nil,
                      appVersion: "0.0.0",
                      error: nil)
        )
        XCTAssertEqual(phoneComms.spy.methodLog, [])
    }
    
    func test_didAppear_withGoal() async {
        dayService.stub.getToday_returnValue = .init(date: .december_8_2021_Wednesday, consumed: 1, goal: 2)
        
        await sut.perform(action: .didAppear)
        XCTAssertEqual(
            sut.viewModel,
            .init(isLoading: false,
                  isDarkModeOn: false,
                  unitSystem: .metric,
                  goal: 2,
                  notifications: nil,
                  appVersion: "0.0.0",
                  error: nil)
        )
        
        XCTAssertEqual(unitService.spy.methodLog, [.getUnitSystem])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
    }
    
    func test_didAppear_withImperialGoal() async {
        dayService.stub.getToday_returnValue = .init(date: .december_8_2021_Wednesday, consumed: 1, goal: 3.52)
        unitService.stub.getUnitSystem_returnValue = .imperial
        
        await sut.perform(action: .didAppear)
        XCTAssertEqual(
            sut.viewModel,
            .init(isLoading: false,
                  isDarkModeOn: false,
                  unitSystem: .imperial,
                  goal: 3.52,
                  notifications: nil,
                  appVersion: "0.0.0",
                  error: nil)
        )
        
        XCTAssertEqual(unitService.spy.lastMethodCall, .getUnitSystem)
        XCTAssertEqual(phoneComms.spy.methodLog, [])
    }
    
    func test_didAppear_withNotificationSettings() async {
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59),
            frequency: 30
        )
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59),
            frequency: 30
        )
        dayService.stub.getToday_returnValue = .init(date: .december_8_2021_Wednesday, consumed: 0, goal: 0)
        
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
                    stop: Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
                  ),
                  appVersion: "0.0.0",
                  error: nil)
        )
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [.showHome])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [.showAppIcon])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [.showCredits])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(
            urlService.spy.methodLog,
            [.email(
                email: "Petter.braka+reHydrate@gmail.com", cc: nil, bcc: nil,
                subject: "reHydrate query - v0.0.0", body: nil
            )]
        )
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(urlService.spy.methodLog, 
                       [.open(url: URL(string: "https://github.com/PetterBraka/reHydrate/blob/master/Privacy-Policy.md")!)])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(urlService.spy.methodLog, 
                       [.open(url: URL(string:"https://www.instagram.com/braka.coding/")!)])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(urlService.spy.methodLog, 
                       [.open(url: URL(string:"https://www.redbubble.com/people/petter-braka/shop")!)])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(urlService.spy.methodLog, [.open(url: URL(string: "prefs:root=reHydrate")!)])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(phoneComms.spy.methodLog, [.sendDataToWatch])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(phoneComms.spy.methodLog, [.sendDataToWatch])
    }
    
    func test_didSetReminders_on() async {
        userNotificationService.stub.minimumAllowedFrequency_returnValue = 5
        userNotificationService.stub.getSettings_returnValue = .init(isOn: false, start: nil, stop: nil, frequency: nil)
        dateService.stub.dateHoursMinutesSecondsDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0)
        dateService.stub.dateHoursMinutesSecondsDate_returnValue = Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.now_returnValue = Date(year: 2021, month: 12, day: 8)
        
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
                    stop: Date(year: 2021, month: 12, day: 8, hours: 23, minutes: 59, seconds: 59)
                ),
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
    }
    
    func test_didSetReminders_off() async {
        userNotificationService.stub.getSettings_returnValue = .init(
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(phoneComms.spy.methodLog, [])
    }
    
    func test_didSetRemindersStart_to12() async {
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 5
        )
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 0, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 5
        )
        
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
                    stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0)
                ),
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(userNotificationService.spy.lastMethodCall,
                       .enable(withFrequency: 5, 
                               start: Date(year: 2021, month: 12, day: 8,
                                           hours: 12, minutes: 0, seconds: 0),
                               stop: Date(year: 2021, month: 12, day: 8,
                                          hours: 21, minutes: 0, seconds: 0)))
        XCTAssertEqual(phoneComms.spy.methodLog, [])
    }
    
    func test_didSetRemindersStop_to20() async {
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 22, minutes: 0, seconds: 0),
            frequency: 5
        )
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 22, minutes: 0, seconds: 0),
            frequency: 5
        )
        
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
                    stop: Date(year: 2021, month: 12, day: 8, hours: 20, minutes: 0, seconds: 0)
                ),
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(userNotificationService.spy.lastMethodCall,
                       .enable(withFrequency: 5,
                               start: Date(year: 2021, month: 12, day: 8,
                                           hours: 7, minutes: 0, seconds: 0),
                               stop: Date(year: 2021, month: 12, day: 8,
                                          hours: 20, minutes: 0, seconds: 0)))
        XCTAssertEqual(phoneComms.spy.methodLog, [])
    }
    
    func test_didTapIncrementFrequency() async {
        userNotificationService.stub.minimumAllowedFrequency_returnValue = 5
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 5
        )
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 5
        )
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 5
        )
        userNotificationService.stub.enableWithFrequencyStartStop_returnValue = .success(Void())
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
                    stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0)
                ),
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(
            userNotificationService.spy.lastMethodCall,
            .enable(withFrequency: 10,
                    start: Date(year: 2021, month: 12, day: 8,
                                hours: 7, minutes: 0, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8,
                               hours: 21, minutes: 0, seconds: 0))
        )
        XCTAssertEqual(phoneComms.spy.methodLog, [])
    }
    
    func test_didTapDecrementFrequency() async {
        userNotificationService.stub.minimumAllowedFrequency_returnValue = 5
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 15
        )
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 15
        )
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: true,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 15
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
                    frequency: 10,
                    start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0)
                ),
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(
            userNotificationService.spy.lastMethodCall,
            .enable(withFrequency: 10,
                    start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0))
        )
        XCTAssertEqual(phoneComms.spy.methodLog, [])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(dayService.spy.lastMethodCall, .increase(goal: 0.5))
        XCTAssertEqual(phoneComms.spy.methodLog, [.sendDataToWatch])
    }
    
    func test_didTapIncrementGoal_afterDidLoad() async {
        dayService.stub.getToday_returnValue = .init(date: .december_8_2021_Wednesday, consumed: 0, goal: 1.5)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 1.5
        userNotificationService.stub.getSettings_returnValue = .init(isOn: false, start: nil, stop: nil, frequency: nil)
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(dayService.spy.lastMethodCall, .increase(goal: 0.5))
        XCTAssertEqual(phoneComms.spy.methodLog, [.sendDataToWatch])
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(dayService.spy.lastMethodCall, .decrease(goal: 0.5))
        XCTAssertEqual(phoneComms.spy.methodLog, [.sendDataToWatch])
    }
    
    func test_didTapDecrementGoal_afterDidLoad() async {
        dayService.stub.getToday_returnValue = .init(date: .december_8_2021_Wednesday, consumed: 0, goal: 1.5)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 1.5
        userNotificationService.stub.getSettings_returnValue = .init(isOn: false, start: nil, stop: nil, frequency: nil)
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
                appVersion: "0.0.0",
                error: nil)
        )
        XCTAssertEqual(router.log, [])
        XCTAssertEqual(dayService.spy.lastMethodCall, .decrease(goal: 0.5))
        XCTAssertEqual(phoneComms.spy.methodLog, [.sendDataToWatch])
    }
    
    func test_dismissAlert() async {
        userNotificationService.stub.minimumAllowedFrequency_returnValue = 30
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: false,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 30
        )
        await sut.perform(action: .dismissAlert)
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: .init(
                    frequency: 30,
                    start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0)
                ),
                appVersion: "0.0.0",
                error: nil
            )
        )
        XCTAssertEqual(phoneComms.spy.methodLog, [])
    }
    
    func test_dismissAlert_forMissing() async {
        userNotificationService.stub.enableWithFrequencyStartStop_returnValue = .failure(.missingReminders)
        await sut.perform(action: .didSetReminders(true))
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: "0.0.0",
                error: .missingReminders
            )
        )
        userNotificationService.stub.minimumAllowedFrequency_returnValue = 30
        userNotificationService.stub.getSettings_returnValue = .init(
            isOn: false,
            start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
            stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0),
            frequency: 30
        )
        await sut.perform(action: .dismissAlert)
        XCTAssertEqual(
            sut.viewModel,
            .init(
                isLoading: false,
                isDarkModeOn: false,
                unitSystem: .metric,
                goal: 0,
                notifications: .init(
                    frequency: 30,
                    start: Date(year: 2021, month: 12, day: 8, hours: 7, minutes: 0, seconds: 0),
                    stop: Date(year: 2021, month: 12, day: 8, hours: 21, minutes: 0, seconds: 0)
                ),
                appVersion: "0.0.0",
                error: nil
            )
        )
        XCTAssertEqual(phoneComms.spy.methodLog, [])
    }
}

extension OpenUrlInterfaceSpy.MethodCall: @retroactive Equatable {
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

extension UserNotificationServiceTypeSpy.MethodCall: @retroactive Equatable {
    public static func == (lhs: UserNotificationServiceTypeSpy.MethodCall, rhs: UserNotificationServiceTypeSpy.MethodCall) -> Bool {
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

extension UnitServiceTypeSpy.MethodCall: @retroactive Equatable {
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
    stop: \(String(describing: notifications?.stop)),
},
appVersion: \(appVersion),
error: \(String(describing: error))

"""
    }
}

extension EngineMocks: @retroactive HasAppInfo {
    public var appVersion: String {
        "0.0.0"
    }
}
