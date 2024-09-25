//
//  DayDbManagerTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import XCTest
@testable import DBKit
import DBKitInterface
import DBKitMocks

final class DayManagerTests: XCTestCase {
    let referenceDate = Date(timeIntervalSince1970: 1688227143)
    /// [1/07/2023, 2/07/2023, 3/07/2023, 5/07/2023]
    let referenceDates = [
        Date(timeIntervalSince1970: 1688227143),
        Date(timeIntervalSince1970: 1688324062),
        Date(timeIntervalSince1970: 1688410462),
        Date(timeIntervalSince1970: 1688583262)
    ]
    
    var spy: DatabaseSpy<DayEntity, Database>!
    var sut: DayManagerType!
    
    override func setUp() {
        self.spy = DatabaseSpy(realObject: Database(appGroup: "group.com.testing.DBKit", inMemory: true))
        self.sut = DayManager(database: spy)
    }
}

// MARK: - createNewDay
extension DayManagerTests {
    func test_createNewDay_success() async throws {
        let day = try sut.createNewDay(date: referenceDate, goal: 3)
        assert(givenDay: day, expectedConsumption: 0, expectedGoal: 3)
        XCTAssertEqual(spy.methodLogNames, [.open, .save])
    }
    
    func test_createNewDayAndFetchDay_success() async throws {
        let givenDay = try sut.createNewDay(date: referenceDate, goal: 3)
        assert(givenDay: givenDay, expectedConsumption: 0, expectedGoal: 3)
        let foundDay = try await sut.fetch(with: referenceDate)
        assert(givenDay: givenDay, expectedDay: foundDay)
        XCTAssertEqual(spy.methodLogNames, [.open, .save, .read])
    }
}

