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

final class ConsumptionManagerTests: XCTestCase {
    let referenceDate = Date(timeIntervalSince1970: 1688227143)
    let secondReferenceDate = Date(timeIntervalSince1970: 1688324062)
    
    var spy: DatabaseSpy<ConsumptionEntity, Database<ConsumptionEntity>>!
    var sut: ConsumptionManagerType!
    
    override func setUp() {
        let db: Database<ConsumptionEntity> = Database(inMemory: true)
        self.spy = DatabaseSpy(realObject: db)
        self.sut = ConsumptionManager(database: spy)
    }
    
    func test_add_one() async throws {
        let givenConsumption = Double.random(in: 300 ... 750)
        let newEntry = try sut.createEntry(date: referenceDate, consumed: givenConsumption)
        assert(newEntry, expectedDate: referenceDate, expectedConsumption: givenConsumption)
        XCTAssertEqual(spy.methodLogNames, [.open, .create, .save])
    }
    
    func test_add_multiple() async throws {
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        XCTAssertEqual(spy.methodLogNames, [
            .open, .create, .save, .create, .save, .create, .save, .create, .save
        ])
    }
    
    func test_fetch() async throws {
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        try createEntry(date: secondReferenceDate)
        try createEntry(date: secondReferenceDate)
        try createEntry(date: secondReferenceDate)
        try createEntry(date: secondReferenceDate)
        let result = try await sut.fetchAll(at: referenceDate)
        let secondResult = try await sut.fetchAll(at: secondReferenceDate)
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(secondResult.count, 4)
        XCTAssertEqual(spy.methodLogNames, [
            .open,
            .create, .save, .create, .save, .create, .save,
            .create, .save, .create, .save, .create, .save, .create, .save,
            .read, .read
        ])
    }
    
    func test_fetchAll() async throws {
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        try createEntry(date: referenceDate)
        
        let result = try await sut.fetchAll()
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(spy.methodLogNames, [
            .open,
            .create, .save, .create, .save, .create, .save, .create, .save,
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
            .create, .save, .create, .save,
            .read, .read, .delete
        ])
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
