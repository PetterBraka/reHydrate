//
//  HomePresentationTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 24/02/2024.
//

import XCTest
import TestHelper
import EngineMocks
import DayServiceMocks
import DrinkServiceMocks
import PortsMocks
import UnitServiceMocks
import DateServiceMocks
@testable import PresentationKit

final class HomePresentationTests: XCTestCase {
    private var sut: Screen.Home.Presenter!
    
    private var router: RouterSpy!
    private var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    private var drinksService: (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying)!
    private var healthService: (stub: HealthInterfaceStubbing, spy: HealthInterfaceSpying)!
    private var unitService: (stub: UnitServiceTypeStubbing, spy: UnitServiceTypeSpying)!
    private var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    
    private let expectedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd MMM"
        return formatter
    }()

    override func setUp() {
        let engine = EngineMocks()
        let router = RouterSpy()
        
        dayService = engine.makeDayService()
        drinksService = engine.makeDrinksService()
        healthService = engine.makeHealthService()
        unitService = engine.makeUnitService()
        dateService = engine.makeDateService()
        
        dateService.stub.now_returnValue = .init(year: 2023, month: 2, day: 2)
        sut = Screen.Home.Presenter(engine: engine, router: router)
    }
    
    override func tearDown() {
        sut = nil
        router = nil
        dayService = nil
        drinksService = nil
        healthService = nil
        unitService = nil
        dateService = nil
    }
    
    func test_init() {
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb", consumption: 0, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: []
            )
        )
    }
    
    func test_performAction_didAppear() async throws {
        let givenDate = Date(year: 2023, month: 2, day: 3)
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        unitService.stub.getUnitSystem_returnValue = .metric
        unitService.stub.convertValueFromUnitToUnit_returnValue = 1
        unitService.stub.convertValueFromUnitToUnit_returnValue = 2
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        unitService.stub.convertValueFromUnitToUnit_returnValue = 100
        unitService.stub.convertValueFromUnitToUnit_returnValue = 200
        unitService.stub.convertValueFromUnitToUnit_returnValue = 300
        
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [
                    .init(id: "1", size: 100, container: .small),
                    .init(id: "2", size: 200, container: .medium),
                    .init(id: "3", size: 300, container: .large)
                ]
            )
        )
    }
}
