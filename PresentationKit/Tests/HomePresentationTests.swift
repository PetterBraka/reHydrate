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
import DrinkServiceInterface
import PortsMocks
import DateServiceMocks
import PhoneCommsMocks
import UnitService
import UnitServiceMocks
import UnitServiceInterface
import UserPreferenceServiceMocks
import PresentationInterface
@testable import PresentationKit

final class HomePresentationTests: XCTestCase {
    fileprivate typealias Sut = Screen.Home.Presenter
    private var sut: Sut!
    private var formatter: DateFormatter!
    
    private var engine: EngineMocks!
    private var router: RouterSpy!
    private var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    private var drinksService: (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying)!
    private var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    private var healthService: (stub: HealthInterfaceStubbing, spy: HealthInterfaceSpying)!
    private var phoneComms: (stub: PhoneCommsTypeStubbing, spy: PhoneCommsTypeSpying)!
    private var userPreferenceService: (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying)!
    private var unitService: (realObject: UnitServiceType, spy: UnitServiceTypeSpying)!
    
    override func setUp() {
        engine = EngineMocks()
        router = RouterSpy()
        formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd MMM"
        formatter.locale = .init(identifier: "en_GB")
        
        dayService = engine.makeDayService()
        drinksService = engine.makeDrinksService()
        healthService = engine.makeHealthService()
        dateService = engine.makeDateService()
        phoneComms = engine.makePhoneComms()
        userPreferenceService = engine.makeUserPreferenceService()
        unitService = engine.makeUnitService(UnitService(engine: engine)) // Using real UnitService to not over-stub
    }
    
    override func tearDown() {
        sut = nil
        engine = nil
        router = nil
        dayService = nil
        drinksService = nil
        healthService = nil
        dateService = nil
        phoneComms = nil
        userPreferenceService = nil
    }
}

// MARK: - init / deinit
extension HomePresentationTests {
    func test_init() throws {
        dateService.stub.now_returnValue = .init(year: 2023, month: 2, day: 2)
        sut = Sut(engine: engine, router: router, formatter: formatter)
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb", consumption: 0, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: []
            )
        )
        XCTAssertEqual(phoneComms.spy.variableLog.count, 0)
        XCTAssertEqual(phoneComms.spy.methodLog, [.addObserverUpdateBlock(updateBlock: {})])
    }
    
    func test_deinit() {
        dateService.stub.now_returnValue = .init(year: 2023, month: 2, day: 2)
        _ = Sut(engine: engine, router: router, formatter: formatter)
        
        XCTAssertEqual(phoneComms.spy.variableLog.count, 0)
        XCTAssertEqual(phoneComms.spy.methodLog, [.addObserverUpdateBlock(updateBlock: {}), .removeObserver])
    }
}

