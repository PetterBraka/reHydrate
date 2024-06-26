//
//  Date+Ext.swift
//
//
//  Created by Petter vang Brakalsvålet on 23/03/2024.
//

import Foundation

public extension Date {
    static let february_6_1994_Sunday = Date(year: 1994, month: 2, day: 6, hours: 6)
    static let march_7_1994_Monday = Date(year: 1994, month: 3, day: 7, hours: 6)
    static let june_10_2018_Sunday = Date(year: 2018, month: 6, day: 10, hours: 6)
    static let december_8_2021_Wednesday = Date(year: 2021, month: 12, day: 8, hours: 6)
    
    static let march_5_1970_Thursday = Date(year: 1970, month: 3, day: 5, hours: 6)
    static let november_3_1966_Thursday = Date(year: 1966, month: 11, day: 3, hours: 6)
    
    static let may_2_1999_Sunday = Date(year: 1999, month: 5, day: 2, hours: 6)
    
    static let january_1_2023_Sunday = Date(year: 2023, month: 1, day: 1, hours: 6)
    static let january_1_2024_Monday = Date(year: 2024, month: 1, day: 1, hours: 6)
    static let january_9_2024_Tuesday = Date(year: 2024, month: 1, day: 9, hours: 6)
    static let january_10_2024_Wednesday = Date(year: 2024, month: 1, day: 10, hours: 6)
    static let january_12_2024_Friday = Date(year: 2024, month: 1, day: 12, hours: 6)
    static let january_13_2024_Saturday = Date(year: 2024, month: 1,  day: 13, hours: 6)
    static let january_14_2024_Sunday = Date(year: 2024, month: 1,  day: 14, hours: 6)
    static let february_1_2024_Thursday = Date(year: 2024,  month: 2, day: 1, hours: 6)
    
    init(
        year: Int, month: Int, day: Int,
        hours: Int = 0, minutes: Int = 0, seconds: Int = 0
    ) {
        let dateString = "\(year)-\(month)-\(day) " +
        "\(hours):\(minutes):\(seconds)"
        
        print("Expected date \(dateString)")
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_GB")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString )
        else { fatalError("Invalid date - \(dateString)") }
        print("Given date \(date)")
        self = date
    }
}
