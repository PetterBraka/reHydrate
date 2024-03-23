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
import UnitService
import DateServiceMocks
@testable import PresentationKit

final class HomePresentationTests: XCTestCase {
    private var sut: Screen.Home.Presenter!
    
    private var engine: EngineMocks!
    private var router: RouterSpy!
    private var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    private var drinksService: (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying)!
    private var healthService: (stub: HealthInterfaceStubbing, spy: HealthInterfaceSpying)!
    private var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    
    override func setUp() {
        engine = EngineMocks()
        router = RouterSpy()
        
        dayService = engine.makeDayService()
        drinksService = engine.makeDrinksService()
        healthService = engine.makeHealthService()
        engine.unitService = UnitService(engine: engine) // Using real UnitService to not over-stub
        dateService = engine.makeDateService()
    }
    
    override func tearDown() {
        sut = nil
        engine = nil
        router = nil
        dayService = nil
        drinksService = nil
        healthService = nil
        dateService = nil
    }
}

// MARK: - init
extension HomePresentationTests {
    func test_init() {
        dateService.stub.now_returnValue = .init(year: 2023, month: 2, day: 2)
        sut = Screen.Home.Presenter(engine: engine, router: router)
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb", consumption: 0, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: []
            )
        )
    }
}

// MARK: - didAppear
extension HomePresentationTests {
    func test_performAction_didAppear_healthIsNotSupported() async {
        let givenDate = Date(year: 2023, month: 2, day: 3)
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        healthService.stub.isSupported_returnValue = false
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(router.log, [])
        
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
    
    func test_performAction_didAppear_withHealthInSync() async {
        let givenDate = Date(year: 2023, month: 2, day: 3)
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        healthService.stub.isSupported_returnValue = true
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .success(1)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [
            .shouldRequestAccess_for,
            .readSum_start_end_intervalComponents
        ])
        XCTAssertEqual(router.log, [])
        
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
    
    func test_performAction_didAppear_withNoHealthData() async {
        let givenDate = Date(year: 2023, month: 2, day: 3)
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        healthService.stub.isSupported_returnValue = true
        healthService.stub.isSupported_returnValue = true
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .success(0)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported, .isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [
            .shouldRequestAccess_for,
            .readSum_start_end_intervalComponents,
            .export_quantity_id_date
        ])
        XCTAssertEqual(router.log, [])
        
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
    
    func test_performAction_didAppear_withMoreHealthData() async {
        let givenDate = Date(year: 2023, month: 2, day: 3)
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        healthService.stub.isSupported_returnValue = true
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .success(2)
        dayService.stub.addDrink_returnValue = .success(2)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [
            .shouldRequestAccess_for,
            .readSum_start_end_intervalComponents,
        ])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 2, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [
                    .init(id: "1", size: 100, container: .small),
                    .init(id: "2", size: 200, container: .medium),
                    .init(id: "3", size: 300, container: .large)
                ]
            )
        )
    }
    
    func test_performAction_didAppear_withNoDrinks() async {
        let givenDate = Date(year: 2023, month: 2, day: 3)
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([])
        drinksService.stub.resetToDefault_returnValue = [.init(id: "id", size: 100,
                                                               container: .small)]
        healthService.stub.isSupported_returnValue = false
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .resetToDefault])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "id", size: 100, container: .small)]
            )
        )
    }
    
    func test_performAction_didAppear_withNoDay() async {
        let givenDate = Date(year: 2023, month: 2, day: 3)
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([])
        drinksService.stub.resetToDefault_returnValue = [.init(id: "id", size: 100,
                                                               container: .small)]
        healthService.stub.isSupported_returnValue = false
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .resetToDefault])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "id", size: 100, container: .small)]
            )
        )
    }
}

// MARK: - didTapHistory
extension HomePresentationTests {
    func test_performAction_didTapHistory() async {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapHistory)
        XCTAssertEqual(router.log, [.showHistory])
    }
}

// MARK: - didTapSettings
extension HomePresentationTests {
    func test_performAction_didTapSettings() async {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapSettings)
        XCTAssertEqual(router.log, [.showSettings])
    }
}

// MARK: - didTapEditDrink
extension HomePresentationTests {
    func test_performAction_didTapEditDrink() async {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapEditDrink(.init(id: "1", size: 100, container: .medium)))
        XCTAssertEqual(router.log, [.showEdit(.init(id: "1", size: 100, container: .medium))])
    }
}

// MARK: - didTapAddDrink
extension HomePresentationTests {
    func test_performAction_didTapAddDrink_withNoHealthSupport() async {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        healthService.stub.isSupported_returnValue = false
        dayService.stub.addDrink_returnValue = .success(0.1)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapAddDrink(.init(id: "1", size: 100, container: .small)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.1, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapAddDrink_withHealthSupport() async {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        healthService.stub.isSupported_returnValue = true
        dayService.stub.addDrink_returnValue = .success(0.1)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapAddDrink(.init(id: "1", size: 100, container: .small)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [.export_quantity_id_date])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.1, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapAddDrink_withHealthError() async {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        healthService.stub.isSupported_returnValue = true
        healthService.stub.exportQuantityIdDate_returnValue = DummyError()
        dayService.stub.addDrink_returnValue = .success(0.1)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapAddDrink(.init(id: "1", size: 100, container: .small)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [.export_quantity_id_date])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.1, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapAddDrink_unknownDrink() async {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        healthService.stub.isSupported_returnValue = false
        dayService.stub.addDrink_returnValue = .success(0.5)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapAddDrink(.init(id: "123", size: 500, container: .large)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.5, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapAddDrink_failedAdding() async {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        healthService.stub.isSupported_returnValue = false
        dayService.stub.addDrink_returnValue = .failure(DummyError())
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapAddDrink(.init(id: "123", size: 500, container: .large)))
        
        XCTAssertEqual(healthService.spy.variableLog, [])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: []
            )
        )
    }
}

// MARK: - didTapRemoveDrink
extension HomePresentationTests {
    func test_performAction_didTapRemoveDrink_withNoHealthSupport() async {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        healthService.stub.isSupported_returnValue = false
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        dayService.stub.removeDrink_returnValue = .success(0.9)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "1", size: 100, container: .small)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.9, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapRemoveDrink_withHealthSupport() async {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        healthService.stub.isSupported_returnValue = true
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        dayService.stub.removeDrink_returnValue = .success(0.9)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "1", size: 100, container: .small)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [.export_quantity_id_date])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.9, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapRemoveDrink_withHealthError() async {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        healthService.stub.isSupported_returnValue = true
        healthService.stub.exportQuantityIdDate_returnValue = DummyError()
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        dayService.stub.removeDrink_returnValue = .success(0.9)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "1", size: 100, container: .small)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [.export_quantity_id_date])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.9, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapRemoveDrink_unknownDrink() async {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        healthService.stub.isSupported_returnValue = false
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        dayService.stub.removeDrink_returnValue = .success(0.9)
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "123", size: 500, container: .large)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.9, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapRemoveDrink_failedAdding() async {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        healthService.stub.isSupported_returnValue = false
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        dayService.stub.removeDrink_returnValue = .failure(DummyError())
        
        sut = .init(engine: engine, router: router)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "123", size: 500, container: .large)))
        
        XCTAssertEqual(healthService.spy.variableLog, [])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(router.log, [])
        
        XCTAssertEqual(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: []
            )
        )
    }
}
