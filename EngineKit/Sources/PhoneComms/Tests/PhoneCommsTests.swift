//
//  PhoneCommsTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/08/2024.
//

import XCTest
import TestHelper
import EngineMocks
import LoggingService
import DateServiceMocks
import PhoneCommsMocks
import DayServiceMocks
import DayServiceInterface
import DrinkServiceMocks
import DrinkServiceInterface
import UnitServiceMocks
import UnitServiceInterface
import CommunicationKitMocks
import CommunicationKitInterface
@testable import PhoneComms

final class PhoneCommsTests: XCTestCase {
    private let timeout: TimeInterval = 0.5
    private var notificationCenter: NotificationCenter!
    
    private var sut: PhoneComms!
    
    private var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    private var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    private var drinksService: (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying)!
    private var unitService: (stub: UnitServiceTypeStubbing, spy: UnitServiceTypeSpying)!
    private var phoneService: (stub: PhoneServiceTypeStubbing, spy: PhoneServiceTypeSpying)!
    
    override func setUp() {
        let engine = EngineMocks()
        dateService = engine.makeDateService()
        dayService = engine.makeDayService()
        drinksService = engine.makeDrinksService()
        unitService = engine.makeUnitService()
        phoneService = engine.makePhoneService()
        notificationCenter = NotificationCenter()
        
        sut = PhoneComms(engine: engine, notificationCenter: notificationCenter)
    }

    override func tearDown() {
        dateService = nil
        dayService = nil
        drinksService = nil
        unitService = nil
        phoneService = nil
        sut = nil
    }
    
