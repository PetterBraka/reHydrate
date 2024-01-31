//
//  DayServiceTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 15/08/2023.
//

import XCTest
import EngineMocks
import TestHelper
import DayServiceInterface
import UnitServiceInterface
import UnitServiceMocks
import LoggingService
import PortsInterface
import PortsMocks
@testable import DayService

final class DayServiceTests: XCTestCase {
    typealias Engine = (
        HasDayManagerService &
        HasConsumptionManagerService &
        HasUnitService &
        HasLoggingService &
        HasPorts
    )
    
    var engine: Engine!
    
    var unitService: UnitServiceStub!
    var dayManager: DayManagerStub!
    var consumptionManager: ConsumptionManagerStub!
    var healthService: HealthServiceStub!
    
    var sut: DayServiceType!
    
    override func setUp() {
        self.engine = EngineMocks()
        self.unitService = UnitServiceStub()
        self.engine.unitService = unitService
        self.dayManager = DayManagerStub()
        self.engine.dayManager = dayManager
        self.consumptionManager = ConsumptionManagerStub()
        self.engine.consumptionManager = consumptionManager
        self.healthService = HealthServiceStub()
        self.engine.healthService = healthService
        self.sut = DayService(engine: engine)
    }
    
    func test_getToday_success() async {
        let givenDate = DatabaseFormatter.date.string(from: .now)
        let givenDay = DayModel(id: "1",
                                date: givenDate,
                                consumed: 0,
                                goal: 3)
        dayManager.fetchWithDate_returnValue = givenDay
        
        let foundDay = await sut.getToday()
        assert(day: foundDay, dayModel: givenDay)
    }
    
    func test_getToday_withHealthDiff_success() async {
        let givenDate = DatabaseFormatter.date.string(from: .now)
        let givenDay = DayModel(id: "1",
                                date: givenDate,
                                consumed: 0,
                                goal: 3)
        dayManager.fetchWithDate_returnValue = givenDay
        dayManager.addConsumed_returnValue = .init(id: "", date: givenDate, consumed: 1, goal: 3)
        healthService.read_sum_returnValue = .success(1)
        
        let foundDay = await sut.getToday()
        assert(day: foundDay,
               dayModel: .init(id: "", date: givenDate, consumed: 1, goal: 3))
    }
    
    func test_getToday_failedFetchForDate() async {
        let givenDate = DatabaseFormatter.date.string(from: .now)
        let givenDay = DayModel(id: "1",
                                date: givenDate,
                                consumed: 0,
                                goal: 3)
        dayManager.fetchWithDate_returnError = DatabaseError.noElementFound
        dayManager.createNewDay_returnValue = givenDay
        healthService.read_sum_returnValue = .failure(HealthError.missingResult)
        
        let foundDay = await sut.getToday()
        assert(day: foundDay, dayModel: givenDay)
    }
    
    func test_getToday_withHealthFailed_failed() async {
        let givenDate = DatabaseFormatter.date.string(from: .now)
        let givenDay = DayModel(id: "1",
                                date: givenDate,
                                consumed: 0,
                                goal: 3)
        dayManager.fetchWithDate_returnValue = givenDay
        dayManager.addConsumed_returnValue = .init(id: "", date: givenDate, consumed: 1, goal: 3)
        healthService.read_sum_returnValue = .success(1)
        
        let foundDay = await sut.getToday()
        assert(day: foundDay,
               dayModel: .init(id: "", date: givenDate, consumed: 1, goal: 3))
    }
    
    func test_getToday_failedFetchForDateAndFetchPrevious() async {
        let givenDate = DatabaseFormatter.date.string(from: .now)
        let givenDay = DayModel(id: "1",
                                date: givenDate,
                                consumed: 0,
                                goal: 3)
        dayManager.fetchWithDate_returnError = DatabaseError.noElementFound
        dayManager.fetchLast_returnError = DatabaseError.noElementFound
        dayManager.createNewDay_returnValue = givenDay
        
        let foundDay = await sut.getToday()
        assert(day: foundDay, dayModel: givenDay)
    }
    
    func test_getToday_failedFetch() async {
        dayManager.fetchWithDate_returnError = DatabaseError.noElementFound
        dayManager.createNewDay_returnError = DatabaseError.creatingElement
        unitService.convert_returnValue = 3
        
        let day = await sut.getToday()
        XCTAssertEqual(day.consumed, 0)
        XCTAssertEqual(day.goal, 3)
    }
    
    func test_getToday_failedFetch_unitSystemImperial() async {
        unitService.currentUnitSystem_returnValue = .imperial
        dayManager.fetchWithDate_returnError = DatabaseError.noElementFound
        dayManager.createNewDay_returnError = DatabaseError.creatingElement
        unitService.convert_returnValue = 3
        
        let day = await sut.getToday()
        XCTAssertEqual(day.consumed, 0)
        XCTAssertEqual(day.goal, 3)
    }
    
    func test_getToday_requestHealthAccessFailed() async {
        let givenDate = DatabaseFormatter.date.string(from: .now)
        let givenDay = DayModel(id: "1",
                                date: givenDate,
                                consumed: 0,
                                goal: 3)
        healthService.requestAuth_returnValue = Error.mock
        dayManager.fetchWithDate_returnValue = givenDay
        
        let foundDay = await sut.getToday()
        assert(day: foundDay, dayModel: givenDay)
    }
    
