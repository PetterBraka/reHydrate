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
    var sut: DateService!
    
    override func setUp() {
        sut = DateService()
    }
}
// MARK: - getEnd tests
extension DateServiceTests {
    func test_getEnd_june_10_2018() throws {
        let date = sut.getEnd(of: .june_10_2018_Sunday)
        
        try assert(givenDate: date,
                   expectedYear: 2018, expectedMonth: 6, expectedDay: 10,
                   expectedHours: 23, expectedMinutes: 59, expectedSeconds: 59)
    }
    
    func test_getEnd_february_1_2024() throws {
        let date = sut.getEnd(of: .february_1_2024_Thursday)
        
        try assert(givenDate: date,
               expectedYear: 2024, expectedMonth: 2, expectedDay: 1,
               expectedHours: 23, expectedMinutes: 59, expectedSeconds: 59)
    }
    
    func test_getEnd_november_3_1966() throws {
        let date = sut.getEnd(of: .november_3_1966_Thursday)
        
        try assert(givenDate: date,
               expectedYear: 1966, expectedMonth: 11, expectedDay: 3,
               expectedHours: 23, expectedMinutes: 59, expectedSeconds: 59)
    }
    
    func test_getEnd_march_7_1994() throws {
        let date = sut.getEnd(of: .march_5_1970_Thursday)
        
        try assert(givenDate: date,
                   expectedYear: 1970, expectedMonth: 3, expectedDay: 5,
                   expectedHours: 23, expectedMinutes: 59, expectedSeconds: 59)
    }
}

// MARK: - daysBetween tests
extension DateServiceTests {
    func test_daysBetween_january_10_2024() {
        let days = sut.daysBetween(.january_10_2024_Wednesday, end: .january_12_2024_Friday)
        XCTAssertEqual(days, 2)
    }
    
    func test_daysBetween_february_6_1994() {
        let days = sut.daysBetween(.february_6_1994_Sunday, end: .february_1_2024_Thursday)
        XCTAssertEqual(days, 10_952)
    }
    
    func test_daysBetween_february_2_1998() {
        let days = sut.daysBetween(.init(year: 1998, month: 2, day: 2)!,
                                   end: .february_1_2024_Thursday)
        XCTAssertEqual(days, 9_495)
    }
    
    func test_daysBetween_march_5_1970() {
        let days = sut.daysBetween(.march_5_1970_Thursday, end: .february_1_2024_Thursday)
        XCTAssertEqual(days, 19_691)
    }
    
    func test_daysBetween_november_3_1966() {
        let days = sut.daysBetween(.november_3_1966_Thursday, end: .february_1_2024_Thursday)
        XCTAssertEqual(days, 20_909)
    }
}

// MARK: - getDate tests
extension DateServiceTests {
    func test_getDate_possitive10() throws {
        let date = sut.getDate(byAddingDays: 10, to: .january_1_2024_Monday)
        try assert(givenDate: date, expectedYear: 2024, expectedMonth: 1, expectedDay: 11)
    }
    
    func test_getDate_possitive366() throws {
        let date = sut.getDate(byAddingDays: 366, to: .january_1_2024_Monday)
        try assert(givenDate: date, expectedYear: 2025, expectedMonth: 1, expectedDay: 1)
    }
    
    func test_getDate_possitive730() throws {
        let date = sut.getDate(byAddingDays: 730, to: .january_1_2024_Monday)
        try assert(givenDate: date, expectedYear: 2025, expectedMonth: 12, expectedDay: 31)
    }
    
    func test_getDate_negative8() throws {
        let date = sut.getDate(byAddingDays: -8, to: .february_6_1994_Sunday)
        try assert(givenDate: date, expectedYear: 1994, expectedMonth: 1, expectedDay: 29)
    }
    
    func test_getDate_negative60() throws {
        let date = sut.getDate(byAddingDays: -60, to: .february_6_1994_Sunday)
        try assert(givenDate: date, expectedYear: 1993, expectedMonth: 12, expectedDay: 8)
    }
}

extension DateServiceTests {
    func assert(
        givenDate: Date?,
        expectedYear year: Int, expectedMonth month: Int, expectedDay day: Int,
        expectedHours hours: Int = 0, 
        expectedMinutes minutes: Int = 0,
        expectedSeconds seconds: Int = 0,
        file: StaticString = #file, line: UInt = #line
    ) throws {
        try XCTAssertEqual(
            givenDate,
            XCTUnwrap(Date(year: year, month: month, day: day,
                           hours: hours, minutes: minutes, seconds: seconds),
                           file: file, line: line),
            file: file, line: line
        )
    }
}
