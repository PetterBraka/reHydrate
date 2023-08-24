//
//  DayServiceTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 15/08/2023.
//

import XCTest
import EngineMocks
import TestHelper
import DatabaseServiceInterface
import DatabaseServiceMocks
import DayServiceInterface
import UnitServiceInterface
@testable import DayService

final class DayServiceTests: XCTestCase {
    typealias Engine = (
        HasDayManagerService &
        HasConsumptionManagerService &
        HasUnitService
    )
    
    var engine: Engine = EngineMocks()
    
    var dayManager: DayManagerStub!
    var consumptionManager: ConsumptionManagerStub!
    var sut: DayServiceType!
    
    override func setUp() {
        self.dayManager = DayManagerStub()
        self.engine.dayManager = dayManager
        self.consumptionManager = ConsumptionManagerStub()
        self.engine.consumptionManager = consumptionManager
        self.sut = DayService(engine: engine)
    }
    
    func test_getToday_success() async {
        let givenDate = dbDateFormatter.string(from: .now)
        let givenDay = DayModel(id: "1",
                                date: givenDate,
                                consumed: 0,
                                goal: 3)
        dayManager.fetchWithDate_returnValue = givenDay
        
        let foundDay = await sut.getToday()
        assert(day: foundDay, dayModel: givenDay)
    }
    
    func test_getToday_failedFetchForDate() async {
        let givenDate = dbDateFormatter.string(from: .now)
        let givenDay = DayModel(id: "1",
                                date: givenDate,
                                consumed: 0,
                                goal: 3)
        dayManager.fetchWithDate_returnError = DatabaseError.noElementFound
        dayManager.createNewDay_returnValue = givenDay
        
        let foundDay = await sut.getToday()
        assert(day: foundDay, dayModel: givenDay)
    }
    
    func test_addDrink() async throws {
        dayManager.add_returnValue = .init(id: "---", date: "---", consumed: 0.5, goal: 3)
        let result = try await sut.add(drink: .init(id: UUID(), size: 500, container: .medium))
        XCTAssertEqual(result, 0.5)
    }
    
    func test_addDrink_multiple() async throws {
        let _ = try await sut.add(drink: .init(id: UUID(), size: 500, container: .medium))
        let _ = try await sut.add(drink: .init(id: UUID(), size: 750, container: .medium))
        dayManager.add_returnValue = .init(id: "---", date: "---", consumed: 1.55, goal: 3)
        let result = try await sut.add(drink: .init(id: UUID(), size: 300, container: .medium))
        XCTAssertEqual(result, 1.55)
    }
    
    func test_removeDrink() async throws {
        let result = try await sut.remove(drink: .init(id: UUID(), size: 500, container: .medium))
        XCTAssertEqual(result, 0)
    }
    
    func test_removeDrink_removeLessThenAdded() async throws {
        let _ = try await sut.add(drink: .init(id: UUID(), size: 500, container: .medium))
        let _ = try await sut.add(drink: .init(id: UUID(), size: 750, container: .medium))
        
        dayManager.remove_returnValue = .init(id: "---", date: "---", consumed: 0.75, goal: 3)
        let result = try await sut.remove(drink: .init(id: UUID(), size: 500, container: .medium))
        XCTAssertEqual(result, 0.75)
    }
    
    func test_removeDrink_removeMoreThenAdded() async throws {
        let _ = try await sut.add(drink: .init(id: UUID(), size: 500, container: .medium))
        let _ = try await sut.add(drink: .init(id: UUID(), size: 750, container: .medium))
        
        let _ = try await sut.remove(drink: .init(id: UUID(), size: 500, container: .medium))
        let _ = try await sut.remove(drink: .init(id: UUID(), size: 500, container: .medium))
        let result = try await sut.remove(drink: .init(id: UUID(), size: 500, container: .medium))
        XCTAssertEqual(result, 0)
    }
}

extension DayServiceTests {
    func assert(day: Day, dayModel: DayModel,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(day.date.toDateString(), dayModel.date)
        XCTAssertEqual(day.consumed, dayModel.consumed)
        XCTAssertEqual(day.goal, dayModel.goal)
    }
}
