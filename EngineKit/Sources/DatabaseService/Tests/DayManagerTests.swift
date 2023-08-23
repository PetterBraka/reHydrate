//
//  DayDbManagerTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import XCTest
import TestHelper
@testable import DatabaseService
import DatabaseServiceInterface
import DatabaseServiceMocks

final class DayManagerTests: XCTestCase {
    let referenceDate = XCTest.referenceDate
    
    var database: Database!
    var spy: DatabaseSpy<DayModel>!
    var sut: DayManagerType!
    
    override func setUp() {
        self.database = Database()
        self.spy = DatabaseSpy(realObject: database)
        self.sut = DayManager(database: spy)
    }
    
    override func tearDown() async throws {
        let db = try XCTUnwrap(database.db)
        XCTAssertTrue(db.isClosed)
    }
    
    func test_createNewDay_success() async throws {
        let day = try await sut.createNewDay(date: referenceDate, goal: 3)
        assert(givenDay: day, expectedConsumption: 0, expectedGoal: 3)
        XCTAssertEqual(spy.methodLogNames, [.write])
    }
    
    func test_createNewDayAndFetchDay_success() async throws {
        let givenDay = try await sut.createNewDay(date: referenceDate, goal: 3)
        assert(givenDay: givenDay, expectedConsumption: 0, expectedGoal: 3)
        let foundDay = try await sut.fetch(with: referenceDate)
        assert(givenDay: givenDay, expectedDay: foundDay)
        XCTAssertEqual(spy.methodLogNames, [.write, .readMatchingOrderByLimit])
    }
    
    func test_fetchAll_success() async throws {
        try await preLoad4Days()
        let days = try await sut.fetchAll()
        XCTAssertEqual(days.count, 4)
        XCTAssertEqual(days.map(\.date),
                       XCTest.referenceDates.map { $0.toDateString() })
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() + [.readMatchingOrderByLimit])
    }
    
    func test_fetchLast_success() async throws {
        try await preLoad4Days()
        guard let lastDate = XCTest.referenceDates.last
        else {
            XCTFail("No day found")
            return
        }
        let lastDay = try await sut.fetchLast()
        XCTAssertEqual(lastDay.date, lastDate.toDateString())
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() +
                       [.readMatchingOrderByLimit])
    }
    
    func test_addToDay() async throws {
        try await preLoad4Days()
        let givenConsumption: Double = 2
        guard let givenRandomDate = XCTest.referenceDates.randomElement()
        else {
            XCTFail("No day found")
            return
        }
        let updatedDay = try await sut.add(givenConsumption, toDayAt: givenRandomDate)
        
        XCTAssertEqual(updatedDay.consumed, givenConsumption)
        XCTAssertEqual(updatedDay.date, givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
    
    func test_removeToDay() async throws {
        try await preLoad4Days()
        let givenConsumption: Double = 2
        guard let givenRandomDate = XCTest.referenceDates.randomElement()
        else {
            XCTFail("No day found")
            return
        }
        let updatedDay = try await sut.remove(givenConsumption, fromDayAt: givenRandomDate)
        
        XCTAssertEqual(updatedDay.consumed, 0)
        XCTAssertEqual(updatedDay.date, givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
    
    func test_deleteDay_success() async throws {
        try await preLoad4Days()
        let dayToDelete = try await sut.fetchLast()
        try await sut.delete(dayToDelete)
        let days = try await sut.fetchAll()
        XCTAssertEqual(days.count, 3)
        XCTAssertFalse(days.contains(dayToDelete))
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() +
                       [.readMatchingOrderByLimit, .delete, .readMatchingOrderByLimit])
    }
    
    func test_deleteDate_success() async throws {
        let dateToDelete = XCTest.referenceDates[2]
        try await preLoad4Days()
        try await sut.deleteDay(at: dateToDelete)
        let days = try await sut.fetchAll()
        XCTAssertEqual(days.count, 3)
        XCTAssertFalse(days.contains(where: { $0.date == dateToDelete.toDateString() }))
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() +
                       [.deleteMatching, .readMatchingOrderByLimit])
    }
    
    func test_deleteDatesInRange_success() async throws {
        guard let firstDate = XCTest.referenceDates.first,
              let lastDate = XCTest.referenceDates.last
        else {
            XCTFail("Failed getting reference dates")
            return
        }
        try await preLoad4Days()
        try await sut.deleteDays(in: firstDate ..< lastDate)
        let days = try await sut.fetchAll()
        XCTAssertEqual(days.count, 1)
        let day = try XCTUnwrap(days.first)
        XCTAssertEqual(day.date, lastDate.toDateString())
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() + .deleteMatching(times: 3) +
                       [.deleteMatching, .readMatchingOrderByLimit])
    }
    
    func test_deleteDatesInClosedRange_success() async throws {
        guard let firstDate = XCTest.referenceDates.first,
              let lastDate = XCTest.referenceDates.last
        else {
            XCTFail("Failed getting reference dates")
            return
        }
        try await preLoad4Days()
        try await sut.deleteDays(in: firstDate ... lastDate)
        let days = try await sut.fetchAll()
        XCTAssertTrue(days.isEmpty)
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() + .deleteMatching(times: 5) +
                       [.readMatchingOrderByLimit])
    }
    
    func testPerformance_createNewDay_success() async throws {
        self.measure {
            let expectation = expectation(description: "finished")
            Task { @MainActor in
                do {
                    let _ = try await self.sut.createNewDay(date: self.referenceDate, goal: 3)
                    expectation.fulfill()
                } catch {
                    XCTFail(error.localizedDescription)
                    expectation.fulfill()
                }
            }
            wait(for: [expectation], timeout: 2)
        }
    }
}

private extension DayManagerTests {
    func assert(givenDay: DayModel,
                expectedDay: DayModel,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(givenDay.date, expectedDay.date,
                       file: file, line: line)
        XCTAssertEqual(givenDay.consumed, expectedDay.consumed,
                       file: file, line: line)
        XCTAssertEqual(givenDay.goal, expectedDay.goal,
                       file: file, line: line)
    }
    
    func assert(givenDay: DayModel,
                expectedConsumption: Double,
                expectedGoal: Double,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(givenDay.date, "01/07/2023",
                       file: file, line: line)
        XCTAssertEqual(givenDay.consumed, expectedConsumption,
                       file: file, line: line)
        XCTAssertEqual(givenDay.goal, expectedGoal,
                       file: file, line: line)
    }
    
    func preLoad4Days(file: StaticString = #file,
                      line: UInt = #line) async throws {
        for date in XCTest.referenceDates {
            let _ = try await sut.createNewDay(date: date, goal: 3)
        }
    }
}

private extension Array where Element == DatabaseSpy<DayModel>.MethodName {
    static func preLoaded4Days() -> [DatabaseSpy<DayModel>.MethodName] {
        [.write, .write, .write, .write]
    }
    
    static func delete(times number: Int) -> [DatabaseSpy<DayModel>.MethodName] {
        .init(repeating: .delete, count: number)
    }
    
    static func deleteMatching(times number: Int) -> [DatabaseSpy<DayModel>.MethodName] {
        .init(repeating: .deleteMatching, count: number)
    }
}