    // MARK: SetAppContext
    // With full data set
    func test_setAppContext() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        
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
            phoneService.spy.variableLog,
            [.currentState, .isPaired, .isWatchAppInstalled]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [
                .isSupported,
                .update(applicationContext: [
                    .day: day,
                    .drinks: drinks,
                    .unitSystem: unitSystem
                ])
            ]
        )
    }
    
    func test_setAppContext_watchAppNotInstalled() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = false
        
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
            phoneService.spy.variableLog,
            [.currentState, .isPaired, .isWatchAppInstalled]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported]
        )
    }
    
    func test_setAppContext_notPaired() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = false
        phoneService.stub.isWatchAppInstalled_returnValue = true
        
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
            phoneService.spy.variableLog,
            [.currentState, .isPaired]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported]
        )
    }
    
    func test_setAppContext_inActive() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .inactive
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        
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
            phoneService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported]
        )
    }
    
    func test_setAppContext_notActivated() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .notActivated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        
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
            phoneService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported]
        )
    }
    
    func test_setAppContext_unknown() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .unknown
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        
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
            phoneService.spy.variableLog,
            [.currentState]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported]
        )
    }
    
    func test_setAppContext_notSupported() async {
        phoneService.stub.isSupported_returnValue = false
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        
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
            phoneService.spy.variableLog,
            []
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported]
        )
    }
    
    func test_setAppContext_imperial() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        
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
            phoneService.spy.variableLog,
            [.currentState, .isPaired, .isWatchAppInstalled]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported, .update(applicationContext: [.day: day, .drinks: drinks, .unitSystem: unitSystem])]
        )
    }
    
    func test_setAppContext_noDrinks() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .failure(DummyError())
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            phoneService.spy.variableLog,
            [.currentState, .isPaired, .isWatchAppInstalled]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported, .update(applicationContext: [.day: day, .unitSystem: unitSystem])]
        )
    }
    
    func test_setAppContext_oneDrink() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks = [Drink(id: "1", size: 300, container: .small)]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks)
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            phoneService.spy.variableLog,
            [.currentState, .isPaired, .isWatchAppInstalled]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported, .update(applicationContext: [.day: day, .drinks: drinks, .unitSystem: unitSystem])]
        )
    }
    
    func test_setAppContext_failed() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        phoneService.stub.updateApplicationContext_returnValue = DummyError()
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .failure(DummyError())
        
        await sut.setAppContext()
        
        XCTAssertEqual(
            phoneService.spy.variableLog,
            [.currentState, .isPaired, .isWatchAppInstalled]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported, .update(applicationContext: [.day: day, .unitSystem: unitSystem])]
        )
    }
                       
    // MARK: sendDataToWatch
    func test_sendDataToWatch() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        phoneService.stub.isComplicationEnabled_returnValue = true
        phoneService.stub.remainingComplicationUserInfoTransfers_returnValue = 10
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks = [Drink(id: "1", size: 300, container: .small)]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks)
        
        await sut.sendDataToWatch()
        
        XCTAssertEqual(
            phoneService.spy.variableLog,
            [.currentState, .isPaired, .isWatchAppInstalled, .isComplicationEnabled, .remainingComplicationUserInfoTransfers]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported, .transferComplication(userInfo: [.day: day, .drinks: drinks, .unitSystem: unitSystem])]
        )
    }
    
    func test_sendDataToWatch_oneTransferLeft() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        phoneService.stub.isComplicationEnabled_returnValue = true
        phoneService.stub.remainingComplicationUserInfoTransfers_returnValue = 1
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks = [Drink(id: "1", size: 300, container: .small)]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks)
        
        await sut.sendDataToWatch()
        
        XCTAssertEqual(
            phoneService.spy.variableLog,
            [.currentState, .isPaired, .isWatchAppInstalled, .isComplicationEnabled, .remainingComplicationUserInfoTransfers]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported, .transferComplication(userInfo: [.day: day, .drinks: drinks, .unitSystem: unitSystem])]
        )
    }
    
    func test_sendDataToWatch_noTransfer() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        phoneService.stub.isComplicationEnabled_returnValue = true
        phoneService.stub.remainingComplicationUserInfoTransfers_returnValue = 0
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks = [Drink(id: "1", size: 300, container: .small)]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks)
        
        await sut.sendDataToWatch()
        
        XCTAssertEqual(
            phoneService.spy.variableLog,
            [.currentState, .isPaired, .isWatchAppInstalled, .isComplicationEnabled, .remainingComplicationUserInfoTransfers]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported, .sendMessage(message: [.day: day, .drinks: drinks, .unitSystem: unitSystem], errorHandler: nil)]
        )
    }
    
    func test_sendDataToWatch_noComplications() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        phoneService.stub.isComplicationEnabled_returnValue = false
        phoneService.stub.remainingComplicationUserInfoTransfers_returnValue = 0
        
        let unitSystem = UnitSystem.metric
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        let drinks = [Drink(id: "1", size: 300, container: .small)]
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .success(drinks)
        
        await sut.sendDataToWatch()
        
        XCTAssertEqual(
            phoneService.spy.variableLog,
            [.currentState, .isPaired, .isWatchAppInstalled, .isComplicationEnabled]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported, .sendMessage(message: [.day: day, .drinks: drinks, .unitSystem: unitSystem], errorHandler: nil)]
        )
    }
    
    func test_sendDataToWatch_noComplicationsAndUnexpectedData() async {
        phoneService.stub.isSupported_returnValue = true
        phoneService.stub.currentState_returnValue = .activated
        phoneService.stub.isPaired_returnValue = true
        phoneService.stub.isWatchAppInstalled_returnValue = true
        phoneService.stub.isComplicationEnabled_returnValue = false
        phoneService.stub.remainingComplicationUserInfoTransfers_returnValue = 0
        
        let unitSystem = UnitSystem.imperial
        let day = Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5)
        unitService.stub.getUnitSystem_returnValue = unitSystem
        dayService.stub.getToday_returnValue = day
        drinksService.stub.getSaved_returnValue = .failure(DummyError())
        
        await sut.sendDataToWatch()
        
        XCTAssertEqual(
            phoneService.spy.variableLog,
            [.currentState, .isPaired, .isWatchAppInstalled, .isComplicationEnabled]
        )
        XCTAssertEqual(
            phoneService.spy.methodLog,
            [.isSupported, .sendMessage(message: [.day: day, .unitSystem: unitSystem], errorHandler: nil)]
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
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveApplicationContext, object: nil, userInfo: expectedUserInfo.mapValueToData())

        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(unitService.spy.methodLog, [.getUnitSystem])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .add(size: 300, container: .small), .add(size: 500, container: .medium)])
    }
    
    func test_addObserver_didReceiveMessage() async {
        drinksService.stub.getSaved_returnValue = .failure(DummyError())
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .unitSystem : UnitSystem.metric,
            .day : Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5),
            .drinks : [Drink(id: "1", size: 300, container: .small), Drink(id: "2", size: 500, container: .medium)]
        ]
        
        let expectation = expectation(description: "didReceiveMessage - Should trigger update")
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveMessage, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(unitService.spy.methodLog, [.getUnitSystem])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .add(size: 300, container: .small), .add(size: 500, container: .medium)])
    }
    
    func test_addObserver_didReceiveUserInfo() async {
        drinksService.stub.getSaved_returnValue = .failure(DummyError())
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .unitSystem : UnitSystem.metric,
            .day : Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5),
            .drinks : [Drink(id: "1", size: 300, container: .small), Drink(id: "2", size: 500, container: .medium)]
        ]
        
        let expectation = expectation(description: "didReceiveUserInfo - Should trigger update")
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(unitService.spy.methodLog, [.getUnitSystem])
        XCTAssertEqual(dayService.spy.methodLog, [.getToday])
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .add(size: 300, container: .small), .add(size: 500, container: .medium)])
    }
    
    func test_addObserver_processing_noData() async {
        let expectation = expectation(description: "processing_noData - Should trigger update")
        expectation.isInverted = true
        sut.addObserver {
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
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(unitService.spy.methodLog, [.getUnitSystem, .set(unitSystem: .metric)])
    }
    
    func test_addObserver_processing_unit_unexpectedData() async {
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .unitSystem : 1234,
        ]
        
        let expectation = expectation(description: "processing_unit_unexpectedData - Should trigger update")
        sut.addObserver {
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
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .edit(size: 300, drink: .small), .edit(size: 500, drink: .medium)])
    }
    
    func test_addObserver_processing_drink_didAddAndEdit() async {
        drinksService.stub.getSaved_returnValue = .success([Drink(id: "1", size: 100, container: .small)])
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .drinks : [Drink(id: "1", size: 300, container: .small), Drink(id: "2", size: 500, container: .medium)]
        ]
        
        let expectation = expectation(description: "processing_drink_didAddAndEdit - Should trigger update")
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .edit(size: 300, drink: .small), .add(size: 500, container: .medium)])
    }
    
    func test_addObserver_processing_drink_didNotRemove() async {
        drinksService.stub.getSaved_returnValue = .success([Drink(id: "1", size: 100, container: .small), Drink(id: "1", size: 600, container: .medium)])
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .drinks : [Drink(id: "1", size: 200, container: .small)]
        ]
        
        let expectation = expectation(description: "processing_drink_didAddAndEdit - Should trigger update")
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(drinksService.spy.methodLog, [.getSaved, .edit(size: 200, drink: .small)])
    }
    
    func test_addObserver_processing_drink_didNotEdit() async {
        drinksService.stub.getSaved_returnValue = .success([Drink(id: "1", size: 100, container: .small)])
        
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .drinks : [Drink(id: "1", size: 100, container: .small)]
        ]
        
        let expectation = expectation(description: "processing_drink_didAddAndEdit - Should trigger update")
        sut.addObserver {
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
        sut.addObserver {
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
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(dayService.spy.methodLog, [.getToday, .add(drink: .init(id: "watch-message", size: 900, container: .medium))])
        XCTAssertEqual(unitService.spy.methodLog, [.convert(value: 0.9, fromUnit: .litres, toUnit: .millilitres)])
    }
    
    func test_addObserver_processing_day_didRemoveDrink() async {
        dateService.stub.isDateDateInSameDayAs_returnValue = true
        dayService.stub.getToday_returnValue = .init(date: .november_3_1966_Thursday, consumed: 1, goal: 2.3)
        unitService.stub.convertValueFromUnitToUnit_returnValue = 900
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .day : Day(date: .november_3_1966_Thursday, consumed: 0.1, goal: 2.3),
        ]
        
        let expectation = expectation(description: "processing_day_unexpectedData - Should trigger update")
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(dayService.spy.methodLog, [.getToday, .remove(drink: .init(id: "watch-message", size: 900, container: .medium))])
        XCTAssertEqual(unitService.spy.methodLog, [.convert(value: 0.9, fromUnit: .litres, toUnit: .millilitres)])
    }
    
    func test_addObserver_processing_day_didIncreaseGoal() async {
        dateService.stub.isDateDateInSameDayAs_returnValue = true
        dayService.stub.getToday_returnValue = .init(date: .november_3_1966_Thursday, consumed: 1, goal: 2)
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .day : Day(date: .november_3_1966_Thursday, consumed: 1, goal: 2.5),
        ]
        
        let expectation = expectation(description: "processing_day_unexpectedData - Should trigger update")
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(dayService.spy.methodLog, [.getToday, .increase(goal: 0.5)])
        XCTAssertEqual(unitService.spy.methodLog, [])
    }
    
    func test_addObserver_processing_day_didDecreaseGoal() async {
        dateService.stub.isDateDateInSameDayAs_returnValue = true
        dayService.stub.getToday_returnValue = .init(date: .november_3_1966_Thursday, consumed: 1, goal: 2.5)
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .day : Day(date: .november_3_1966_Thursday, consumed: 1, goal: 2),
        ]
        
        let expectation = expectation(description: "processing_day_unexpectedData - Should trigger update")
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(dayService.spy.methodLog, [.getToday, .decrease(goal: 0.5)])
        XCTAssertEqual(unitService.spy.methodLog, [])
    }
    
    func test_addObserver_processing_day_unexpectedData() async {
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .day : 1234,
        ]
        
        let expectation = expectation(description: "processing_day_unexpectedData - Should trigger update")
        sut.addObserver {
            expectation.fulfill()
        }
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo.mapValueToData())
        
        await fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(dayService.spy.methodLog, [])
    }
    
    func test_removeObserver_didReceiveApplicationContext() async {
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .unitSystem : UnitSystem.metric,
            .day : Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5),
            .drinks : [Drink(id: "1", size: 300, container: .small), Drink(id: "2", size: 500, container: .medium)]
        ]
        let message =  "didReceiveApplicationContext - didReceiveApplicationContext not trigger update"
        let expectation = expectation(description: message)
        expectation.isInverted = true
        sut.addObserver {
            XCTFail(message)
        }
        sut.removeObserver()
        
        notificationCenter.post(name: .Shared.didReceiveApplicationContext, object: nil, userInfo: expectedUserInfo)
        
        await fulfillment(of: [expectation], timeout: timeout)
    }
    
    func test_removeObserver_didReceiveMessage() async {
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .unitSystem : UnitSystem.metric,
            .day : Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5),
            .drinks : [Drink(id: "1", size: 300, container: .small), Drink(id: "2", size: 500, container: .medium)]
        ]
        let message =  "didReceiveMessage - Should not trigger update"
        let expectation = expectation(description:message)
        expectation.isInverted = true
        sut.addObserver {
            XCTFail(message)
        }
        sut.removeObserver()
        
        notificationCenter.post(name: .Shared.didReceiveMessage, object: nil, userInfo: expectedUserInfo)
        
        await fulfillment(of: [expectation], timeout: timeout)
    }
    
    func test_removeObserver_didReceiveUserInfo() async {
        let expectedUserInfo: [CommunicationUserInfo: Codable] = [
            .unitSystem : UnitSystem.metric,
            .day : Day(id: "1",date: .may_2_1999_Sunday, consumed: 1, goal: 2.5),
            .drinks : [Drink(id: "1", size: 300, container: .small), Drink(id: "2", size: 500, container: .medium)]
        ]
        let message = "didReceiveUserInfo - Should not trigger update"
        let expectation = expectation(description: message)
        expectation.isInverted = true
        sut.addObserver {
            XCTFail(message)
        }
        sut.removeObserver()
        
        notificationCenter.post(name: .Shared.didReceiveUserInfo, object: nil, userInfo: expectedUserInfo)
        
        await fulfillment(of: [expectation], timeout: timeout)
    }
}