// MARK: - addConsumed
extension DayManagerTests {
    func test_addConsumed() async throws {
        try preLoad4Days()
        let givenConsumption: Double = 2
        guard let givenRandomDate = referenceDates.randomElement()
        else {
            XCTFail("No day found")
            return
        }
        let updatedDay = try await sut.add(consumed: givenConsumption, toDayAt: givenRandomDate)
        
        XCTAssertEqual(updatedDay.consumed, givenConsumption)
        XCTAssertEqual(updatedDay.date, givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
}

// MARK: - removeConsumed
extension DayManagerTests {
    func test_removeConsumed() async throws {
        try preLoad4Days()
        let givenConsumption: Double = 2
        guard let givenRandomDate = referenceDates.randomElement()
        else {
            XCTFail("No day found")
            return
        }
        let updatedDay = try await sut.remove(consumed: givenConsumption, fromDayAt: givenRandomDate)
        
        XCTAssertEqual(updatedDay.consumed, 0)
        XCTAssertEqual(updatedDay.date, givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
}

// MARK: - addGoal
extension DayManagerTests {
    func test_addGoal() async throws {
        try preLoad4Days()
        guard let givenRandomDate = referenceDates.randomElement()
        else {
            XCTFail("No day found")
            return
        }
        let updatedDay = try await sut.add(goal: 2, toDayAt: givenRandomDate)
        
        XCTAssertEqual(updatedDay.goal, 5)
        XCTAssertEqual(updatedDay.date, givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
}

// MARK: - removeGoal
extension DayManagerTests {
    func test_removeGoal() async throws {
        try preLoad4Days()
        guard let givenRandomDate = referenceDates.randomElement()
        else {
            XCTFail("No day found")
            return
        }
        let updatedDay = try await sut.remove(goal: 2, fromDayAt: givenRandomDate)
        
        XCTAssertEqual(updatedDay.goal, 1)
        XCTAssertEqual(updatedDay.date, givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
    
    func test_removeGoal_tooMuch() async throws {
        try preLoad4Days()
        guard let givenRandomDate = referenceDates.randomElement()
        else {
            XCTFail("No day found")
            return
        }
        let updatedDay = try await sut.remove(goal: 5, fromDayAt: givenRandomDate)
        
        XCTAssertEqual(updatedDay.goal, 0)
        XCTAssertEqual(updatedDay.date, givenRandomDate.toDateString())
        
        let fetchedDay = try await sut.fetch(with: givenRandomDate)
        assert(givenDay: updatedDay, expectedDay: fetchedDay)
    }
}

// MARK: - deleteDay
extension DayManagerTests {
    func test_deleteDay_success() async throws {
        try preLoad4Days()
        let dayToDelete = try await sut.fetchLast()
        try await sut.delete(dayToDelete)
        let days = try await sut.fetchAll()
        XCTAssertEqual(days.count, 3)
        XCTAssertFalse(days.contains(dayToDelete))
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() +
                       [.read, .read, .save, .read])
    }
    
    func test_deleteDay_withInvalidDate() async throws {
        do {
            try await sut.delete(DayModel(id: "", date: "", consumed: 0, goal: 0))
            XCTFail("Shouldn't be able to delete day without valid data")
        } catch {}
        XCTAssertEqual(spy.methodLogNames,
                       [.open])
    }
}

// MARK: - deleteDate
extension DayManagerTests {
    func test_deleteDate_success() async throws {
        let dateToDelete = referenceDates[2]
        try preLoad4Days()
        try await sut.deleteDay(at: dateToDelete)
        let days = try await sut.fetchAll()
        XCTAssertEqual(days.count, 3)
        XCTAssertFalse(days.contains(where: { $0.date == dateToDelete.toDateString() }))
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() +
                       [.read, .save, .read])
    }
}

// MARK: - deleteDates
extension DayManagerTests {
    func test_deleteDatesInClosedRange_success() async throws {
        guard let firstDate = referenceDates.first,
              let lastDate = referenceDates.last
        else {
            XCTFail("Failed getting reference dates")
            return
        }
        try preLoad4Days()
        do {
            try await sut.deleteDays(in: firstDate ... lastDate)
        } catch {
            XCTFail("Couldn't delete all days. \(error.localizedDescription)")
        }
        let days = try await sut.fetchAll()
        XCTAssertTrue(days.isEmpty)
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() + [.read] + .delete(times: 4) + [.read])
    }
}

// MARK: - fetchDay
extension DayManagerTests {
    func test_fetchDay_success() async throws {
        try preLoad4Days()
        let lastDate = try XCTUnwrap(referenceDates.last)
        _ = try await sut.fetch(with: lastDate)
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() + [.read])
    }
    
    func test_fetchDay_noDay() async throws {
        guard let lastDate = referenceDates.last
        else {
            XCTFail("No day found")
            return
        }
        do {
            _ = try await sut.fetch(with: lastDate)
            XCTFail("Should fail")
        } catch {
            XCTAssertNotNil(error)
        }
        XCTAssertEqual(spy.methodLogNames, [.open, .read])
    }
}

// MARK: - fetchLast
extension DayManagerTests {
    func test_fetchLast_success() async throws {
        try preLoad4Days()
        let lastDate = referenceDates.last!
        let lastDay = try await sut.fetchLast()
        XCTAssertEqual(lastDay.date, lastDate.toDateString())
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() +
                       [.read])
    }
    
    func test_fetchLast_noDays() async throws {
        do {
            _ = try await sut.fetchLast()
            XCTFail("Should fail")
        } catch {
            XCTAssertNotNil(error)
        }
        XCTAssertEqual(spy.methodLogNames, [.open, .read])
    }
}

// MARK: - fetchBetween
extension DayManagerTests {
    func test_fetchBetween_success() async throws {
        try preLoad4Days()
        let days = try await sut.fetch(between: referenceDates.first! ... referenceDates.last! )
        XCTAssertEqual(days.count, 4)
        XCTAssertEqual(days.map(\.date),
                       referenceDates.map { $0.toDateString() })
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() + [.read])
    }
    
    func test_fetchBetween_longRange() async throws {
        try preLoad4Days()
        let lower = Date(timeIntervalSince1970: 760521600)
        let upper = Date(timeIntervalSince1970: 1707206400)
        let days = try await sut.fetch(between: lower ... upper)
        XCTAssertEqual(days.count, 4)
        XCTAssertEqual(days.map(\.date),
                       referenceDates.map { $0.toDateString() })
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() + [.read])
    }
    
    func test_fetchBetween_blankDay() async throws {
        let context = spy.open()
        let day = DayEntity(context: context)
        day.id = ""
        day.date = ""
        try context.save()
        
        let days = try await sut.fetch(between: referenceDates.first! ... referenceDates.last! )
        XCTAssertEqual(days.count, 0)
        XCTAssertEqual(spy.methodLogNames, [.open, .open, .read])
    }
    
    func test_fetchBetween_noDays() async throws {
        let days = try await sut.fetch(between: referenceDates.first! ... referenceDates.last! )
        XCTAssertEqual(days.count, 0)
        XCTAssertEqual(spy.methodLogNames, [.open, .read])
    }
}

// MARK: - fetchAll
extension DayManagerTests {
    func test_fetchAll_success() async throws {
        try preLoad4Days()
        let days = try await sut.fetchAll()
        XCTAssertEqual(days.count, 4)
        XCTAssertEqual(days.map(\.date),
                       referenceDates.map { $0.toDateString() })
        XCTAssertEqual(spy.methodLogNames, .preLoaded4Days() + [.read])
    }
    
