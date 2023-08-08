//
//  ConsumptionTimelineManagerTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 08/08/2023.
//

import XCTest
import TestHelper
@testable import DatabaseService
import DatabaseServiceInterface
import DatabaseServiceMocks

final class ConsumptionTimelineManagerTests: XCTestCase {
    let referenceDate = XCTest.referenceDate
    
    let database = Database()
    var sut: ConsumptionTimelineManagerType!
    
    override func setUp() {
        self.sut = ConsumptionTimelineManager(database: database)
    }
    
    override func tearDown() async throws {
        try assertDbIsClosed()
    }
    
    func test_add_one() async throws {
        let givenConsumption = Double.random(in: 300 ... 750)
        let newEntry = try await sut.createEntry(date: referenceDate, consumed: givenConsumption)
        assert(newEntry, expectedDate: referenceDate, expectedConsumption: givenConsumption)
    }
    
    func test_add_multiple() async throws {
        for index in 1 ... 15 {
            let givenConsumption = Double.random(in: 300 ... 750)
            let givenDate = referenceDate.addingTimeInterval(TimeInterval(60 * index))
            let newEntry = try await sut.createEntry(date: givenDate,
                                                     consumed: givenConsumption)
            assert(newEntry, expectedDate: givenDate, expectedConsumption: givenConsumption)
        }
    }
}

extension ConsumptionTimelineManagerTests {
    func assertDbIsClosed(file: StaticString = #file,
                          line: UInt = #line) throws {
        let db = try XCTUnwrap(database.db, file: file, line: line)
        XCTAssertTrue(db.isClosed, file: file, line: line)
    }
    
    func assert(_ entry: ConsumptionTimelineEntry,
                expectedDate: Date,
                expectedConsumption: Double,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(entry.date, expectedDate.toDateString(), file: file, line: line)
        XCTAssertEqual(entry.time, expectedDate.toTimeString(), file: file, line: line)
        XCTAssertEqual(entry.consumed, expectedConsumption, file: file, line: line)
    }
}
