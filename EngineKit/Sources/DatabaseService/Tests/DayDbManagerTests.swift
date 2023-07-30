//
//  DayDbManagerTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import XCTest
import Foundation
import TestHelper
@testable import DatabaseService
import DatabaseServiceInterface
import DatabaseServiceMocks

final class DayDbManagerTests: XCTestCase {
    let referenceDate = XCTest.referenceDate
    
    let sut = DayDbManager(database: DatabaseStub())

    func test_createNewDay_success() async throws {
        let day = try await sut.createNewDay(date: referenceDate, goal: 3)
        assert(givenDay: day, expectedConsumption: 0, expectedGoal: 3)
    }
    
    func test_createNewDayAndFetchDay_success() async throws {
        let givenDay = try await sut.createNewDay(date: referenceDate, goal: 3)
        assert(givenDay: givenDay, expectedConsumption: 0, expectedGoal: 3)
        let foundDay = try await sut.fetch(with: referenceDate)
        assert(givenDay: givenDay, expectedDay: foundDay)
    }
    
    func test_fetchAll_success() async throws {
        try await preLoad4Days()
        let days = try await sut.fetchAll()
        XCTAssertEqual(days.count, 4)
        XCTAssertEqual(days.map(\.date),
                       XCTest.referenceDates.map { $0.toString() })
    }
    
    func test_fetchLast_success() async throws {
        try await preLoad4Days()
        guard let lastDate = XCTest.referenceDates.last,
              let lastDay = try await sut.fetchLast()
        else {
            XCTFail("No day found")
            return
        }
        XCTAssertEqual(lastDay.date, lastDate.toString())
    }
    
    func test_deleteDay_success() async throws {
        try await preLoad4Days()
        guard let dayToDelete = try await sut.fetchLast()
        else {
            XCTFail("No day found")
            return
        }
        try await sut.delete(dayToDelete)
        let days = try await sut.fetchAll()
        XCTAssertEqual(days.count, 3)
        XCTAssertFalse(days.contains(dayToDelete))
    }
    
    func test_deleteDate_success() async throws {
        let dateToDelete = XCTest.referenceDates[2]
        try await preLoad4Days()
        try await sut.deleteDay(at: dateToDelete)
        let days = try await sut.fetchAll()
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
        let days = try await sut.fetchAll()
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
        let days = try await sut.fetchAll()
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

private extension DayDbManagerTests {
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
