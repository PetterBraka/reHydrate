//
//  DateServiceTests.swift
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

// MARK: - getComponents tests
extension DateServiceTests {
    func test_getSeconds_small() {
        let seconds = sut.get(component: .second, from: .init(year: 2024, month: 2, day: 2, hours: 2, minutes: 2, seconds: 2))
        XCTAssertEqual(seconds, 2)
    }
    
    func test_getSeconds_large() {
        let seconds = sut.get(component: .second, from: .init(year: 2024, month: 2, day: 2, hours: 2, minutes: 2, seconds: 59))
        XCTAssertEqual(seconds, 59)
    }
    
    func test_getMinutes_small() {
        let minutes = sut.get(component: .minute, from: .init(year: 2024, month: 2, day: 2, hours: 2, minutes: 2, seconds: 2))
        XCTAssertEqual(minutes, 2)
    }
    
    func test_getMinutes_Large() {
        let minutes = sut.get(component: .minute, from: .init(year: 2024, month: 2, day: 2, hours: 2, minutes: 59, seconds: 2))
        XCTAssertEqual(minutes, 59)
    }
    
    func test_getHours_small() {
        let hours = sut.get(component: .hour, from: .init(year: 2024, month: 2, day: 2, hours: 2, minutes: 2, seconds: 2))
        XCTAssertEqual(hours, 2)
    }
    
    func test_getHours_Large() {
        let hours = sut.get(component: .hour, from: .init(year: 2024, month: 2, day: 2, hours: 23, minutes: 2, seconds: 2))
        XCTAssertEqual(hours, 23)
    }
}

// MARK: - getStart tests
extension DateServiceTests {
    func test_getStart_june_10_2018() {
        let date = sut.getStart(of: .june_10_2018_Sunday)
        
        assert(givenDate: date,
               expectedYear: 2018, expectedMonth: 6, expectedDay: 10,
               expectedHours: 0, expectedMinutes: 0, expectedSeconds: 0)
    }
    
    func test_getStart_february_1_2024() {
        let date = sut.getStart(of: .february_1_2024_Thursday)
        
        assert(givenDate: date,
               expectedYear: 2024, expectedMonth: 2, expectedDay: 1,
               expectedHours: 0, expectedMinutes: 0, expectedSeconds: 0)
    }
    
    func test_getStart_november_3_1966() {
        let date = sut.getStart(of: .november_3_1966_Thursday)
        
        assert(givenDate: date,
               expectedYear: 1966, expectedMonth: 11, expectedDay: 3,
               expectedHours: 0, expectedMinutes: 0, expectedSeconds: 0)
    }
    
    func test_getStart_march_7_1994() {
        let date = sut.getStart(of: .march_5_1970_Thursday)
        
        assert(givenDate: date,
               expectedYear: 1970, expectedMonth: 3, expectedDay: 5,
               expectedHours: 0, expectedMinutes: 0, expectedSeconds: 0)
    }
}

