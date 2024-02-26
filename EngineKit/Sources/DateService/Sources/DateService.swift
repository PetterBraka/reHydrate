//
//  DateService.swift
//
//
//  Created by Petter vang Brakalsvålet on 28/01/2024.
//

import Foundation
import DateServiceInterface

public final class DateService: DateServiceType {
    private let formatter: DateFormatter
    private let dayInSeconds: Int = 24 * 60 * 60
    
    public init() {
        formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
    }
    
    public func daysBetween(_ start: Date, end: Date) -> Int {
        let timeSince = end.timeIntervalSince(start)
        return Int(timeSince) / dayInSeconds
    }
    
    public func getDate(byAddingDays days: Int, to date: Date) -> Date {
        date.addingTimeInterval(TimeInterval(days * dayInSeconds))
    }
    
    public func getEnd(of date: Date) -> Date? {
        let timeInterval = date.timeIntervalSince1970
        
        let secondsUntilEndOfDay = (dayInSeconds - Int(timeInterval) % dayInSeconds) - 1
        
        return Date(timeIntervalSince1970: timeInterval + Double(secondsUntilEndOfDay))
    }
    
    public func isDate(_ date: Date, inSameDayAs: Date) -> Bool {
        formatter.string(from: date) == formatter.string(from: inSameDayAs)
    }
}
