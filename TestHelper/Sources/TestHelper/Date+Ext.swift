//
//  Date+Ext.swift
//
//
//  Created by Petter vang Brakalsvålet on 23/03/2024.
//

import Foundation

public extension Date {
    static let february_6_1994_Sunday = Date(year: 1994, month: 2, day: 6)
    static let march_7_1994_Monday = Date(year: 1994, month: 3, day: 7)
    static let june_10_2018_Sunday = Date(year: 2018, month: 6, day: 10)
    static let december_8_2021_Wednesday = Date(year: 2021, month: 12, day: 8)
    
    static let march_5_1970_Thursday = Date(year: 1970, month: 3, day: 5)
    static let november_3_1966_Thursday = Date(year: 1966, month: 11, day: 3)
    
    static let may_2_1999_Sunday = Date(year: 1999, month: 5, day: 2)
    
    static let january_1_2023_Sunday = Date(year: 2023, month: 1, day: 1)
    static let january_1_2024_Monday = Date(year: 2024, month: 1, day: 1)
    static let january_9_2024_Tuesday = Date(year: 2024, month: 1, day: 9)
    static let january_10_2024_Wednesday = Date(year: 2024, month: 1, day: 10)
    static let january_12_2024_Friday = Date(year: 2024, month: 1, day: 12)
    static let january_13_2024_Saturday = Date(year: 2024, month: 1, day: 13)
    static let january_14_2024_Sunday = Date(year: 2024, month: 1, day: 14)
    static let february_1_2024_Thursday = Date(year: 2024, month: 2, day: 1)
    
    init(
        year: Int, month: Int, day: Int,
        hours: Int = 0, minutes: Int = 0, seconds: Int = 0
    ) {
        let dateString = "\(day)-\(month)-\(year) \(hours):\(minutes):\(seconds) +0000"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        guard let date = formatter.date(from: dateString )
        else { fatalError("Invalid date - \(dateString)") }
        self = date
    }
}