// MARK: - didAppear
extension HomePresentationTests {
    func test_performAction_didAppear_healthSyncFails() async throws {
        let startDate = Date(year: 2023, month: 2, day: 3)
        let endDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.now_returnValue = startDate
        dateService.stub.getStartDate_returnValue = startDate
        dateService.stub.getEndDate_returnValue = endDate
        dayService.stub.getToday_returnValue = .init(date: startDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .failure(DummyError())
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didAppear)
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.getToday],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now, .now, .getStartDate, .getEndDate],
            healthMethodNameLog: [.readSumDataStartEndIntervalComponents],
            phoneMethodNameLog: [.addObserverUpdateBlock],
            userPrefMethodNameLog: [.getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .convertValueFromUnitToUnit, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [
                    .init(id: "1", size: 100, fill: 0.25, container: .small),
                    .init(id: "2", size: 200, fill: 0.29, container: .medium),
                    .init(id: "3", size: 300, fill: 0.25, container: .large)
                ]
            )
        )
    }
    
    func test_performAction_didAppear_withHealthInSync() async throws {
        let startDate = Date(year: 2023, month: 2, day: 3)
        let endDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.now_returnValue = startDate
        dateService.stub.getStartDate_returnValue = startDate
        dateService.stub.getEndDate_returnValue = endDate
        dayService.stub.getToday_returnValue = .init(date: startDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .success(1)
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didAppear)
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.getToday],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now, .now, .getStartDate, .getEndDate],
            healthMethodNameLog: [.readSumDataStartEndIntervalComponents],
            phoneMethodNameLog: [.addObserverUpdateBlock],
            userPrefMethodNameLog: [.getKey, .getKey, .getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .convertValueFromUnitToUnit, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [
                    .init(id: "1", size: 100, fill: 0.25, container: .small),
                    .init(id: "2", size: 200, fill: 0.29, container: .medium),
                    .init(id: "3", size: 300, fill: 0.25, container: .large)
                ]
            )
        )
    }
    
    func test_performAction_didAppear_withNoHealthData() async throws {
        let startDate = Date(year: 2023, month: 2, day: 3)
        let endDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.now_returnValue = startDate
        dateService.stub.getStartDate_returnValue = startDate
        dateService.stub.getEndDate_returnValue = endDate
        dayService.stub.getToday_returnValue = .init(date: startDate, consumed: 1, goal: 2)
        dayService.stub.removeDrink_returnValue = .success(0)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .success(0)
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didAppear)
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.getToday, .removeDrink],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now, .now, .getStartDate, .getEndDate],
            healthMethodNameLog: [.readSumDataStartEndIntervalComponents],
            phoneMethodNameLog: [.addObserverUpdateBlock],
            userPrefMethodNameLog: [.getKey, .getKey, .getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .convertValueFromUnitToUnit, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 0, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [
                    .init(id: "1", size: 100, fill: 0.25, container: .small),
                    .init(id: "2", size: 200, fill: 0.29, container: .medium),
                    .init(id: "3", size: 300, fill: 0.25, container: .large)
                ]
            )
        )
    }
    
    func test_performAction_didAppear_withMoreHealthData() async throws {
        let startDate = Date(year: 2023, month: 2, day: 3)
        let endDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.now_returnValue = startDate
        dateService.stub.getStartDate_returnValue = startDate
        dateService.stub.getEndDate_returnValue = endDate
        dayService.stub.getToday_returnValue = .init(date: startDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])

        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .success(2)
        dayService.stub.addDrink_returnValue = .success(2)
        
        let givenStartDate = Date(year: 2023, month: 2, day: 3, hours: 0, minutes: 0, seconds: 0)
        let givenEndDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.getStartDate_returnValue = givenStartDate
        dateService.stub.getEndDate_returnValue = givenEndDate
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didAppear)
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.getToday, .addDrink],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now, .now, .getStartDate, .getEndDate],
            healthMethodNameLog: [.readSumDataStartEndIntervalComponents],
            phoneMethodNameLog: [.addObserverUpdateBlock],
            userPrefMethodNameLog: [.getKey, .getKey, .getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .convertValueFromUnitToUnit, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 2, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [
                    .init(id: "1", size: 100, fill: 0.25, container: .small),
                    .init(id: "2", size: 200, fill: 0.29, container: .medium),
                    .init(id: "3", size: 300, fill: 0.25, container: .large)
                ]
            )
        )
    }
    
    func test_performAction_didAppear_withNoDrinks() async throws {
        let startDate = Date(year: 2023, month: 2, day: 3)
        let endDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.now_returnValue = startDate
        dateService.stub.getStartDate_returnValue = startDate
        dateService.stub.getEndDate_returnValue = endDate
        dayService.stub.getToday_returnValue = .init(date: startDate, consumed: 1, goal: 2)
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .success(1)
        drinksService.stub.getSaved_returnValue = .success([])
        drinksService.stub.resetToDefault_returnValue = [.init(id: "id", size: 100, container: .small)]
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didAppear)
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.getToday],
            drinksMethodNameLog: [.getSaved, .resetToDefault],
            dateMethodNameLog: [.now, .now, .getStartDate, .getEndDate],
            healthMethodNameLog: [.readSumDataStartEndIntervalComponents],
            phoneMethodNameLog: [.addObserverUpdateBlock],
            userPrefMethodNameLog: [.getKey, .getKey, .getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "id", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
}

// MARK: - didTapHistory
extension HomePresentationTests {
    func test_performAction_didTapHistory() async throws {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didTapHistory)
        assertLog(router.log, [.showHistory])
        assertService(
            dateMethodNameLog: [.now],
            phoneMethodNameLog: [.addObserverUpdateBlock]
        )
    }
}

// MARK: - didTapSettings
extension HomePresentationTests {
    func test_performAction_didTapSettings() async throws {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didTapSettings)
        assertLog(router.log, [.showSettings])
        assertService(
            dateMethodNameLog: [.now],
            phoneMethodNameLog: [.addObserverUpdateBlock]
        )
    }
}

