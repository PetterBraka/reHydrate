//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import XCTest

public extension XCTest {
    static let referenceDate = Date(timeIntervalSince1970: 1688227143)
    /// [1/07/2023, 2/07/2023, 3/07/2023, 5/07/2023]
    static let referenceDates = [
        Date(timeIntervalSince1970: 1688227143),
        Date(timeIntervalSince1970: 1688324062),
        Date(timeIntervalSince1970: 1688410462),
        Date(timeIntervalSince1970: 1688583262)
    ]
}

public extension Date {
    static let february_6_1994_Sunday = Date(timeIntervalSince1970: 760492800)
    static let march_5_1970_Thursday = Date(timeIntervalSince1970: 5443200)
    static let march_7_1994_Monday = Date(timeIntervalSince1970: 762998400)
    static let may_2_1999_Sunday = Date(timeIntervalSince1970: 925603200)
    static let june_10_2018_Sunday = Date(timeIntervalSince1970: 1528588800)
    static let november_3_1966_Thursday = Date(timeIntervalSince1970: -99792000)
    static let december_8_2021_Wednesday = Date(timeIntervalSince1970: 1638921600)
    
    static let january_1_2023_Sunday = Date(timeIntervalSince1970: 1672531200)
    static let january_1_2024_Monday = Date(timeIntervalSince1970: 1704067200)
    static let january_9_2024_Tuesday = Date(timeIntervalSince1970: 1704758400)
    static let january_10_2024_Wednesday = Date(timeIntervalSince1970: 1704844800)
    static let january_12_2024_Friday = Date(timeIntervalSince1970: 1705017600)
    static let january_13_2024_Saturday = Date(timeIntervalSince1970: 1705104000)
    static let january_14_2024_Sunday = Date(timeIntervalSince1970: 1705190400)
    static let february_1_2024_Thursday = Date(timeIntervalSince1970: 1706745600)
    
    init(
        year: Int, month: Int, day: Int,
        calendar: Calendar = .init(identifier: .gregorian),
        file: StaticString = #file, line: UInt = #line
    ) throws {
        let components = DateComponents(
            calendar: calendar, timeZone: .gmt,
            year: year, month: month, day: day,
            hour: 07, minute: 30
        )
        self = try XCTUnwrap(
            calendar.date(from: components),
            file: file, line: line
        )
    }
}