extension PhoneServiceTypeSpy.MethodCall: Equatable {
    public static func == (lhs: PhoneServiceTypeSpy.MethodCall, rhs: PhoneServiceTypeSpy.MethodCall) -> Bool {
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
        case (.update(let applicationContext_lhs), .update(let applicationContext_rhs)):
            isEqual(applicationContext_lhs, applicationContext_rhs)
        case (.sendMessage(let message_lhs, _), .sendMessage(let message_rhs, _)):
            isEqual(message_lhs, message_rhs)
        case (.sendData(let data_lhs, _), .sendData(let data_rhs, _)):
            data_lhs == data_rhs
        case (.transferComplication(let userInfo_lhs), .transferComplication(let userInfo_rhs)):
            isEqual(userInfo_lhs, userInfo_rhs)
        case (.transfer(let userInfo_lhs), .transfer(let userInfo_rhs)):
            isEqual(userInfo_lhs, userInfo_rhs)
        case (.isSupported, .activate), (.isSupported, .update), (.isSupported, .sendMessage),
            (.isSupported, .sendData), (.isSupported, .transferComplication), (.isSupported, .transfer),
            (.activate, .isSupported), (.activate, .update), (.activate, .sendMessage),
            (.activate, .sendData), (.activate, .transferComplication), (.activate, .transfer),
            (.update, .isSupported), (.update, .activate), (.update, .sendMessage),
            (.update, .sendData), (.update, .transferComplication), (.update, .transfer),
            (.sendMessage, .isSupported), (.sendMessage, .activate), (.sendMessage, .update),
            (.sendMessage, .sendData), (.sendMessage, .transferComplication), (.sendMessage, .transfer),
            (.sendData, .isSupported), (.sendData, .activate), (.sendData, .update),
            (.sendData, .sendMessage), (.sendData, .transferComplication), (.sendData, .transfer),
            (.transferComplication, .isSupported), (.transferComplication, .activate),
            (.transferComplication, .update), (.transferComplication, .sendMessage),
            (.transferComplication, .sendData), (.transferComplication, .transfer),
            (.transfer, .isSupported), (.transfer, .activate), (.transfer, .update),
            (.transfer, .sendMessage), (.transfer, .sendData), (.transfer, .transferComplication):
            false
        }
    }
}

