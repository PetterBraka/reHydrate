//
//  WatchCommsTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/08/2024.
//

import XCTest
import TestHelper
import EngineMocks
import LoggingService
import DateServiceMocks
import WatchCommsMocks
import DayServiceMocks
import DayServiceInterface
import DrinkServiceMocks
import DrinkServiceInterface
import UnitServiceMocks
import UnitServiceInterface
import WatchCommsInterface
import CommunicationKitInterface
import CommunicationKitMocks
@testable import WatchComms

final class WatchCommsTests: XCTestCase {
    private let timeout: TimeInterval = 0.5
    private var notificationCenter: NotificationCenter!
    
    private var sut: WatchComms!
    
    private var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    private var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    private var drinksService: (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying)!
    private var unitService: (stub: UnitServiceTypeStubbing, spy: UnitServiceTypeSpying)!
    private var watchService: (stub: WatchServiceTypeStubbing, spy: WatchServiceTypeSpying)!
    
    override func setUp() {
        let engine = EngineMocks()
        dateService = engine.makeDateService()
        dayService = engine.makeDayService()
        drinksService = engine.makeDrinksService()
        unitService = engine.makeUnitService()
        watchService = engine.makeWatchService()
        notificationCenter = NotificationCenter()
        
        sut = WatchComms(engine: engine, notificationCenter: notificationCenter)
    }

    override func tearDown() {
        dateService = nil
        dayService = nil
        drinksService = nil
        unitService = nil
        watchService = nil
        sut = nil
    }
    
