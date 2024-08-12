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
    let notificationCenter = NotificationCenter.default
    
    var sut: PhoneComms!
    
    var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    var drinksService: (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying)!
    var unitService: (stub: UnitServiceTypeStubbing, spy: UnitServiceTypeSpying)!
    var phoneService: (stub: PhoneServiceTypeStubbing, spy: PhoneServiceTypeSpying)!
    
    override func setUp() {
        let engine = EngineMocks()
        dateService = engine.makeDateService()
        dayService = engine.makeDayService()
        drinksService = engine.makeDrinksService()
        unitService = engine.makeUnitService()
        phoneService = engine.makePhoneService()
        
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
        case .sendMessage(let message, let errorHandler): "sendMessage(\(message), errorHandler)"
        case .sendData(let data, let errorHandler): "sendData(\(data), errorHandler)"
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
        "Drink(id: \(id), container: .\(container.rawValue), size: \(size))"
    }
}