// MARK: - didTapEditDrink
extension HomePresentationTests {
    func test_performAction_didTapEditDrink() async throws {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didTapEditDrink(.init(id: "1", size: 100, fill: 0.1, container: .medium)))
        assertLog(router.log, [.showEdit(.init(id: "1", size: 100, fill: 0.14, container: .medium))])
        assertService(
            dateMethodNameLog: [.now],
            phoneMethodNameLog: [.addObserverUpdateBlock],
            userPrefMethodNameLog: [.getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .convertValueFromUnitToUnit]
        )
    }
}

// MARK: - didTapAddDrink
extension HomePresentationTests {
    func test_performAction_didTapAddDrink_withHealthSupport() async throws {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        dateService.stub.now_returnValue = givenDate
        
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 0.1, goal: 2)
        dayService.stub.addDrink_returnValue = .success(0.1)
        drinksService.stub.getSaved_returnValue = .success([.init(id: "1", size: 100, container: .small)])
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .success(0.1)
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didTapAddDrink(.init(id: "1", size: 500, fill: 0.1, container: .large)))
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.addDrink, .getToday],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now, .now],
            healthMethodNameLog: [.exportQuantityIdDate],
            phoneMethodNameLog: [.addObserverUpdateBlock, .sendDataToWatch],
            userPrefMethodNameLog: [.getKey, .getKey, .getKey, .getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        XCTAssertEqual(healthService.spy.methodLog, [.exportQuantityIdDate(quantity: .init(unit: .litre, value: 0.5), id: .dietaryWater, date: givenDate)])
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapAddDrink_withHealthError() async throws {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        dateService.stub.now_returnValue = givenDate
        
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 0.1, goal: 2)
        dayService.stub.addDrink_returnValue = .success(0.1)
        drinksService.stub.getSaved_returnValue = .success([.init(id: "1", size: 100, container: .small)])
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didTapAddDrink(.init(id: "123", size: 500, fill: 0.1, container: .large)))
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.addDrink, .getToday],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now, .now],
            healthMethodNameLog: [.exportQuantityIdDate],
            phoneMethodNameLog: [.addObserverUpdateBlock, .sendDataToWatch],
            userPrefMethodNameLog: [.getKey, .getKey, .getKey, .getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        XCTAssertEqual(healthService.spy.methodLog, [.exportQuantityIdDate(quantity: .init(unit: .litre, value: 0.5), id: .dietaryWater, date: givenDate)])
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapAddDrink_unknownDrink() async throws {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        dateService.stub.now_returnValue = givenDate
        
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 0.5, goal: 2)
        dayService.stub.addDrink_returnValue = .success(0.5)
        drinksService.stub.getSaved_returnValue = .success([.init(id: "1", size: 100, container: .small)])
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didTapAddDrink(.init(id: "123", size: 500, fill: 0.1, container: .large)))
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.addDrink, .getToday],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now, .now],
            healthMethodNameLog: [.exportQuantityIdDate],
            phoneMethodNameLog: [.addObserverUpdateBlock, .sendDataToWatch],
            userPrefMethodNameLog: [.getKey, .getKey, .getKey, .getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        XCTAssertEqual(healthService.spy.methodLog, [.exportQuantityIdDate(quantity: .init(unit: .litre, value: 0.5), id: .dietaryWater, date: givenDate)])
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.5, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapAddDrink_failedAdding() async throws {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        dayService.stub.addDrink_returnValue = .failure(DummyError())
        drinksService.stub.getSaved_returnValue = .success([.init(id: "1", size: 100, container: .small)])
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didTapAddDrink(.init(id: "123", size: 500, fill: 0.1, container: .large)))
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.addDrink, .getToday],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now],
            phoneMethodNameLog: [.addObserverUpdateBlock],
            userPrefMethodNameLog: [.getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
}

