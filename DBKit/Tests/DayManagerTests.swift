//
//  DayDbManagerTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Testing
import Foundation
@testable import DBKit
import DBKitInterface
import DBKitMocks
import LoggingKit

@Suite("DayManager")
struct DayManagerTests {
    let referenceDate = Date(timeIntervalSince1970: 1688227143)
    /// [1/07/2023, 2/07/2023, 3/07/2023, 5/07/2023]
    let referenceDates = [
        Date(timeIntervalSince1970: 1688227143),
        Date(timeIntervalSince1970: 1688324062),
        Date(timeIntervalSince1970: 1688410462),
        Date(timeIntervalSince1970: 1688583262)
    ]
    
    var spy: DatabaseSpy<DayModel, Database>!
    var sut: DayManagerType!
    
    init() async throws {
        let logger = LoggerService(subsystem: "com.braka.test")
        self.spy = DatabaseSpy(
            realObject: Database(
                appGroup: "group.com.testing.DBKit",
                inMemory: true,
                schema: .init([DayModel.self]),
                logger: logger
            )
        )
        self.sut = DayManager(database: spy, logger: logger)
    }
}

// MARK: - createNewDay
extension DayManagerTests {
    @Test
    func test_createNewDay_success() async throws {
        let day = try await sut.createNewDay(date: referenceDate, goal: 3)
        assert(givenDay: day, expectedConsumption: 0, expectedGoal: 3)
        #expect(try await spy.getMethodNamesLog() == [.insert, .save])
    }
    
    @Test
    func test_createNewDayAndFetchDay_success() async throws {
        let givenDay = try await sut.createNewDay(date: referenceDate, goal: 3)
        assert(givenDay: givenDay, expectedConsumption: 0, expectedGoal: 3)
        let foundDay = try await sut.fetch(with: referenceDate)
        assert(givenDay: givenDay, expectedDay: foundDay)
        #expect(try await spy.getMethodNamesLog() == [.insert, .save, .read])
    }
}

// MARK: - addConsumed
extension DayManagerTests {
    @Test
    func test_addConsumed() async throws {
        try await preLoad4Days()
        let givenConsumption: Double = 2
        let givenRandomDate = try #require(referenceDates.randomElement())
        let updatedDay = try await sut.add(consumed: givenConsumption, toDayAt: givenRandomDate)
        
        #expect(updatedDay.consumed == givenConsumption)
        #expect(updatedDay.date == givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
}

// MARK: - removeConsumed
extension DayManagerTests {
    @Test
    func test_removeConsumed() async throws {
        try await preLoad4Days()
        let givenConsumption: Double = 2
        let givenRandomDate = try #require(referenceDates.randomElement())
        let updatedDay = try await sut.remove(consumed: givenConsumption, fromDayAt: givenRandomDate)
        
        #expect(updatedDay.consumed == 0)
        #expect(updatedDay.date == givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
}

// MARK: - addGoal
extension DayManagerTests {
    @Test
    func test_addGoal() async throws {
        try await preLoad4Days()
        let givenRandomDate = try #require(referenceDates.randomElement())
        let updatedDay = try await sut.add(goal: 2, toDayAt: givenRandomDate)
        
        #expect(updatedDay.goal == 5)
        #expect(updatedDay.date == givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
}

// MARK: - removeGoal
extension DayManagerTests {
    @Test
    func test_removeGoal() async throws {
        try await preLoad4Days()
        let givenRandomDate = try #require(referenceDates.randomElement())
        let updatedDay = try await sut.remove(goal: 2, fromDayAt: givenRandomDate)
        
        #expect(updatedDay.goal == 1)
        #expect(updatedDay.date == givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
    
    @Test
    func test_removeGoal_tooMuch() async throws {
        try await preLoad4Days()
        let givenRandomDate = try #require(referenceDates.randomElement())
        let updatedDay = try await sut.remove(goal: 5, fromDayAt: givenRandomDate)
        
        #expect(updatedDay.goal == 0)
        #expect(updatedDay.date == givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
}

// MARK: - deleteDay
extension DayManagerTests {
    @Test
    func test_deleteDay_success() async throws {
        try await preLoad4Days()
        let dayToDelete = try await sut.fetchLast()
        try await sut.delete([dayToDelete])
        let days = try await sut.fetchAll()
        #expect(days.count == 3)
        #expect(!days.contains(dayToDelete))
        #expect(try await spy.getMethodNamesLog() == [.read, .delete, .save, .read])
    }
    
    @Test
    func test_deleteDay_withInvalidDate() async throws {
        do {
            try await sut.delete([DayModel(id: "", date: "", consumed: 0, goal: 0)])
            Issue.record("Shouldn't be able to delete day without valid data")
        } catch {}
        #expect(try await spy.getMethodNamesLog().isEmpty)
    }
}

// MARK: - deleteDate
extension DayManagerTests {
    @Test
    func test_deleteDate_success() async throws {
        let dateToDelete = referenceDates[2]
        try await preLoad4Days()
        try await sut.deleteDay(at: dateToDelete)
        let days = try await sut.fetchAll()
        #expect(days.count == 3)
        #expect(!days.contains(where: { $0.date == dateToDelete.toDateString() }))
        #expect(try await spy.getMethodNamesLog() == [.read, .delete, .save, .read])
    }
}

// MARK: - deleteDates
extension DayManagerTests {
    @Test
    func test_deleteDatesInClosedRange_success() async throws {
        let firstDate = try #require(referenceDates.first)
        let lastDate = try #require(referenceDates.last)
        try await preLoad4Days()
        
        do {
            try await sut.deleteDays(in: firstDate ... lastDate)
        } catch {
            Issue.record("Couldn't delete all days. \(error.localizedDescription)")
        }
        let days = try await sut.fetchAll()
        #expect(days.isEmpty)
        #expect(
            try await spy.getMethodNamesLog() == [.read, .delete, .delete, .delete, .delete, .save, .read]
        )
    }
}

// MARK: - fetchDay
extension DayManagerTests {
    @Test
    func test_fetchDay_success() async throws {
        try await preLoad4Days()
        let lastDate = try #require(referenceDates.last)
        _ = try await sut.fetch(with: lastDate)
        #expect(try await spy.getMethodNamesLog() == [.read])
    }
    