    func test_fetchAll_noDays() async throws {
        let days = try await sut.fetchAll()
        XCTAssertEqual(days.count, 0)
        XCTAssertEqual(spy.methodLogNames, [.open, .read])
    }
}

// MARK: - ModelMapping
extension DayManagerTests {
    func testMap_validDay_withDefaults() {
        let validDay = DayEntity(context: spy.open())
        validDay.id = nil
        validDay.date = nil
        XCTAssertEqual(DayModel(from: validDay).date, "")
        XCTAssertEqual(DayModel(from: validDay).consumed, 0)
        XCTAssertEqual(DayModel(from: validDay).goal, 0)
    }
    
    func testMap_validDay_withIdAndDate() {
        let validDay = DayEntity(context: spy.open())
        validDay.id = "id"
        validDay.date = "02/05/1999"
        XCTAssertEqual(DayModel(from: validDay),
                       DayModel(id: "id", date: "02/05/1999", consumed: 0, goal: 0))
    }
    
    func testMap_validDay() {
        let validDay = DayEntity(context: spy.open())
        validDay.id = "id"
        validDay.date = "02/05/1999"
        validDay.consumed = 9
        validDay.goal = 9
        XCTAssertEqual(DayModel(from: validDay),
                       DayModel(id: "id", date: "02/05/1999", consumed: 9, goal: 9))
    }
    
    func testMap_invalidDay_id() {
        let validDay = DayEntity(context: spy.open())
        validDay.id = nil
        validDay.date = "02/05/1999"
        XCTAssertEqual(DayModel(from: validDay).date, "02/05/1999")
        XCTAssertEqual(DayModel(from: validDay).consumed, 0)
        XCTAssertEqual(DayModel(from: validDay).goal, 0)
    }
}

private extension DayManagerTests {
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
                      line: UInt = #line) throws {
        let _ = try sut.createNewDay(date: referenceDates[0], goal: 3)
        let _ = try sut.createNewDay(date: referenceDates[1], goal: 3)
        let _ = try sut.createNewDay(date: referenceDates[2], goal: 3)
        let _ = try sut.createNewDay(date: referenceDates[3], goal: 3)
    }
}

private extension Array where Element == DatabaseSpy<DayEntity, Database>.MethodName {
    static func preLoaded4Days() -> [Element] {
        [.open] + .init(repeating: .save, count: 4)
    }
    
    static func delete(times number: Int) -> [Element] {
        .init(repeating: .save, count: number)
    }
}

private extension Date {
    func toDateString() -> String {
        DatabaseFormatter.date.string(from: self)
    }
}
