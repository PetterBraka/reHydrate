//
//  File.swift
//
//
//  Created by Petter vang Brakalsvålet on 28/01/2024.
//

@testable import DateService
import Foundation
import XCTest
import TestHelper

final class DateServiceTests: XCTestCase {
    var calendar: Calendar!
    var sut: DateService!
    
    override func setUp() {
        calendar = Calendar(identifier: .gregorian)
        calendar.locale = .init(languageComponents: .init(languageCode: .english,
                                                          script: .georgian,
                                                          region: .unitedKingdom))
        sut = DateService(calendar: calendar)
    }
}

extension DateServiceTests {
    func test_getEnd_june_10_2018() {
        let date = sut.getEnd(of: .june_10_2018_Sunday)
        
        assert(givenDate: date,
               expectedYear: 2018, expectedMonth: 6, expectedDay: 10,
               expectedHours: 23, expectedMinutes: 59, expectedSeconds: 59)
    }
    
    func test_getEnd_february_1_2024() {
        let date = sut.getEnd(of: .february_1_2024_Thursday)
        
        assert(givenDate: date,
               expectedYear: 2024, expectedMonth: 2, expectedDay: 1,
               expectedHours: 23, expectedMinutes: 59, expectedSeconds: 59)
    }
    
    func test_getEnd_november_3_1966() {
        let date = sut.getEnd(of: .november_3_1966_Thursday)
        
        assert(givenDate: date,
               expectedYear: 1966, expectedMonth: 11, expectedDay: 3,
               expectedHours: 23, expectedMinutes: 59, expectedSeconds: 59)
    }
    
    func test_getEnd_march_7_1994() {
        let date = sut.getEnd(of: .march_5_1970_Thursday)
        
        assert(givenDate: date,
               expectedYear: 1970, expectedMonth: 3, expectedDay: 5,
               expectedHours: 23, expectedMinutes: 59, expectedSeconds: 59)
    }
}

extension DateServiceTests {
    func test_daysBetween_january_10_2024() {
        let days = sut.daysBetween(.january_10_2024_Wednesday, end: .january_12_2024_Friday)
        XCTAssertEqual(days, 2)
    }
    
    func test_daysBetween_february_6_1994() {
        let days = sut.daysBetween(.february_6_1994_Sunday, end: .february_1_2024_Thursday)
        XCTAssertEqual(days, 10_952)
    }
    
    func test_daysBetween_february_2_1998() throws {
        let days = try sut.daysBetween(.init(year: 1998, month: 2, day: 2),
                                       end: .february_1_2024_Thursday)
        XCTAssertEqual(days, 9_495)
    }
    
    func test_daysBetween_march_5_1970() {
        let days = sut.daysBetween(.march_5_1970_Thursday, end: .february_1_2024_Thursday)
        XCTAssertEqual(days, 19_690)
    }
    
    func test_daysBetween_november_3_1966() {
        let days = sut.daysBetween(.november_3_1966_Thursday, end: .february_1_2024_Thursday)
        XCTAssertEqual(days, 20_909)
    }
}

extension DateServiceTests {
    func test_getDate_possitive10() {
        let date = sut.getDate(byAddingDays: 10, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2024, expectedMonth: 1, expectedDay: 11)
    }
    
    func test_getDate_possitive366() {
        let date = sut.getDate(byAddingDays: 366, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2025, expectedMonth: 1, expectedDay: 1)
    }
    
    func test_getDate_possitive730() {
        let date = sut.getDate(byAddingDays: 730, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2025, expectedMonth: 12, expectedDay: 31)
    }
    
    func test_getDate_negative8() {
        let date = sut.getDate(byAddingDays: -8, to: .february_6_1994_Sunday)
        assert(givenDate: date, expectedYear: 1994, expectedMonth: 1, expectedDay: 29)
    }
    
    func test_getDate_negative60() {
        let date = sut.getDate(byAddingDays: -60, to: .february_6_1994_Sunday)
        assert(givenDate: date, expectedYear: 1993, expectedMonth: 12, expectedDay: 8)
    }
}

extension DateServiceTests {
    func assert(
        givenDate: Date?,
        expectedYear year: Int, expectedMonth month: Int,
        expectedDay day: Int, expectedHours hours: Int,
        expectedMinutes minutes: Int, expectedSeconds seconds: Int,
        file: StaticString = #file, line: UInt = #line
    ) {
        let expectedDate = calendar.date(from: DateComponents(
            year: year, month: month, day: day,
            hour: hours, minute: minutes, second: seconds
        ))
        
        XCTAssertEqual(givenDate, expectedDate, file: file, line: line)
    }
    
    func assert(
        givenDate: Date?,
        expectedYear year: Int, expectedMonth month: Int, expectedDay day: Int,
        file: StaticString = #file, line: UInt = #line
    ) {
        guard let givenDate else {
            XCTFail("Given date was nil.", file: file, line: line)
            return
        }
        let givenComponents = calendar.dateComponents([.hour, .minute, .second], from: givenDate)
        let expectedDate = calendar.date(from: DateComponents(
            year: year, month: month, day: day,
            hour: givenComponents.hour ?? 0,
            minute: givenComponents.minute ?? 0,
            second: givenComponents.second ?? 0
        ))
        
        XCTAssertEqual(givenDate, expectedDate, file: file, line: line)
    }
}
