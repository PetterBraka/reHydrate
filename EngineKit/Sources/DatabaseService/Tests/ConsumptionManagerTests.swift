//
//  ConsumptionManagerTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 08/08/2023.
//

import XCTest
import TestHelper
@testable import DatabaseService
import DatabaseServiceInterface
import DatabaseServiceMocks

final class ConsumptionManagerTests: XCTestCase {
    let referenceDate = XCTest.referenceDate
    
    let database = Database()
    var spy: DatabaseSpy<Consumption>!
    var sut: ConsumptionManagerType!
    
    override func setUp() {
        self.spy = DatabaseSpy(realObject: database)
        self.sut = ConsumptionManager(database: spy)
    }
    
    override func tearDown() async throws {
        try await spy.deleteAll(Consumption(id: "", date: "", time: "", consumed: 0))
        let db = try XCTUnwrap(database.db)
        XCTAssertTrue(db.isClosed)
    }
    
    func test_add_one() async throws {
        let givenConsumption = Double.random(in: 300 ... 750)
        let newEntry = try await sut.createEntry(date: referenceDate, consumed: givenConsumption)
        assert(newEntry, expectedDate: referenceDate, expectedConsumption: givenConsumption)
        XCTAssertEqual(spy.methodLogNames, [.write])
    }
    
    func test_add_multiple() async throws {
        try await preLoadXEntries(15, startDate: XCTest.referenceDate)
        XCTAssertEqual(spy.methodLogNames, .init(repeating: .write, count: 15))
    }
    
    func test_fetch() async throws {
        try await preLoadXEntries(10, startDate: XCTest.referenceDate)
        try await preLoadXEntries(10, startDate: XCTest.referenceDates[2])
        let result = try await sut.fetchAll(at: XCTest.referenceDate)
        XCTAssertEqual(result.count, 10)
        XCTAssertEqual(spy.methodLogNames, .init(repeating: .write, count: 20) + [.readMatchingOrderByLimit])
    }
    
    func test_fetchAll() async throws {
        try await preLoadXEntries(10, startDate: XCTest.referenceDate)
        let result = try await sut.fetchAll()
        XCTAssertEqual(result.count, 10)
        XCTAssertEqual(spy.methodLogNames, .init(repeating: .write, count: 10) + [.readMatchingOrderByLimit])
    }
    
    func test_delete() async throws {
        try await preLoadXEntries(2, startDate: XCTest.referenceDate)
        let optionalEntry = try await sut.fetchAll().first
        let entry = try XCTUnwrap(optionalEntry)
        try await sut.delete(entry)
        XCTAssertEqual(spy.methodLogNames, [.write, .write, .readMatchingOrderByLimit, .delete])
    }
}

extension ConsumptionManagerTests {
    func assert(_ entry: Consumption,
                expectedDate: Date,
                expectedConsumption: Double,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(entry.date, expectedDate.toDateString(), file: file, line: line)
        XCTAssertEqual(entry.time, expectedDate.toTimeString(), file: file, line: line)
        XCTAssertEqual(entry.consumed, expectedConsumption, file: file, line: line)
    }
    
    func preLoadXEntries(_ number: Int, startDate: Date,
                         file: StaticString = #file,
                         line: UInt = #line) async throws {
        let min = 1
        XCTAssertTrue(number > min)
        for index in min ... number {
            let givenConsumption = Double.random(in: 300 ... 750)
            let givenDate = startDate.addingTimeInterval(TimeInterval(60 * index))
            let newEntry = try await sut.createEntry(date: givenDate,
                                                     consumed: givenConsumption)
            assert(newEntry, expectedDate: givenDate, expectedConsumption: givenConsumption, file: file, line: line)
        }
    }
}