    @Test
    func test_fetchDay_noDay() async throws {
        let lastDate = try #require(referenceDates.last)
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetch(with: lastDate)
        }
        
        #expect(try await spy.getMethodNamesLog() == [.read])
    }
}

// MARK: - fetchLast
extension DayManagerTests {
    @Test
    func test_fetchLast_success() async throws {
        try await preLoad4Days()
        let lastDate = referenceDates.last!
        let lastDay = try await sut.fetchLast()
        #expect(lastDay.date == lastDate.toDateString())
        #expect(try await spy.getMethodNamesLog() == [.read])
    }
    
    @Test
    func test_fetchLast_noDays() async throws {
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetchLast()
        }
        #expect(try await spy.getMethodNamesLog() == [.read])
    }
}

// MARK: - fetchBetween
extension DayManagerTests {
    @Test
    func test_fetchBetween_success() async throws {
        try await preLoad4Days()
        let days = try await sut.fetch(between: referenceDates[0] ... referenceDates[2] )
        #expect(days.count == 3)
        #expect(days.map(\.date) == [referenceDates[0], referenceDates[1], referenceDates[2]].map { $0.toDateString() })
        #expect(try await spy.getMethodNamesLog() == [.read])
    }
    
    @Test
    func test_fetchBetween_longRange() async throws {
        try await preLoad4Days()
        let lower = Date(timeIntervalSince1970: 760521600)
        let upper = Date(timeIntervalSince1970: 1707206400)
        let days = try await sut.fetch(between: lower ... upper)
        #expect(days.count == 4)
        #expect(days.map(\.date) == referenceDates.map { $0.toDateString() })
        #expect(try await spy.getMethodNamesLog() == [.read])
    }
    
    @Test
    func test_fetchBetween_blankDay() async throws {
        await spy.insert(DayModel(id: "", date: "", consumed: 0, goal: 0))
        
        let days = try await sut.fetch(between: referenceDates.first! ... referenceDates.last! )
        #expect(days.count == 0)
        #expect(try await spy.getMethodNamesLog() == [.insert, .read])
    }
    
    @Test
    func test_fetchBetween_noDays() async throws {
        let days = try await sut.fetch(between: referenceDates.first! ... referenceDates.last! )
        #expect(days.count == 0)
        #expect(try await spy.getMethodNamesLog() == [.read])
    }
}

// MARK: - fetchAll
extension DayManagerTests {
    @Test
    func test_fetchAll_success() async throws {
        try await preLoad4Days()
        let days = try await sut.fetchAll()
        #expect(days.count == 4)
        #expect(days.map(\.date) == referenceDates.map { $0.toDateString() })
        #expect(try await spy.getMethodNamesLog() == [.read])
    }
    
    @Test
    func test_fetchAll_noDays() async throws {
        let days = try await sut.fetchAll()
        #expect(days.count == 0)
        #expect(try await spy.getMethodNamesLog() == [.read])
    }
}

// MARK: - ModelMapping
extension DayManagerTests {
    @Test
    func testMap_validDay_withDefaults() async {
        let validDay = DayModel(id: "", date: "", consumed: 0, goal: 0)
        #expect(validDay.date == "")
        #expect(validDay.consumed == 0)
        #expect(validDay.goal == 0)
    }
    
    @Test
    func testMap_validDay_withIdAndDate() async {
        let validDay = DayModel(id: "id", date: "02/05/1999", consumed: 0, goal: 0)
        #expect(validDay == DayModel(id: "id", date: "02/05/1999", consumed: 0, goal: 0))
    }
    
    @Test
    func testMap_validDay() async {
        let validDay = DayModel(id: "id", date: "02/05/1999", consumed: 9, goal: 9)
        #expect(validDay == DayModel(id: "id", date: "02/05/1999", consumed: 9, goal: 9))
    }
    
    @Test
    func testMap_invalidDay_id() async {
        let validDay = DayModel(id: "", date: "02/05/1999", consumed: 0, goal: 0)
        #expect(validDay.date == "02/05/1999")
        #expect(validDay.consumed == 0)
        #expect(validDay.goal == 0)
    }
}

private extension DayManagerTests {
    func assert(givenDay: DayModel,
                expectedDay: DayModel) {
        #expect(givenDay.date == expectedDay.date)
        #expect(givenDay.consumed == expectedDay.consumed)
        #expect(givenDay.goal == expectedDay.goal)
    }
    
    func assert(givenDay: DayModel,
                expectedConsumption: Double,
                expectedGoal: Double) {
        #expect(givenDay.date == "01/07/2023")
        #expect(givenDay.consumed == expectedConsumption)
        #expect(givenDay.goal == expectedGoal)
    }
    
    func preLoad4Days() async throws {
        _ = try await sut.createNewDay(date: referenceDates[0], goal: 3)
        _ = try await sut.createNewDay(date: referenceDates[1], goal: 3)
        _ = try await sut.createNewDay(date: referenceDates[2], goal: 3)
        _ = try await sut.createNewDay(date: referenceDates[3], goal: 3)
        await spy.resetMethodNameLog()
    }
}

private extension Date {
    func toDateString() -> String {
        DatabaseFormatter.date.string(from: self)
    }
}
