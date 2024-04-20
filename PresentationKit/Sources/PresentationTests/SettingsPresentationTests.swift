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
    private var userPreferenceService: (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying)!
    
    override func setUp() {
        engine = EngineMocks()
        router = RouterSpy()
        
        dayService = engine.makeDayService()
        unitService = engine.makeUnitService()
        dateService = engine.makeDateService()
        userPreferenceService = engine.makeUserPreferenceService()
    }
    
    
    func test_didTapBack() async {
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didTapBack)
        
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
}