// MARK: - didTapRemoveDrink
extension HomePresentationTests {
    func test_performAction_didTapRemoveDrink_withHealthSupport() async throws {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        dateService.stub.now_returnValue = givenDate
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 0.9, goal: 2)
        dayService.stub.removeDrink_returnValue = .success(0.9)
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "1", size: 100, fill: 0.1, container: .small)))
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.removeDrink, .getToday],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now, .now],
            healthMethodNameLog: [.exportQuantityIdDate],
            phoneMethodNameLog: [.addObserverUpdateBlock, .sendDataToWatch],
            userPrefMethodNameLog: [.getKey, .getKey, .getKey, .getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        XCTAssertEqual(healthService.spy.methodLog, [.exportQuantityIdDate(quantity: .init(unit: .litre, value: -0.1), id: .dietaryWater, date: givenDate)])
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.9, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapRemoveDrink_withHealthError() async throws {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        dateService.stub.now_returnValue = givenDate
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .medium)
        ])

        healthService.stub.exportQuantityIdDate_returnValue = DummyError()
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 0.9, goal: 2)
        dayService.stub.removeDrink_returnValue = .success(0.9)
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "1", size: 100, fill: 0.1, container: .medium)))
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.removeDrink, .getToday],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now, .now],
            healthMethodNameLog: [.exportQuantityIdDate],
            phoneMethodNameLog: [.addObserverUpdateBlock, .sendDataToWatch],
            userPrefMethodNameLog: [.getKey, .getKey, .getKey, .getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        XCTAssertEqual(healthService.spy.methodLog, [.exportQuantityIdDate(quantity: .init(unit: .litre, value: -0.1), id: .dietaryWater, date: givenDate)])
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.9, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.14, container: .medium)]
            )
        )
    }
    
    func test_performAction_didTapRemoveDrink_unknownDrink() async throws {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 0.9, goal: 2)
        dayService.stub.removeDrink_returnValue = .success(0.9)
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small)
        ])
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "12", size: 200, fill: 0.25, container: .small)))
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.removeDrink, .getToday],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now, .now],
            healthMethodNameLog: [.exportQuantityIdDate],
            phoneMethodNameLog: [.addObserverUpdateBlock, .sendDataToWatch],
            userPrefMethodNameLog: [.getKey, .getKey, .getKey, .getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem, .getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        XCTAssertEqual(healthService.spy.methodLog, [.exportQuantityIdDate(quantity: .init(unit: .litre, value: -0.2), id: .dietaryWater, date: givenDate)])
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.9, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapRemoveDrink_failedAdding() async throws {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate

        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        dayService.stub.removeDrink_returnValue = .failure(DummyError())
        drinksService.stub.getSaved_returnValue = .success([.init(id: "1", size: 100, container: .small)])
        
        sut = .init(engine: engine, router: router, formatter: formatter)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "1", size: 100, fill: 0.25, container: .small)))
        
        assertLog(router.log, [])
        assertService(
            dayMethodNameLog: [.removeDrink, .getToday],
            drinksMethodNameLog: [.getSaved],
            dateMethodNameLog: [.now],
            phoneMethodNameLog: [.addObserverUpdateBlock],
            userPrefMethodNameLog: [.getKey, .getKey],
            unitMethodNameLog: [.getUnitSystem, .convertValueFromUnitToUnit, .getUnitSystem]
        )
        
        try assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
}

// MARK: Test helpers
private extension HomePresentationTests {
    func assertViewModel(
        _ givenViewModel: Sut.ViewModel, _ expectedViewModel: Sut.ViewModel,
        accuracy: Double = 0.01, file: StaticString = #file, line: UInt = #line
    ) throws {
        XCTAssertEqual(
            givenViewModel.consumption, expectedViewModel.consumption, accuracy: accuracy,
            "consumption", file: file, line: line
        )
        XCTAssertEqual(
            givenViewModel.goal, expectedViewModel.goal, accuracy: accuracy,
            "goal", file: file, line: line
        )
        for index in givenViewModel.drinks.indices {
            let givenDrink = try XCTUnwrap(givenViewModel.drinks[safe: index], file: file, line: line)
            let expectedDrink = try XCTUnwrap(expectedViewModel.drinks[safe: index], file: file, line: line)
            
            XCTAssertEqual(
                givenDrink.id, expectedDrink.id,
                "drinks[\(index)].id", file: file, line: line
            )
            XCTAssertEqual(
                givenDrink.size, expectedDrink.size, accuracy: accuracy,
                "drinks[\(index)].size", file: file, line: line
            )
            XCTAssertEqual(
                givenDrink.fill, expectedDrink.fill, accuracy: accuracy,
                "drinks[\(index)].fill", file: file, line: line
            )
            XCTAssertEqual(
                givenDrink.container, expectedDrink.container,
                "drinks[\(index)].container", file: file, line: line
            )
        }
    }
    