extension PhoneServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .isSupported: "isSupported"
        case .activate: "activate"
        case .update(let applicationContext): "update(\(applicationContext)"
        case .sendMessage(let message, _): "sendMessage(\(message), errorHandler)"
        case .sendData(let data, _): "sendData(\(data), errorHandler)"
        case .transferComplication(let userInfo): "transferComplication(\(userInfo)"
        case .transfer(let userInfo): "transfer(\(userInfo)"
        }
    }
}

extension PhoneServiceTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .currentState: "currentState"
        case .isReachable: "isReachable"
        case .applicationContext: "applicationContext"
        case .receivedApplicationContext: "receivedApplicationContext"
        case .remainingComplicationUserInfoTransfers: "remainingComplicationUserInfoTransfers"
        case .isPaired: "isPaired"
        case .watchDirectoryUrl: "watchDirectoryUrl"
        case .isWatchAppInstalled: "isWatchAppInstalled"
        case .isComplicationEnabled: "isComplicationEnabled"
        }
    }
}

extension DrinkServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .add(let size, let container):
            "add(\(size), \(container))"
        case .edit(let size, let drink):
            "edit(\(size), \(drink))"
        case .remove(let container):
            "remove(\(container))"
        case .getSaved:
            "getSaved"
        case .resetToDefault:
            "resetToDefault"
        }
    }
}

