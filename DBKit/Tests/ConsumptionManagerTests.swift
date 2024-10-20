//
//  ConsumptionManagerTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 08/08/2023.
//

import XCTest
@testable import DBKit
import DBKitInterface
import DBKitMocks
import LoggingKit

final class ConsumptionManagerTests: XCTestCase {
    let referenceDate = Date(timeIntervalSince1970: 1688227143)
    /// [1/07/2023, 2/07/2023, 3/07/2023, 5/07/2023]
    let referenceDates = [
        Date(timeIntervalSince1970: 1688227143),
        Date(timeIntervalSince1970: 1688324062),
        Date(timeIntervalSince1970: 1688410462),
        Date(timeIntervalSince1970: 1688583262)
    ]
    
    var spy: DatabaseSpy<ConsumptionEntity, Database>!
    var sut: ConsumptionManagerType!
    
    override func setUp() {
        let logger = LoggerService(subsystem: "com.braka.test")
        let db = Database(appGroup: "group.com.testing.DBKit", inMemory: true, logger: logger)
        self.spy = DatabaseSpy(realObject: db)
        self.sut = ConsumptionManager(database: spy, logger: logger)
    }
    
    func test_add_one() async throws {
        let givenConsumption = Double.random(in: 300 ... 750)
        let newEntry = try await sut.createEntry(date: referenceDate, consumed: givenConsumption)
        assert(newEntry, expectedDate: referenceDate, expectedConsumption: givenConsumption)
        XCTAssertEqual(spy.methodLogNames, [.open, .save])
    }
    
    func test_add_multiple() async throws {
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        XCTAssertEqual(spy.methodLogNames, [
            .open, .save, .open, .save, .open, .save, .open, .save
        ])
    }
    
    func test_fetch() async throws {
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDates[1])
        try await createEntry(date: referenceDates[1])
        try await createEntry(date: referenceDates[1])
        try await createEntry(date: referenceDates[1])
        let result = try await sut.fetchAll(at: referenceDate)
        let secondResult = try await sut.fetchAll(at: referenceDates[1])
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(secondResult.count, 4)
        XCTAssertEqual(spy.methodLogNames, [
            .open, .save,
            .open, .save,
            .open, .save,
            .open, .save,
            .open, .save,
            .open, .save,
            .open, .save,
            .open, .read,
            .open, .read
        ])
    }
    
    func test_fetchAll() async throws {
        try await createEntry(date: referenceDates[0])
        try await createEntry(date: referenceDates[3])
        try await createEntry(date: referenceDates[2])
        try await createEntry(date: referenceDates[1])
        
        let result = try await sut.fetchAll()
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(spy.methodLogNames, [
            .open, .save,
            .open, .save,
            .open, .save,
            .open, .save,
            .open, .read
        ])
    }
    
    func test_delete() async throws {
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        let optionalEntry = try await sut.fetchAll().first
        let entry = try XCTUnwrap(optionalEntry)
        try await sut.delete(entry)
        XCTAssertEqual(spy.methodLogNames, [
            .open, .save,
            .open, .save,
            .open, .read,
            .open, .read,
            .open, .save
        ])
    }
    
    func test_delete_failure() async throws {
        try await createEntry(date: referenceDate)
        try await sut.delete(ConsumptionModel(id: "", date: "", time: "", consumed: 0))
        XCTAssertEqual(spy.methodLogNames, [.open, .save, .open, .read])
    }
    
    func test_map() async {
        let entity = await ConsumptionEntity(context: spy.open())
        entity.id = nil
        entity.date = nil
        entity.time = nil
        XCTAssertEqual(ConsumptionModel(from: entity),
                       ConsumptionModel(id: "", date: "", time: "", consumed: 0))
    }
    
    func test_map_withDefaults() async {
        let entity = await ConsumptionEntity(context: spy.open())
        XCTAssertEqual(ConsumptionModel(from: entity),
                       ConsumptionModel(id: "", date: "", time: "", consumed: 0))
    }
    
    func test_map_withId() async {
        let entity = await ConsumptionEntity(context: spy.open())
        entity.id = "id"
        XCTAssertEqual(ConsumptionModel(from: entity),
                       ConsumptionModel(id: "id", date: "", time: "", consumed: 0))
    }
    
    func test_map_withIdAndDate() async {
        let entity = await ConsumptionEntity(context: spy.open())
        entity.id = "id"
        entity.date = "date"
        XCTAssertEqual(ConsumptionModel(from: entity),
                       ConsumptionModel(id: "id", date: "date", time: "", consumed: 0))
    }
    
    func test_map_withIdAndDateAndTime() async {
        let entity = await ConsumptionEntity(context: spy.open())
        entity.id = "id"
        entity.date = "date"
        entity.time = "time"
        XCTAssertEqual(ConsumptionModel(from: entity),
                       ConsumptionModel(id: "id", date: "date", time: "time", consumed: 0))
    }
}

extension ConsumptionManagerTests {
    func assert(_ entry: ConsumptionModel,
                expectedDate: Date,
                expectedConsumption: Double,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(entry.date, expectedDate.toDateString(), line: line)
        XCTAssertEqual(entry.time, expectedDate.toTimeString(), line: line)
        XCTAssertEqual(entry.consumed, expectedConsumption, line: line)
    }
    
    func createEntry(date: Date,
                      file: StaticString = #file,
                     line: UInt = #line) async throws {
        let givenConsumption = Double.random(in: 300 ... 750)
        let newEntry = try await sut.createEntry(date: date, consumed: givenConsumption)
        assert(newEntry, expectedDate: date, expectedConsumption: givenConsumption,
               file: file, line: line)
    }
}

private extension Date {
    func toDateString() -> String {
        DatabaseFormatter.date.string(from: self)
    }
    
    func toTimeString() -> String {
        DatabaseFormatter.time.string(from: self)
    }
}

extension LoggerService: @retroactive @unchecked Sendable {}
