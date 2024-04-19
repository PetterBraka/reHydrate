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
@testable import PresentationKit

final class SettingsPresentationTests: XCTestCase {
    fileprivate typealias Sut = Screen.Settings.Presenter
    private var sut: Sut!
    
    private var engine: EngineMocks!
    private var router: RouterSpy!
    private var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    private var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    private var unitService: (stub: UnitServiceTypeStubbing, spy: UnitServiceTypeSpying)!
    
    override func setUp() {
        engine = EngineMocks()
        router = RouterSpy()
        
        dayService = engine.makeDayService()
        unitService = engine.makeUnitService()
        dateService = engine.makeDateService()
    }
    
    
    func test_didTapBack() async {
        let sut = Sut(engine: engine, router: router)
        await sut.perform(action: .didTapBack)
        
        XCTAssertEqual(router.log, [.showHome])
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
}