extension DayServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .getToday:
            "getToday"
        case .getDays(let dates):
            "getDays(\(dates))"
        case .add(let drink):
            "add(\(drink))"
        case .remove(let drink):
            "remove(\(drink))"
        case .increase(let goal):
            "increase(\(goal))"
        case .decrease(let goal):
            "decrease(\(goal))"
        }
    }
}

extension CommunicationUserInfo: CustomStringConvertible {
    public var description: String { key }
}

extension UnitSystem: CustomStringConvertible {
    public var description: String {
        switch self {
        case .imperial: "imperial"
        case .metric: "metric"
        }
    }
}

extension Day: CustomStringConvertible {
    public var description: String {
        "Day(id: \(id), date: \(date), consumed: \(consumed), goal: \(goal))"
    }
}

extension Drink: CustomStringConvertible {
    public var description: String {
        "Drink(id: \(id), size: \(size), container: \(container))"
    }
}

extension UnitServiceTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.set(let unitSystem_lhs), .set(let unitSystem_rhs)):
            unitSystem_lhs == unitSystem_rhs
        case (.getUnitSystem, .getUnitSystem):
            true
        case (let .convert(value_lhs, fromUnit_lhs, toUnit_lhs), let .convert(value_rhs, fromUnit_rhs, toUnit_rhs)):
            value_lhs == value_rhs &&
            fromUnit_lhs == fromUnit_rhs &&
            toUnit_lhs == toUnit_rhs
        case (.getUnitSystem, .set), (.convert, .set),
            (.set, .getUnitSystem), (.convert, .getUnitSystem),
            (.set, .convert), (.getUnitSystem, .convert):
            false
        }
    }
}

