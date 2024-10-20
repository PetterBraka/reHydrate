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
        self.spy = DatabaseSpy(realObject: Database(appGroup: "group.com.testing.DBKit", inMemory: true, logger: logger))
        self.sut = ConsumptionManager(database: spy, logger: logger)
    }
    
    func test_add_one() async throws {
        let givenConsumption = Double.random(in: 300 ... 750)
        let newEntry = try sut.createEntry(date: referenceDate, consumed: givenConsumption)
        assert(newEntry, expectedDate: referenceDate, expectedConsumption: givenConsumption)
        XCTAssertEqual(spy.methodLogNames, [.open, .save])
    }
    
    func test_add_multiple() async throws {
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        XCTAssertEqual(spy.methodLogNames, [
            .open, .save, .save, .save, .save
        ])
    }
    
    func test_fetch() async throws {
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDates[1])
        try createEntry(date: referenceDates[1])
        try createEntry(date: referenceDates[1])
        try createEntry(date: referenceDates[1])
        let result = try await sut.fetchAll(at: referenceDate)
        let secondResult = try await sut.fetchAll(at: referenceDates[1])
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(secondResult.count, 4)
        XCTAssertEqual(spy.methodLogNames, [
            .open,
            .save, .save, .save,
            .save, .save, .save, .save,
            .read, .read
        ])
    }
    
    func test_fetchAll() async throws {
        try createEntry(date: referenceDates[0])
        try createEntry(date: referenceDates[3])
        try createEntry(date: referenceDates[2])
        try createEntry(date: referenceDates[1])
        
        let result = try await sut.fetchAll()
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(spy.methodLogNames, [
            .open,
            .save, .save, .save, .save,
            .read
        ])
    }
    
    func test_delete() async throws {
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        let optionalEntry = try await sut.fetchAll().first
        let entry = try XCTUnwrap(optionalEntry)
        try await sut.delete(entry)
        XCTAssertEqual(spy.methodLogNames, [
            .open,
            .save, .save,
            .read, .read,
            .save
        ])
    }
    
    func test_delete_failure() async throws {
        try createEntry(date: referenceDate)
        try await sut.delete(ConsumptionModel(id: "", date: "", time: "", consumed: 0))
        XCTAssertEqual(spy.methodLogNames, [.open, .save, .read])
    }
    
    func test_map() {
        let entity = ConsumptionEntity(context: spy.open())
        entity.id = nil
        entity.date = nil
        entity.time = nil
        XCTAssertEqual(ConsumptionModel(from: entity),
                       ConsumptionModel(id: "", date: "", time: "", consumed: 0))
    }
    
    func test_map_withDefaults() {
        let entity = ConsumptionEntity(context: spy.open())
        XCTAssertEqual(ConsumptionModel(from: entity),
                       ConsumptionModel(id: "", date: "", time: "", consumed: 0))
    }
    
    func test_map_withId() {
        let entity = ConsumptionEntity(context: spy.open())
        entity.id = "id"
        XCTAssertEqual(ConsumptionModel(from: entity),
                       ConsumptionModel(id: "id", date: "", time: "", consumed: 0))
    }
    
    func test_map_withIdAndDate() {
        let entity = ConsumptionEntity(context: spy.open())
        entity.id = "id"
        entity.date = "date"
        XCTAssertEqual(ConsumptionModel(from: entity),
                       ConsumptionModel(id: "id", date: "date", time: "", consumed: 0))
    }
    
    func test_map_withIdAndDateAndTime() {
        let entity = ConsumptionEntity(context: spy.open())
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
        XCTAssertEqual(entry.date, expectedDate.toDateString(), file: file, line: line)
        XCTAssertEqual(entry.time, expectedDate.toTimeString(), file: file, line: line)
        XCTAssertEqual(entry.consumed, expectedConsumption, file: file, line: line)
    }
    
    func createEntry(date: Date,
                      file: StaticString = #file,
                      line: UInt = #line) throws {
        let givenConsumption = Double.random(in: 300 ... 750)
        let newEntry = try sut.createEntry(date: date, consumed: givenConsumption)
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
