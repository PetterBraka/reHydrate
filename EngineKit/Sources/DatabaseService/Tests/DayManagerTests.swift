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
    
    let database = Database()
    var sut: DayManagerType!
    
    override func setUp() {
        self.sut = DayManager(database: database)
    }
    
    override func tearDown() async throws {
        try assertDbIsClosed()
    }

    func test_createNewDay_success() async throws {
        let day = try await sut.createNewDay(date: referenceDate, goal: 3)
        assert(givenDay: day, expectedConsumption: 0, expectedGoal: 3)
        try assertDbIsClosed()
    }
    
    func test_createNewDayAndFetchDay_success() async throws {
        let givenDay = try await sut.createNewDay(date: referenceDate, goal: 3)
        assert(givenDay: givenDay, expectedConsumption: 0, expectedGoal: 3)
        try assertDbIsClosed()
        let foundDay = try await sut.fetch(with: referenceDate)
        assert(givenDay: givenDay, expectedDay: foundDay)
        try assertDbIsClosed()
    }
    
    func test_fetchAll_success() async throws {
        try await preLoad4Days()
        let days = try await sut.fetchAll()
        XCTAssertEqual(days.count, 4)
        XCTAssertEqual(days.map(\.date),
                       XCTest.referenceDates.map { $0.toString() })
        try assertDbIsClosed()
    }
    
    func test_fetchLast_success() async throws {
        try await preLoad4Days()
        guard let lastDate = XCTest.referenceDates.last
        else {
            XCTFail("No day found")
            return
        }
        let lastDay = try await sut.fetchLast()
        XCTAssertEqual(lastDay.date, lastDate.toString())
        try assertDbIsClosed()
    }
    
    func test_deleteDay_success() async throws {
        try await preLoad4Days()
        let dayToDelete = try await sut.fetchLast()
        try assertDbIsClosed()
        try await sut.delete(dayToDelete)
        try assertDbIsClosed()
        let days = try await sut.fetchAll()
        try assertDbIsClosed()
        XCTAssertEqual(days.count, 3)
        XCTAssertFalse(days.contains(dayToDelete))
    }
    
    func test_deleteDate_success() async throws {
        let dateToDelete = XCTest.referenceDates[2]
        try await preLoad4Days()
        try await sut.deleteDay(at: dateToDelete)
        try assertDbIsClosed()
        let days = try await sut.fetchAll()
        try assertDbIsClosed()
        XCTAssertEqual(days.count, 3)
        XCTAssertFalse(days.contains(where: { $0.date == dateToDelete.toString() }))
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
        try assertDbIsClosed()
        let days = try await sut.fetchAll()
        try assertDbIsClosed()
        XCTAssertEqual(days.count, 1)
        let day = try XCTUnwrap(days.first)
        XCTAssertEqual(day.date, lastDate.toString())
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
        try assertDbIsClosed()
        let days = try await sut.fetchAll()
        try assertDbIsClosed()
        XCTAssertTrue(days.isEmpty)
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
    func assertDbIsClosed(file: StaticString = #file,
                          line: UInt = #line) throws {
        let db = try XCTUnwrap(database.db, file: file, line: line)
        XCTAssertTrue(db.isClosed, file: file, line: line)
    }
    
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
            try assertDbIsClosed(file: file, line: line)
        }
    }
}