extension DayServiceTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.getToday, .getToday):
            true
        case (.getDays(let dates_lhs), .getDays(let dates_rhs)):
            dates_lhs == dates_rhs
        case (.add(let drink_lhs), .add(let drink_rhs)):
            drink_lhs == drink_rhs
        case (.remove(let drink_lhs), .remove(let drink_rhs)):
            drink_lhs == drink_rhs
        case (.increase(let goal_lhs), .increase(let goal_rhs)):
            goal_lhs == goal_rhs
        case (.decrease(let goal_lhs), .decrease(let goal_rhs)):
            goal_lhs == goal_rhs
        case (.getDays, .getToday), (.add, .getToday), (.remove, .getToday), (.increase, .getToday), (.decrease, .getToday),
            (.getToday, .getDays), (.add, .getDays), (.remove, .getDays), (.increase, .getDays), (.decrease, .getDays),
            (.getToday, .add), (.getDays, .add), (.remove, .add), (.increase, .add), (.decrease, .add),
            (.getToday, .remove), (.getDays, .remove), (.add, .remove), (.increase, .remove), (.decrease, .remove),
            (.getToday, .increase), (.getDays, .increase), (.add, .increase), (.remove, .increase), (.decrease, .increase),
            (.getToday, .decrease), (.getDays, .decrease), (.add, .decrease), (.remove, .decrease), (.increase, .decrease):
            false
        }
    }
}

extension DrinkServiceTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.add(let size_lhs, let container_lhs), .add(let size_rhs, let container_rhs)):
            size_lhs == size_rhs &&
            container_lhs == container_rhs
        case (.edit(let size_lhs, let drink_lhs), .edit(let size_rhs, let drink_rhs)):
            size_lhs == size_rhs &&
            drink_lhs == drink_rhs
        case (.remove(let container_lhs), .remove(let container_rhs)):
            container_lhs == container_rhs
        case (.getSaved, .getSaved), (.resetToDefault, .resetToDefault):
            true
        case (.edit, .add), (.remove, .add), (.getSaved, .add), (.resetToDefault, .add),
            (.add, .edit), (.remove, .edit), (.getSaved, .edit), (.resetToDefault, .edit),
            (.add, .remove), (.edit, .remove), (.getSaved, .remove), (.resetToDefault, .remove),
            (.add, .getSaved), (.edit, .getSaved), (.remove, .getSaved), (.resetToDefault, .getSaved),
            (.add, .resetToDefault), (.edit, .resetToDefault), (.remove, .resetToDefault), (.getSaved, .resetToDefault):
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