    // MARK: SetAppContext
    // With full data set
    func test_setAppContext() async {
        watchService.stub.isSupported_returnValue = true
        watchService.stub.currentState_returnValue = .activated
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks = [
            Drink(id: "1", size: 200, container: .small),
            Drink(id: "2", size: 500, container: .medium),
            Drink(id: "3", size: 800, container: .large)
        ]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks)
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            watchService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            watchService.spy.methodLog,
            [
                .isSupported,
                .updateApplicationContext(applicationContext: [
                    .day: day,
                    .drinks: drinks,
                    .unitSystem: unitSystem
                ])
            ]
        )
    }
    
    func test_setAppContext_inActive() async {
        watchService.stub.isSupported_returnValue = true
        watchService.stub.currentState_returnValue = .inactive
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks: [Drink]? = [
            Drink(id: "1", size: 200, container: .small),
            Drink(id: "2", size: 500, container: .medium),
            Drink(id: "3", size: 800, container: .large)
        ]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks!)
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            watchService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            watchService.spy.methodLog,
            [.isSupported]
        )
    }
    
    func test_setAppContext_notActivated() async {
        watchService.stub.isSupported_returnValue = true
        watchService.stub.currentState_returnValue = .notActivated
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks: [Drink]? = [
            Drink(id: "1", size: 200, container: .small),
            Drink(id: "2", size: 500, container: .medium),
            Drink(id: "3", size: 800, container: .large)
        ]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks!)
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            watchService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            watchService.spy.methodLog,
            [.isSupported]
        )
    }
    
    func test_setAppContext_unknown() async {
        watchService.stub.isSupported_returnValue = true
        watchService.stub.currentState_returnValue = .unknown
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks: [Drink]? = [
            Drink(id: "1", size: 200, container: .small),
            Drink(id: "2", size: 500, container: .medium),
            Drink(id: "3", size: 800, container: .large)
        ]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks!)
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            watchService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            watchService.spy.methodLog,
            [.isSupported]
        )
    }
    
    func test_setAppContext_notSupported() async {
        watchService.stub.isSupported_returnValue = false
        watchService.stub.currentState_returnValue = .activated
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks: [Drink]? = [
            Drink(id: "1", size: 200, container: .small),
            Drink(id: "2", size: 500, container: .medium),
            Drink(id: "3", size: 800, container: .large)
        ]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks!)
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            watchService.spy.variableLog,
            []
        )
        XCTAssertEqual(
            watchService.spy.methodLog,
            [.isSupported]
        )
    }
    
    func test_setAppContext_imperial() async {
        watchService.stub.isSupported_returnValue = true
        watchService.stub.currentState_returnValue = .activated
        
        let unitSystem = UnitSystem.imperial
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks = [
            Drink(id: "1", size: 200, container: .small),
            Drink(id: "2", size: 500, container: .medium),
            Drink(id: "3", size: 800, container: .large)
        ]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks)
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            watchService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            watchService.spy.methodLog,
            [.isSupported, .updateApplicationContext(applicationContext: [.day: day, .drinks: drinks, .unitSystem: unitSystem])]
        )
    }
    
    func test_setAppContext_noDrinks() async {
        watchService.stub.isSupported_returnValue = true
        watchService.stub.currentState_returnValue = .activated
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .failure(DummyError())
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            watchService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            watchService.spy.methodLog,
            [.isSupported, .updateApplicationContext(applicationContext: [.day: day, .unitSystem: unitSystem])]
        )
    }
    
    func test_setAppContext_oneDrink() async {
        watchService.stub.isSupported_returnValue = true
        watchService.stub.currentState_returnValue = .activated
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks = [Drink(id: "1", size: 300, container: .small)]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks)
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            watchService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            watchService.spy.methodLog,
            [.isSupported, .updateApplicationContext(applicationContext: [.day: day, .drinks: drinks, .unitSystem: unitSystem])]
        )
    }
    
    func test_setAppContext_failed() async {
        watchService.stub.isSupported_returnValue = true
        watchService.stub.currentState_returnValue = .activated
        watchService.stub.updateApplicationContext_returnValue = DummyError()
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .failure(DummyError())
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            watchService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            watchService.spy.methodLog,
            [.isSupported, .updateApplicationContext(applicationContext: [.day: day, .unitSystem: unitSystem])]
        )
    }
                       
    // MARK: sendDataToWatch
    func test_sendDataToWatch() async {
        watchService.stub.isSupported_returnValue = true
        watchService.stub.currentState_returnValue = .activated
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks = [Drink(id: "1", size: 300, container: .small)]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks)
        
        await sut.sendDataToPhone()
        
        XCTAssertEqual(
            watchService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            watchService.spy.methodLog,
            [.isSupported, .sendMessageMessageErrorHandler(message: [.day: day, .drinks: drinks, .unitSystem: unitSystem], errorHandler: nil)]
        )
    }
    
    func test_sendDataToWatch_unexpectedData() async {
        watchService.stub.isSupported_returnValue = true
        watchService.stub.currentState_returnValue = .activated
        
        let unitSystem = UnitSystem.imperial
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .failure(DummyError())
        
        await sut.sendDataToPhone()
        
        XCTAssertEqual(
            watchService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            watchService.spy.methodLog,
            [.isSupported, .sendMessageMessageErrorHandler(message: [.day: day, .unitSystem: unitSystem], errorHandler: nil)]
        )
    }
    
    func test_addObserver_didReceiveApplicationContext() async {
        drinksService.stub.getSaved_returnValue = .failure(DummyError())
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .unitSystem : UnitSystem.metric,
            .day : Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5),
            .drinks : [Drink(id: "1", size: 300, container: .small), Drink(id: "2", size: 500, container: .medium)]
        ]
        
        let expectation = expectation(description: "didReceiveApplicationContext - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveApplicationContext, object: nil, userInfo: expectedUserInfo.mapValueToData())

        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(unitService.spy.methodLog, [.getUnitSystem])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .addSizeContainer(size: 300, container: .small), .addSizeContainer(size: 500, container: .medium)])
    }
    
    func test_addObserver_didReceiveMessage() async {
        drinksService.stub.getSaved_returnValue = .failure(DummyError())
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .unitSystem : UnitSystem.metric,
            .day : Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5),
            .drinks : [Drink(id: "1", size: 300, container: .small), Drink(id: "2", size: 500, container: .medium)]
        ]
        
        let expectation = expectation(description: "didReceiveMessage - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveMessage, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(unitService.spy.methodLog, [.getUnitSystem])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .addSizeContainer(size: 300, container: .small), .addSizeContainer(size: 500, container: .medium)])
    }
    
    func test_addObserver_didReceiveUserInfo() async {
        drinksService.stub.getSaved_returnValue = .failure(DummyError())
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .unitSystem : UnitSystem.metric,
            .day : Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5),
            .drinks : [Drink(id: "1", size: 300, container: .small), Drink(id: "2", size: 500, container: .medium)]
        ]
        
        let expectation = expectation(description: "didReceiveUserInfo - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(unitService.spy.methodLog, [.getUnitSystem])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .addSizeContainer(size: 300, container: .small), .addSizeContainer(size: 500, container: .medium)])
    }
    
    func test_addObserver_processing_noData() async {
        let expectation = expectation(description: "processing_noData - Should trigger update")
        expectation.isInverted = true
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: nil)
        
        await fulfillment(of: [expectation], timeout: timeout)
    }
    
    func test_addObserver_processing_unit() async {
        unitService.stub.getUnitSystem_returnValue = .imperial
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .unitSystem : UnitSystem.metric,
        ]
        
        let expectation = expectation(description: "processing_unit - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(unitService.spy.methodLog, [.getUnitSystem, .setUnitSystem(unitSystem: .metric)])
    }
    
    func test_addObserver_processing_unit_unexpectedData() async {
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .unitSystem : 1234,
        ]
        
        let expectation = expectation(description: "processing_unit_unexpectedData - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(unitService.spy.methodLog, [])
    }
    
    func test_addObserver_processing_drink_didEdit() async {
        drinksService.stub.getSaved_returnValue = .success([Drink(id: "1", size: 100, container: .small),
                                                            Drink(id: "2", size: 200, container: .medium)])
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .drinks : [Drink(id: "1", size: 300, container: .small), Drink(id: "2", size: 500, container: .medium)]
        ]
        
        let expectation = expectation(description: "processing_drink_didEdit - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .editSizeDrink(size: 300, drink: .small), .editSizeDrink(size: 500, drink: .medium)])
    }
    
    func test_addObserver_processing_drink_didAddAndEdit() async {
        drinksService.stub.getSaved_returnValue = .success([Drink(id: "1", size: 100, container: .small)])
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .drinks : [Drink(id: "1", size: 300, container: .small), Drink(id: "2", size: 500, container: .medium)]
        ]
        
        let expectation = expectation(description: "processing_drink_didAddAndEdit - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .editSizeDrink(size: 300, drink: .small), .addSizeContainer(size: 500, container: .medium)])
    }
    
    func test_addObserver_processing_drink_didNotRemove() async {
        drinksService.stub.getSaved_returnValue = .success([Drink(id: "1", size: 100, container: .small), Drink(id: "1", size: 600, container: .medium)])
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .drinks : [Drink(id: "1", size: 200, container: .small)]
        ]
        
        let expectation = expectation(description: "processing_drink_didAddAndEdit - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .editSizeDrink(size: 200, drink: .small)])
    }
    
    func test_addObserver_processing_drink_didNotEdit() async {
        drinksService.stub.getSaved_returnValue = .success([Drink(id: "1", size: 100, container: .small)])
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .drinks : [Drink(id: "1", size: 100, container: .small)]
        ]
        
        let expectation = expectation(description: "processing_drink_didAddAndEdit - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved])
    }
    
    func test_addObserver_processing_drink_unexpectedData() async {
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .drinks : 1234,
        ]
        
        let expectation = expectation(description: "processing_drink_unexpectedData - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(drinksService.spy.methodLog, [])
    }
    
    func test_addObserver_processing_day_didAddDrink() async {
        dateService.stub.isDateDateInSameDayAs_returnValue = true
        dayService.stub.getToday_returnValue = .init(date: .november_3_1966_Thursday, consumed: 0.1, goal: 2.3)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 900
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .day : Day(date: .november_3_1966_Thursday, consumed: 1, goal: 2.3),
        ]
        
        let expectation = expectation(description: "processing_day_unexpectedData - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(dayService.spy.methodLog, [.getToday, .addDrink(drink: .init(id: "watch-message", size: 900, container: .medium))])
        XCTAssertEqual(unitService.spy.methodLog, [.convertValueFromUnitToUnit(value: 0.9, fromUnit: .litres, toUnit: .millilitres)])
    }
    
    func test_addObserver_processing_day_didRemoveDrink() async {
        dateService.stub.isDateDateInSameDayAs_returnValue = true
        dayService.stub.getToday_returnValue = .init(date: .november_3_1966_Thursday, consumed: 1, goal: 2.3)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 900
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .day : Day(date: .november_3_1966_Thursday, consumed: 0.1, goal: 2.3),
        ]
        
        let expectation = expectation(description: "processing_day_unexpectedData - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(dayService.spy.methodLog, [.getToday, .removeDrink(drink: .init(id: "watch-message", size: 900, container: .medium))])
        XCTAssertEqual(unitService.spy.methodLog, [.convertValueFromUnitToUnit(value: 0.9, fromUnit: .litres, toUnit: .millilitres)])
    }
    
    func test_addObserver_processing_day_didIncreaseGoal() async {
        dateService.stub.isDateDateInSameDayAs_returnValue = true
        dayService.stub.getToday_returnValue = .init(date: .november_3_1966_Thursday, consumed: 1, goal: 2)
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .day : Day(date: .november_3_1966_Thursday, consumed: 1, goal: 2.5),
        ]
        
        let expectation = expectation(description: "processing_day_unexpectedData - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(dayService.spy.methodLog, [.getToday, .increaseGoal(goal: 0.5)])
        XCTAssertEqual(unitService.spy.methodLog, [])
    }
    
    func test_addObserver_processing_day_didDecreaseGoal() async {
        dateService.stub.isDateDateInSameDayAs_returnValue = true
        dayService.stub.getToday_returnValue = .init(date: .november_3_1966_Thursday, consumed: 1, goal: 2.5)
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .day : Day(date: .november_3_1966_Thursday, consumed: 1, goal: 2),
        ]
        
        let expectation = expectation(description: "processing_day_unexpectedData - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(dayService.spy.methodLog, [.getToday, .decreaseGoal(goal: 0.5)])
        XCTAssertEqual(unitService.spy.methodLog, [])
    }
    
    func test_addObserver_processing_day_unexpectedData() async {
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .day : 1234,
        ]
        
        let expectation = expectation(description: "processing_day_unexpectedData - Should trigger update")
        addDidProcessNotificationObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(dayService.spy.methodLog, [])
    }
    
    func addDidProcessNotificationObserver(block: @escaping @Sendable () -> Void) {
        notificationCenter.addObserver(forName: .Shared.processedNotification, object: nil, queue: .current) { _ in block() }
    }
}