// MARK: - getEnd tests
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
        let days = sut.daysBetween(.init(year: 1998, month: 2, day: 2),
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
    func test_getDate_positive10_Seconds() {
        let date = sut.getDate(byAdding: 10, component: .second, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2024, expectedMonth: 1, expectedDay: 1,
               expectedHours: 0, expectedMinutes: 0, expectedSeconds: 10)
    }
    
    func test_getDate_positive120_Seconds() {
        let date = sut.getDate(byAdding: 120, component: .second, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2024, expectedMonth: 1, expectedDay: 1,
               expectedHours: 0, expectedMinutes: 2, expectedSeconds: 0)
    }
    
    func test_getDate_negative5_Seconds() {
        let date = sut.getDate(byAdding: -5, component: .second, to: .february_6_1994_Sunday)
        assert(givenDate: date, expectedYear: 1994, expectedMonth: 2, expectedDay: 5,
               expectedHours: 23, expectedMinutes: 59, expectedSeconds: 55)
    }
    
    func test_getDate_negative120_Seconds() {
        let date = sut.getDate(byAdding: -120, component: .second, to: .february_6_1994_Sunday)
        assert(givenDate: date, expectedYear: 1994, expectedMonth: 2, expectedDay: 5,
               expectedHours: 23, expectedMinutes: 58, expectedSeconds: 0)
    }
    
    func test_getDate_positive10_Minutes() {
        let date = sut.getDate(byAdding: 10, component: .minute, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2024, expectedMonth: 1, expectedDay: 1, expectedHours: 0, expectedMinutes: 10)
    }
    
    func test_getDate_positive120_Minutes() {
        let date = sut.getDate(byAdding: 120, component: .minute, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2024, expectedMonth: 1, expectedDay: 1, expectedHours: 2)
    }
    
    func test_getDate_negative5_Minutes() {
        let date = sut.getDate(byAdding: -5, component: .minute, to: .february_6_1994_Sunday)
        assert(givenDate: date, expectedYear: 1994, expectedMonth: 2, expectedDay: 5, expectedHours: 23, expectedMinutes: 55)
    }
    
    func test_getDate_negative120_Minutes() {
        let date = sut.getDate(byAdding: -120, component: .minute, to: .february_6_1994_Sunday)
        assert(givenDate: date, expectedYear: 1994, expectedMonth: 2, expectedDay: 5, expectedHours: 22)
    }
    
    func test_getDate_positive1_Hours() {
        let date = sut.getDate(byAdding: 1, component: .hour, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2024, expectedMonth: 1, expectedDay: 1, expectedHours: 1)
    }
    
    func test_getDate_positive10_Hours() {
        let date = sut.getDate(byAdding: 10, component: .hour, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2024, expectedMonth: 1, expectedDay: 1, expectedHours: 10)
    }
    
    func test_getDate_positive100_Hours() {
        let date = sut.getDate(byAdding: 100, component: .hour, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2024, expectedMonth: 1, expectedDay: 5, expectedHours: 4)
    }
    
    func test_getDate_negative2_Hours() {
        let date = sut.getDate(byAdding: -2, component: .hour, to: .february_6_1994_Sunday)
        assert(givenDate: date, expectedYear: 1994, expectedMonth: 2, expectedDay: 5, expectedHours: 22)
    }
    
    func test_getDate_negative12_Hours() {
        let date = sut.getDate(byAdding: -12, component: .hour, to: .february_6_1994_Sunday)
        assert(givenDate: date, expectedYear: 1994, expectedMonth: 2, expectedDay: 5, expectedHours: 12)
    }
    
    func test_getDate_positive10_days() {
        let date = sut.getDate(byAdding: 10, component: .day, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2024, expectedMonth: 1, expectedDay: 11)
    }
    
    func test_getDate_positive366_days() {
        let date = sut.getDate(byAdding: 366, component: .day, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2025, expectedMonth: 1, expectedDay: 1)
    }
    
    func test_getDate_positive730_days() {
        let date = sut.getDate(byAdding: 730, component: .day, to: .january_1_2024_Monday)
        assert(givenDate: date, expectedYear: 2025, expectedMonth: 12, expectedDay: 31)
    }
    
    func test_getDate_negative8_days() {
        let date = sut.getDate(byAdding: -8, component: .day, to: .february_6_1994_Sunday)
        assert(givenDate: date, expectedYear: 1994, expectedMonth: 1, expectedDay: 29)
    }
    
    func test_getDate_negative60_days() {
        let date = sut.getDate(byAdding: -60, component: .day, to: .february_6_1994_Sunday)
        assert(givenDate: date, expectedYear: 1993, expectedMonth: 12, expectedDay: 8)
    }
}

// MARK: - isDateInSameDayAs tests
extension DateServiceTests {
    func test_isDate_isSameDate() {
        let isSameDay = sut.isDate(.february_1_2024_Thursday,
                                   inSameDayAs: .february_1_2024_Thursday)
        XCTAssertEqual(isSameDay, true)
    }
    
    func test_isDate_isNotSameDateButDay() {
        let isSameDay = sut.isDate(.february_6_1994_Sunday,
                                   inSameDayAs: .init(year: 2024, month: 1, day: 6))
        XCTAssertEqual(isSameDay, false)
    }
    
    func test_isDate_isNotSameDateButMonthAndDay() {
        let isSameDay = sut.isDate(.february_6_1994_Sunday,
                                   inSameDayAs: .init(year: 2024, month: 2, day: 6))
        XCTAssertEqual(isSameDay, false)
    }
    
    func test_isDate_isNotSameDateButMonth() {
        let isSameDay = sut.isDate(.february_6_1994_Sunday,
                                   inSameDayAs: .init(year: 2024, month: 2, day: 1))
        XCTAssertEqual(isSameDay, false)
    }
    
    func test_isDate_isNotSameDateButYearAndMonth() {
        let isSameDay = sut.isDate(.february_6_1994_Sunday,
                                   inSameDayAs: .init(year: 1994, month: 2, day: 1))
        XCTAssertEqual(isSameDay, false)
    }
}

extension DateServiceTests {
    func assert(
        givenDate: Date,
        expectedYear year: Int, expectedMonth month: Int, expectedDay day: Int,
        expectedHours hours: Int = 0,
        expectedMinutes minutes: Int = 0,
        expectedSeconds seconds: Int = 0,
        file: StaticString = #file, line: UInt = #line
    ) {
        XCTAssertEqual(
            givenDate,
            Date(year: year, month: month, day: day,
                 hours: hours, minutes: minutes, seconds: seconds),
            file: file, line: line
        )
    }
}
