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
    private typealias MethodName = DatabaseSpy<ConsumptionEntity, Database>.MethodName
    
    let referenceDate = Date(timeIntervalSince1970: 1688227143)
    /// [1/07/2023, 2/07/2023, 3/07/2023, 5/07/2023]
    let referenceDates = [
        Date(timeIntervalSince1970: 1688227143),
        Date(timeIntervalSince1970: 1688324062),
        Date(timeIntervalSince1970: 1688410462),
        Date(timeIntervalSince1970: 1688583262)
    ]
    
    var spy: DatabaseSpy<ConsumptionEntity, Database>
    var sut: ConsumptionManagerType

    init() async throws {
        let logger = LoggerService(subsystem: "com.braka.test")
        let db = Database(appGroup: "group.com.testing.DBKit", inMemory: true, logger: logger)
        self.spy = DatabaseSpy(realObject: db)
        self.sut = ConsumptionManager(database: spy, logger: logger)
    }
    
    @Test
    func addOne() async throws {
        let givenConsumption = Double.random(in: 300 ... 750)
        let newEntry = try await sut.createEntry(date: referenceDate, consumed: givenConsumption)
        assert(newEntry, expectedDate: referenceDate, expectedConsumption: givenConsumption)
        #expect(await spy.getMethodLogNames() == [
            .open, .save
        ])
    }
    
    @Test
    func addMultiple() async throws {
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        #expect(await spy.getMethodLogNames() == [
            .open, .save,
            .open, .save,
            .open, .save,
            .open, .save
        ])
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
        let result = try await sut.fetchAll(at: referenceDate)
        let secondResult = try await sut.fetchAll(at: referenceDates[1])
        #expect(result.count == 3)
        #expect(secondResult.count == 4)
        #expect(await spy.getMethodLogNames() == [
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
    
    @Test
    func fetchAll() async throws {
        try await createEntry(date: referenceDates[0])
        try await createEntry(date: referenceDates[3])
        try await createEntry(date: referenceDates[2])
        try await createEntry(date: referenceDates[1])
        
        let result = try await sut.fetchAll()
        #expect(result.count == 4)
        #expect(await spy.getMethodLogNames() == [
            .open, .save,
            .open, .save,
            .open, .save,
            .open, .save,
            .open, .read
        ])
    }
    
    @Test
    func delete() async throws {
        try await createEntry(date: referenceDate)
        try await createEntry(date: referenceDate)
        let optionalEntry = try await sut.fetchAll().first
        let entry = try #require(optionalEntry)
        try await sut.delete(entry)
        #expect(await spy.getMethodLogNames() == [
            .open, .save,
            .open, .save,
            .open, .read,
            .open, .read,
            .open, .save
        ])
    }
    
    @Test
    func deleteFailure() async throws {
        try await createEntry(date: referenceDate)
        try await sut.delete(ConsumptionModel(id: "", date: "", time: "", consumed: 0))
        #expect(await spy.getMethodLogNames() == [
            .open, .save,
            .open, .read
        ])
    }
    
    @Test
    func map() async {
        let entity = await spy.open()
        let consumptionEntity = ConsumptionEntity(context: entity)
        consumptionEntity.id = nil
        consumptionEntity.date = nil
        consumptionEntity.time = nil
        #expect(ConsumptionModel(from: consumptionEntity) == ConsumptionModel(id: "", date: "", time: "", consumed: 0))
    }
    
    @Test
    func mapWithDefaults() async {
        let entity = await spy.open()
        let consumptionEntity = ConsumptionEntity(context: entity)
        #expect(ConsumptionModel(from: consumptionEntity) == ConsumptionModel(id: "", date: "", time: "", consumed: 0))
    }
    
    @Test
    func mapWithId() async {
        let entity = await spy.open()
        let consumptionEntity = ConsumptionEntity(context: entity)
        consumptionEntity.id = "id"
        #expect(ConsumptionModel(from: consumptionEntity) == ConsumptionModel(id: "id", date: "", time: "", consumed: 0))
    }
    
    @Test
    func mapWithIdAndDate() async {
        let entity = await spy.open()
        let consumptionEntity = ConsumptionEntity(context: entity)
        consumptionEntity.id = "id"
        consumptionEntity.date = "date"
        #expect(ConsumptionModel(from: consumptionEntity) == ConsumptionModel(id: "id", date: "date", time: "", consumed: 0))
    }
    
    @Test
    func mapWithIdAndDateAndTime() async {
        let entity = await spy.open()
        let consumptionEntity = ConsumptionEntity(context: entity)
        consumptionEntity.id = "id"
        consumptionEntity.date = "date"
        consumptionEntity.time = "time"
        #expect(ConsumptionModel(from: consumptionEntity) == ConsumptionModel(id: "id", date: "date", time: "time", consumed: 0))
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