extension WatchServiceTypeSpy.MethodCall: @retroactive Equatable {
    public static func == (lhs: WatchServiceTypeSpy.MethodCall, rhs: WatchServiceTypeSpy.MethodCall) -> Bool {
        func isEqual(_ lhs: [CommunicationUserInfo: Codable], _ rhs: [CommunicationUserInfo: Codable]) -> Bool {
            for key in CommunicationUserInfo.allCases {
                if String(describing: lhs[key]) != String(describing: rhs[key]) {
                    return false
                }
            }
            return true
        }
        
        return switch (lhs, rhs) {
        case (.isSupported, .isSupported), (.activate, .activate):
            true
        case (.updateApplicationContext(let applicationContext_lhs), .updateApplicationContext(let applicationContext_rhs)):
            isEqual(applicationContext_lhs, applicationContext_rhs)
        case (.sendMessageMessageErrorHandler(let message_lhs, _), .sendMessageMessageErrorHandler(let message_rhs, _)):
            isEqual(message_lhs, message_rhs)
        case (.sendDataDataErrorHandler(let data_lhs, _), .sendDataDataErrorHandler(let data_rhs, _)):
            data_lhs == data_rhs
        case (.sendUserInfoUserInfo(userInfo: let userInfo_lhs), .sendUserInfoUserInfo(userInfo: let userInfo_rhs)):
            isEqual(userInfo_lhs, userInfo_rhs)
        case (.isSupported, _), (_, .isSupported),
            (.activate, _), (_, .activate),
            (.updateApplicationContext, _), (_, .updateApplicationContext),
            (.sendMessageMessageErrorHandler, _), (_, .sendMessageMessageErrorHandler),
            (.sendDataDataErrorHandler, _), (_, .sendDataDataErrorHandler),
            (.sendUserInfoUserInfo, _), (_, .sendUserInfoUserInfo):
            false
        }
    }
}

extension Dictionary where Key == CommunicationUserInfo, Value == Codable {
    func mapValueToData() -> [CommunicationUserInfo: Data] {
        let encoder = JSONEncoder()
        return compactMapValues { value in
            try? encoder.encode(value)
        }
    }
}