    func test_getToday_requestHealthAccessNotSupported() async {
        let givenDate = DatabaseFormatter.date.string(from: .now)
        let givenDay = DayModel(id: "1",
                                date: givenDate,
                                consumed: 0,
                                goal: 3)
        healthService.isSupported_returnValue = false
        dayManager.fetchWithDate_returnValue = givenDay
        
        let foundDay = await sut.getToday()
        assert(day: foundDay, dayModel: givenDay)
    }
    
    func test_addDrink() async throws {
        unitService.convert_returnValue = 0.5
        dayManager.addConsumed_returnValue = .init(id: "---", date: "01/01/2023", consumed: 0.5, goal: 3)
        let result = try await sut.add(drink: .init(id: "", size: 500, container: .medium))
        XCTAssertEqual(result, 0.5)
    }
    
    func test_addDrink_unitSystemImperial() async throws {
        unitService.currentUnitSystem_returnValue = .imperial
        unitService.convert_returnValue = 0.5
        dayManager.addConsumed_returnValue = .init(id: "---", date: "01/01/2023", consumed: 0.5, goal: 3)
        let result = try await sut.add(drink: .init(id: "", size: 500, container: .medium))
        XCTAssertEqual(result, 0.5)
    }
    
    func test_addDrink_healthExportFails() async throws {
        unitService.convert_returnValue = 0.5
        dayManager.addConsumed_returnValue = .init(id: "---", date: "01/01/2023", consumed: 0.5, goal: 3)
        healthService.export_returnValue = Error.mock
        
        let result = try await sut.add(drink: .init(id: "", size: 500, container: .medium))
        XCTAssertEqual(result, 0.5)
    }
    
    func test_addDrink_multiple() async throws {
        unitService.convert_returnValue = 1.55
        let _ = try await sut.add(drink: .init(id: "", size: 500, container: .medium))
        let _ = try await sut.add(drink: .init(id: "", size: 750, container: .medium))
        dayManager.addConsumed_returnValue = .init(id: "---", date: "01/01/2023", consumed: 1.55, goal: 3)
        let result = try await sut.add(drink: .init(id: "", size: 300, container: .medium))
        XCTAssertEqual(result, 1.55)
    }
    
    func test_removeDrink() async throws {
        let result = try await sut.remove(drink: .init(id: "", size: 500, container: .medium))
        XCTAssertEqual(result, 0)
    }
    
    func test_removeDrink_removeLessThenAdded() async throws {
        unitService.convert_returnValue = 0.75
        let _ = try await sut.add(drink: .init(id: "", size: 500, container: .medium))
        let _ = try await sut.add(drink: .init(id: "", size: 750, container: .medium))
        
        dayManager.removeConsumed_returnValue = .init(id: "---", date: "01/01/2023", consumed: 0.75, goal: 3)
        let result = try await sut.remove(drink: .init(id: "", size: 500, container: .medium))
        XCTAssertEqual(result, 0.75)
    }
    
    func test_removeDrink_removeMoreThenAdded() async throws {
        let _ = try await sut.add(drink: .init(id: "", size: 500, container: .medium))
        let _ = try await sut.add(drink: .init(id: "", size: 750, container: .medium))
        
        let _ = try await sut.remove(drink: .init(id: "", size: 500, container: .medium))
        let _ = try await sut.remove(drink: .init(id: "", size: 500, container: .medium))
        let result = try await sut.remove(drink: .init(id: "", size: 500, container: .medium))
        XCTAssertEqual(result, 0)
    }
    
    func test_increaseGoal() async throws {
        unitService.convert_returnValue = 4
        dayManager.addGoal_returnValue = .init(id: "---", date: "01/01/2023",
                                               consumed: 0, goal: 4)
        let result = try await sut.increase(goal: 1)
        XCTAssertEqual(result, 4)
    }
    
    func test_increaseGoal_unitSystemImperial() async throws {
        unitService.currentUnitSystem_returnValue = .imperial
        unitService.convert_returnValue = 4
        dayManager.addGoal_returnValue = .init(id: "---", date: "01/01/2023",
                                               consumed: 0, goal: 4)
        let result = try await sut.increase(goal: 1)
        XCTAssertEqual(result, 4)
    }
    
    func test_decreaseGoal() async throws {
        unitService.convert_returnValue = 2
        dayManager.addGoal_returnValue = .init(id: "---", date: "01/01/2023",
                                               consumed: 0, goal: 2)
        let result = try await sut.decrease(goal: 1)
        XCTAssertEqual(result, 2)
    }
    
    func test_dayFrom_withNil() {
        XCTAssertNil(Day(with: nil))
    }
}

extension DayServiceTests {
    func assert(day: Day, dayModel: DayModel,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(DatabaseFormatter.date.string(from: day.date),
                       dayModel.date, file: file, line: line)
        XCTAssertEqual(day.consumed, dayModel.consumed, file: file, line: line)
        XCTAssertEqual(day.goal, dayModel.goal, file: file, line: line)
    }
}

extension DayServiceTests {
    enum Error: Swift.Error {
        case mock
    }
}
