//
//  ConsumptionManagerTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 08/08/2023.
//

import CoreData
import Testing
@testable import DBKit
import DBKitInterface
import DBKitMocks
import LoggingKit

@Suite("ConsumptionManager")
struct ConsumptionManagerTests {
    let referenceDate = Date(timeIntervalSince1970: 1688227143)
    /// [1/07/2023, 2/07/2023, 3/07/2023, 5/07/2023]
    let referenceDates = [
        Date(timeIntervalSince1970: 1688227143),
        Date(timeIntervalSince1970: 1688324062),
        Date(timeIntervalSince1970: 1688410462),
        Date(timeIntervalSince1970: 1688583262)
    ]
    
    var sut: ConsumptionManagerType

    init() async throws {
        let logger = LoggerService(subsystem: "com.braka.test")
        let container = Database.createContainer(
            path: nil,
            inMemory: true,
            schema: .init([ConsumptionEntity.self])
        )
        self.sut = ConsumptionManager(container: container, logger: logger)
    }
    
    @Test
    func addOne() async throws {
        let givenConsumption = Double.random(in: 300 ... 750)
        let newEntry = try await sut.createEntry(date: referenceDate, consumed: givenConsumption)
        assert(newEntry, expectedDate: referenceDate, expectedConsumption: givenConsumption)
        #expect(try await sut.fetchAll().count == 1)
    }
    
    @Test
    func addMultiple() async throws {
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        #expect(try await sut.fetchAll().count == 4)
    }
    
    @Test
    func fetch() async throws {
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDates[1])
        try await createEntry(date: referenceDates[1])
        try await createEntry(date: referenceDates[1])
        try await createEntry(date: referenceDates[1])
        
        let result = try await sut.fetchAll()
        let resultSecond = try await sut.fetchAll(at: referenceDate)
        let resultThird = try await sut.fetchAll(at: referenceDates[1])
        #expect(result.count == 7)
        #expect(resultSecond.count == 3)
        #expect(resultThird.count == 4)
    }
    
    @Test
    func fetchAll() async throws {
        try await createEntry(date: referenceDates[0])
        try await createEntry(date: referenceDates[3])
        try await createEntry(date: referenceDates[2])
        try await createEntry(date: referenceDates[1])
        
        let result = try await sut.fetchAll()
        #expect(result.count == 4)
    }
    
    @Test
    func delete() async throws {
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        
        let entry = try #require(try await sut.fetchAll().first)
        try await sut.delete(entry)
        #expect(try await sut.fetchAll().count == 1)
    }
    
    @Test
    func delete_whenEmpty() async throws {
        try await #require(throws: DatabaseError.noElementFound) {
            try await sut.delete(.init(id: "", date: "", time: "", consumed: 0))
        }
    }

    func assert(_ entry: ConsumptionModel,
                expectedDate: Date,
                expectedConsumption: Double) {
        #expect(entry.date == expectedDate.toDateString())
        #expect(entry.time == expectedDate.toTimeString())
        #expect(entry.consumed == expectedConsumption)
    }
    
    func createEntry(date: Date) async throws {
        let givenConsumption = Double.random(in: 300 ... 750)
        let newEntry = try await sut.createEntry(date: date, consumed: givenConsumption)
        assert(newEntry, expectedDate: date, expectedConsumption: givenConsumption)
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