    func assertLog(
        _ givenLog: [RouterSpy.MethodCall], _ expectedLog: [RouterSpy.MethodCall],
        accuracy: Double = 0.01, file: StaticString = #file, line: UInt = #line
    ) {
        guard !givenLog.isEmpty, !expectedLog.isEmpty else {
            return
        }
        XCTAssertEqual(givenLog.count, expectedLog.count, file: file, line: line)
        for index in givenLog.indices {
            if case let .showEdit(givenDrink) = givenLog[index],
               case let .showEdit(expectedDrink) = expectedLog[index] {
                XCTAssertEqual(
                    givenDrink.id, expectedDrink.id,
                    "showEdit.drink.id", file: file, line: line
                )
                XCTAssertEqual(
                    givenDrink.size, expectedDrink.size, accuracy: accuracy,
                    "showEdit.drink.size", file: file, line: line
                )
                XCTAssertEqual(
                    givenDrink.fill, expectedDrink.fill, accuracy: accuracy,
                    "showEdit.drink.fill", file: file, line: line
                )
                XCTAssertEqual(
                    givenDrink.container, expectedDrink.container,
                    "showEdit.drink.container", file: file, line: line
                )
            } else {
                XCTAssertEqual(givenLog[index], expectedLog[index], file: file, line: line)
            }
        }
    }
    
    func assertService(
        dayVariableLog: [DayServiceTypeSpy.VariableName] = [],
        dayMethodNameLog: [DayServiceTypeSpy.MethodName] = [],
        drinksVariableLog: [DrinkServiceTypeSpy.VariableName] = [],
        drinksMethodNameLog: [DrinkServiceTypeSpy.MethodName] = [],
        dateVariableLog: [DateServiceTypeSpy.VariableName] = [],
        dateMethodNameLog: [DateServiceTypeSpy.MethodName] = [],
        healthVariableLog: [HealthInterfaceSpy.VariableName] = [],
        healthMethodNameLog: [HealthInterfaceSpy.MethodName] = [],
        phoneVariableLog: [PhoneCommsTypeSpy.VariableName] = [],
        phoneMethodNameLog: [PhoneCommsTypeSpy.MethodName] = [],
        userPrefVariableLog: [UserPreferenceServiceTypeSpy.VariableName] = [],
        userPrefMethodNameLog: [UserPreferenceServiceTypeSpy.MethodName] = [],
        unitVariableLog: [UnitServiceTypeSpy.VariableName] = [],
        unitMethodNameLog: [UnitServiceTypeSpy.MethodName] = [],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(dayService.spy.variableLog, dayVariableLog,
                       "dayService variable log", file: file, line: line)
        XCTAssertEqual(dayService.spy.methodNameLog, dayMethodNameLog,
                       "dayService methodName log", file: file, line: line)
        XCTAssertEqual(drinksService.spy.variableLog, drinksVariableLog,
                       "drinksService variable log", file: file, line: line)
        XCTAssertEqual(drinksService.spy.methodNameLog, drinksMethodNameLog,
                       "drinksService methodName log", file: file, line: line)
        XCTAssertEqual(dateService.spy.variableLog, dateVariableLog,
                       "dateService variable log", file: file, line: line)
        XCTAssertEqual(dateService.spy.methodNameLog, dateMethodNameLog,
                       "dateService methodName log", file: file, line: line)
        XCTAssertEqual(healthService.spy.variableLog, healthVariableLog,
                       "healthService variable log", file: file, line: line)
        XCTAssertEqual(healthService.spy.methodNameLog, healthMethodNameLog,
                       "healthService methodName log", file: file, line: line)
        XCTAssertEqual(phoneComms.spy.variableLog, phoneVariableLog,
                       "phoneComms variable log", file: file, line: line)
        XCTAssertEqual(phoneComms.spy.methodNameLog, phoneMethodNameLog,
                       "phoneComms methodName log", file: file, line: line)
        XCTAssertEqual(userPreferenceService.spy.variableLog, userPrefVariableLog,
                       "userPreferenceService variable log", file: file, line: line)
        XCTAssertEqual(userPreferenceService.spy.methodNameLog, userPrefMethodNameLog,
                       "userPreferenceService methodName log", file: file, line: line)
        XCTAssertEqual(unitService.spy.variableLog, unitVariableLog,
                       "unitService variable log", file: file, line: line)
        XCTAssertEqual(unitService.spy.methodNameLog, unitMethodNameLog,
                       "unitService methodName log", file: file, line: line)
    }
}
