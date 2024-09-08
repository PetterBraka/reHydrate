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
    fileprivate typealias Sut = Screen.Home.Presenter
    private var sut: Sut!
    private var formatter: DateFormatter!
    
    private var engine: EngineMocks!
    private var router: RouterSpy!
    private var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    private var drinksService: (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying)!
    private var healthService: (stub: HealthInterfaceStubbing, spy: HealthInterfaceSpying)!
    private var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    private var notificationCenter: NotificationCenter!
    
    override func setUp() {
        engine = EngineMocks()
        router = RouterSpy()
        formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd MMM"
        formatter.locale = .init(identifier: "en_GB")
        notificationCenter = .init()
        
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
        sut = Sut(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        
        assertViewModel(
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
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        assertLog(router.log, [])
        
        assertViewModel(
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
        let givenStartDate = Date(year: 2023, month: 2, day: 3, hours: 0, minutes: 0, seconds: 0)
        let givenEndDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.getStartDate_returnValue = givenStartDate
        dateService.stub.getEndDate_returnValue = givenEndDate
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [
            .shouldRequestAccess(healthDataType: [.water(.litre)]),
            .readSum(data: .water(.litre), start: givenStartDate, end: givenEndDate,
                     intervalComponents: .init(day: 1))
        ])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        assertLog(router.log, [])
        
        assertViewModel(
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
        
        let givenStartDate = Date(year: 2023, month: 2, day: 3, hours: 0, minutes: 0, seconds: 0)
        let givenEndDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.getStartDate_returnValue = givenStartDate
        dateService.stub.getEndDate_returnValue = givenEndDate
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported, .isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [
            .shouldRequestAccess(healthDataType: [.water(.litre)]),
            .readSum(data: .water(.litre), start: givenStartDate, end: givenEndDate,
                     intervalComponents: .init(day: 1)),
            .export(quantity: .init(unit: .litre, value: 1), id: .dietaryWater, date: .distantFuture),
        ])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        assertLog(router.log, [])
        
        assertViewModel(
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
        
        let givenStartDate = Date(year: 2023, month: 2, day: 3, hours: 0, minutes: 0, seconds: 0)
        let givenEndDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.getStartDate_returnValue = givenStartDate
        dateService.stub.getEndDate_returnValue = givenEndDate
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [
            .shouldRequestAccess(healthDataType: [.water(.litre)]),
            .readSum(data: .water(.litre), start: givenStartDate, end: givenEndDate,
                     intervalComponents: .init(day: 1)),
        ])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday, .add(drink: .init(id: "", size: 1000, container: .health))])
        assertLog(router.log, [])
        
        assertViewModel(
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
    
    func test_performAction_didAppear_withNoHealthAccess() async {
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
        healthService.stub.requestAuthReadAndWrite_returnValue = DummyError()
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .success(0)
        
        let givenStartDate = Date(year: 2023, month: 2, day: 3, hours: 0, minutes: 0, seconds: 0)
        let givenEndDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.getStartDate_returnValue = givenStartDate
        dateService.stub.getEndDate_returnValue = givenEndDate
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported, .isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [
            .shouldRequestAccess(healthDataType: [.water(.litre)]),
            .readSum(data: .water(.litre), start: givenStartDate, end: givenEndDate,
                     intervalComponents: .init(day: 1)),
            .export(quantity: .init(unit: .litre, value: 1), id: .dietaryWater, date: .distantFuture),
        ])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        assertLog(router.log, [])
        
        assertViewModel(
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
    
    func test_performAction_didAppear_withHealthFailed() async {
        let givenDate = Date(year: 2023, month: 2, day: 3)
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([.init(id: "1", size: 100, container: .small)])
        healthService.stub.isSupported_returnValue = true
        healthService.stub.isSupported_returnValue = true
        healthService.stub.requestAuthReadAndWrite_returnValue = DummyError()
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .failure(DummyError())
        
        let givenStartDate = Date(year: 2023, month: 2, day: 3, hours: 0, minutes: 0, seconds: 0)
        let givenEndDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.getStartDate_returnValue = givenStartDate
        dateService.stub.getEndDate_returnValue = givenEndDate
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported, .isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [
            .shouldRequestAccess(healthDataType: [.water(.litre)]),
            .readSum(data: .water(.litre), start: givenStartDate, end: givenEndDate,
                     intervalComponents: .init(day: 1)),
            .export(quantity: .init(unit: .litre, value: 1), id: .dietaryWater, date: .distantFuture),
        ])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
    
    func test_performAction_didAppear_withHealthNoAccess() async {
        let givenDate = Date(year: 2023, month: 2, day: 3)
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([.init(id: "1", size: 100, container: .small)])
        healthService.stub.isSupported_returnValue = true
        healthService.stub.isSupported_returnValue = true
        healthService.stub.shouldRequestAccessHealthDataType_returnValue = true
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .failure(DummyError())
        
        let givenStartDate = Date(year: 2023, month: 2, day: 3, hours: 0, minutes: 0, seconds: 0)
        let givenEndDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.getStartDate_returnValue = givenStartDate
        dateService.stub.getEndDate_returnValue = givenEndDate
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported, .isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [
            .shouldRequestAccess(healthDataType: [.water(.litre)]),
            .requestAuth(readAndWrite: [.water(.litre)]),
            .readSum(data: .water(.litre), start: givenStartDate, end: givenEndDate,
                     intervalComponents: .init(day: 1)),
            .export(quantity: .init(unit: .litre, value: 1), id: .dietaryWater, date: .distantFuture),
        ])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
    
    func test_performAction_didAppear_withHealthFailedAccess() async {
        let givenDate = Date(year: 2023, month: 2, day: 3)
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([.init(id: "1", size: 100, container: .small)])
        healthService.stub.isSupported_returnValue = true
        healthService.stub.isSupported_returnValue = true
        healthService.stub.shouldRequestAccessHealthDataType_returnValue = true
        healthService.stub.requestAuthReadAndWrite_returnValue = DummyError()
        healthService.stub.readSumDataStartEndIntervalComponents_returnValue = .failure(DummyError())
        
        let givenStartDate = Date(year: 2023, month: 2, day: 3, hours: 0, minutes: 0, seconds: 0)
        let givenEndDate = Date(year: 2023, month: 2, day: 3, hours: 23, minutes: 59, seconds: 59)
        dateService.stub.getStartDate_returnValue = givenStartDate
        dateService.stub.getEndDate_returnValue = givenEndDate
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported, .isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [
            .shouldRequestAccess(healthDataType: [.water(.litre)]),
            .requestAuth(readAndWrite: [.water(.litre)]),
            .readSum(data: .water(.litre), start: givenStartDate, end: givenEndDate,
                     intervalComponents: .init(day: 1)),
            .export(quantity: .init(unit: .litre, value: 1), id: .dietaryWater, date: .distantFuture),
        ])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
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
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .resetToDefault])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        assertLog(router.log, [])
        
        assertViewModel(
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

// MARK: - sync
extension HomePresentationTests {
    func test_performAction_sync_healthIsNotSupported() async {
        let givenDate = Date(year: 2023, month: 2, day: 3)
        dateService.stub.now_returnValue = givenDate
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        drinksService.stub.getSaved_returnValue = .success([.init(id: "1", size: 100, container: .small)])
        healthService.stub.isSupported_returnValue = false
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        let expectation = expectation(description: "syncing")
        sut.sync { 
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 2)
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Friday - 03 Feb",
                consumption: 1, goal: 2,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
}

// MARK: - didTapHistory
extension HomePresentationTests {
    func test_performAction_didTapHistory() async {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapHistory)
        assertLog(router.log, [.showHistory])
    }
}

// MARK: - didTapSettings
extension HomePresentationTests {
    func test_performAction_didTapSettings() async {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapSettings)
        assertLog(router.log, [.showSettings])
    }
}

// MARK: - didTapEditDrink
extension HomePresentationTests {
    func test_performAction_didTapEditDrink() async {
        dateService.stub.now_returnValue = Date(year: 2023, month: 2, day: 2)
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapEditDrink(.init(id: "1", size: 100, fill: 0.1, container: .medium)))
        assertLog(router.log, [.showEdit(.init(id: "1", size: 100, fill: 0.14, container: .medium))])
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
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapAddDrink(.init(id: "1", size: 100, fill: 0.1, container: .small)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(dayService.spy.methodLog, [.add(drink: .init(id: "1", size: 100, container: .small))])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.1, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
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
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapAddDrink(.init(id: "1", size: 100, fill: 0.1, container: .small)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [.export(quantity: .init(unit: .litre, value: 0.1), id: .dietaryWater, date: .distantFuture)])
        XCTAssertEqual(dayService.spy.methodLog, [.add(drink: .init(id: "1", size: 100, container: .small))])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.1, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
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
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapAddDrink(.init(id: "1", size: 100, fill: 0.1, container: .small)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [.export(quantity: .init(unit: .litre, value: 0.1), id: .dietaryWater, date: .distantFuture)])
        XCTAssertEqual(dayService.spy.methodLog, [.add(drink: .init(id: "1", size: 100, container: .small))])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.1, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
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
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapAddDrink(.init(id: "123", size: 500, fill: 0.1, container: .large)))

        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(dayService.spy.methodLog, [.add(drink: .init(id: "123", size: 500, container: .large))])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.5, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
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
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapAddDrink(.init(id: "123", size: 500, fill: 0.1, container: .large)))
        
        XCTAssertEqual(healthService.spy.variableLog, [])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(dayService.spy.methodLog, [.add(drink: .init(id: "123", size: 500, container: .large))])
        assertLog(router.log, [])
        
        assertViewModel(
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
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "1", size: 100, fill: 0.1, container: .small)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(dayService.spy.methodLog, [.remove(drink: .init(id: "1", size: 100, container: .small))])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.9, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
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
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "1", size: 100, fill: 0.1, container: .small)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [.export(quantity: .init(unit: .litre, value: 0.9), id: .dietaryWater, date: .distantFuture)])
        XCTAssertEqual(dayService.spy.methodLog, [.remove(drink: .init(id: "1", size: 100, container: .small))])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.9, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
            )
        )
    }
    
    func test_performAction_didTapRemoveDrink_withHealthError() async {
        let givenDate = Date(year: 2023, month: 2, day: 2)
        dateService.stub.now_returnValue = givenDate
        drinksService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .medium)
        ])
        healthService.stub.isSupported_returnValue = true
        healthService.stub.exportQuantityIdDate_returnValue = DummyError()
        dayService.stub.getToday_returnValue = .init(date: givenDate, consumed: 1, goal: 2)
        dayService.stub.removeDrink_returnValue = .success(0.9)
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "1", size: 100, fill: 0.1, container: .medium)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [.export(quantity: .init(unit: .litre, value: 0.9), id: .dietaryWater, date: .distantFuture)])
        XCTAssertEqual(dayService.spy.methodLog, [.remove(drink: .init(id: "1", size: 100, container: .medium))])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.9, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.14, container: .medium)]
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
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "123", size: 500, fill: 0.1, container: .large)))
        
        XCTAssertEqual(healthService.spy.variableLog, [.isSupported])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(dayService.spy.methodLog, [.remove(drink: .init(id: "123", size: 500, container: .large))])
        assertLog(router.log, [])
        
        assertViewModel(
            sut.viewModel,
            .init(
                dateTitle: "Thursday - 02 Feb",
                consumption: 0.9, goal: 0,
                smallUnit: .milliliters, largeUnit: .liters,
                drinks: [.init(id: "1", size: 100, fill: 0.25, container: .small)]
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
        
        sut = .init(engine: engine, router: router, formatter: formatter, notificationCenter: notificationCenter)
        await sut.perform(action: .didTapRemoveDrink(.init(id: "123", size: 500, fill: 0.1, container: .large)))
        
        XCTAssertEqual(healthService.spy.variableLog, [])
        XCTAssertEqual(healthService.spy.methodLog, [])
        XCTAssertEqual(dayService.spy.methodLog, [.remove(drink: .init(id: "123", size: 500, container: .large))])
        assertLog(router.log, [])
        
        assertViewModel(
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

private extension HomePresentationTests {
    func assertViewModel(
        _ givenViewModel: Sut.ViewModel, _ expectedViewModel: Sut.ViewModel,
        accuracy: Double = 0.01, file: StaticString = #file, line: UInt = #line
    ) {
        XCTAssertEqual(
            givenViewModel.consumption, expectedViewModel.consumption, accuracy: accuracy,
            "consumption", file: file, line: line
        )
        XCTAssertEqual(
            givenViewModel.goal, expectedViewModel.goal, accuracy: accuracy,
            "goal", file: file, line: line
        )
        for index in givenViewModel.drinks.indices {
            XCTAssertEqual(
                givenViewModel.drinks[index].id, expectedViewModel.drinks[index].id,
                "drinks[\(index)].id", file: file, line: line
            )
            XCTAssertEqual(
                givenViewModel.drinks[index].size, expectedViewModel.drinks[index].size, accuracy: accuracy,
                "drinks[\(index)].size", file: file, line: line
            )
            XCTAssertEqual(
                givenViewModel.drinks[index].fill, expectedViewModel.drinks[index].fill, accuracy: accuracy,
                "drinks[\(index)].fill", file: file, line: line
            )
            XCTAssertEqual(
                givenViewModel.drinks[index].container, expectedViewModel.drinks[index].container,
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
}

extension DrinkServiceTypeSpy.MethodCall: Equatable {
    public static func == (lhs: DrinkServiceTypeSpy.MethodCall, rhs: DrinkServiceTypeSpy.MethodCall) -> Bool {
        switch (lhs, rhs) {
        case let (.add(lhsSize, lhsContainer), .add(rhsSize, rhsContainer)):
            lhsSize == rhsSize && lhsContainer == rhsContainer
        case let (.edit(lhsSize, lhsDrink), .edit(rhsSize, rhsDrink)):
            lhsSize == rhsSize && lhsDrink == rhsDrink
        case let (.remove(lhsContainer), .remove(rhsContainer)):
            lhsContainer == rhsContainer
        case (.getSaved, .getSaved), (.resetToDefault, .resetToDefault):
            true
        case (.add, .edit),
            (.add, .remove),
            (.add, .getSaved),
            (.add, .resetToDefault),
            (.edit, .add),
            (.edit, .remove),
            (.edit, .getSaved),
            (.edit, .resetToDefault),
            (.remove, .add),
            (.remove, .edit),
            (.remove, .getSaved),
            (.remove, .resetToDefault),
            (.getSaved, .add),
            (.getSaved, .edit),
            (.getSaved, .remove),
            (.getSaved, .resetToDefault),
            (.resetToDefault, .add),
            (.resetToDefault, .edit),
            (.resetToDefault, .remove),
            (.resetToDefault, .getSaved):
            false
        }
    }
}


extension DayServiceTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.getToday, .getToday):
            true
        case let (.getDays(lhs_dates), .getDays(rhs_dates)):
            lhs_dates == rhs_dates
        case let (.add(lhs_drink), .add(rhs_drink)):
            lhs_drink.size == rhs_drink.size &&
            lhs_drink.container == rhs_drink.container
        case let (.remove(lhs_drink), .remove(rhs_drink)):
            lhs_drink == rhs_drink
        case let (.increase(lhs_goal), .increase(rhs_goal)):
            lhs_goal == rhs_goal
        case let (.decrease(lhs_goal), .decrease(rhs_goal)):
            lhs_goal == rhs_goal
        default: false
        }
    }
}

extension HealthInterfaceSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.shouldRequestAccess(lhs_healthDataType), .shouldRequestAccess(rhs_healthDataType)):
            lhs_healthDataType == rhs_healthDataType
        case let (.canWrite(lhs_dataType), .canWrite(rhs_dataType)):
            lhs_dataType == rhs_dataType
        case let (.requestAuth(lhs_readAndWrite), .requestAuth(rhs_readAndWrite)):
            lhs_readAndWrite == rhs_readAndWrite
        case let (.export(lhs_quantity, lhs_id, _), .export(rhs_quantity, rhs_id, _)):
            lhs_quantity == rhs_quantity &&
            lhs_id == rhs_id
//            lhs_date == rhs_date // Can't test the date
        case let (.readSum(lhs_data, lhs_start, lhs_end, lhs_intervalComponents),
            .readSum(rhs_data, rhs_start, rhs_end, rhs_intervalComponents)):
            lhs_data == rhs_data &&
            lhs_start == rhs_start &&
            lhs_end == rhs_end &&
            lhs_intervalComponents == rhs_intervalComponents
        case let (.readSamples(lhs_data, lhs_start, lhs_end), .readSamples(rhs_data, rhs_start, rhs_end)):
            lhs_data == rhs_data &&
            lhs_start == rhs_start &&
            lhs_end == rhs_end
        case let (.enableBackgroundDelivery(lhs_healthData, lhs_frequency),
                  .enableBackgroundDelivery(rhs_healthData, rhs_frequency)):
            lhs_healthData == rhs_healthData &&
            lhs_frequency == rhs_frequency
        default:
            false
        }
    }
}
