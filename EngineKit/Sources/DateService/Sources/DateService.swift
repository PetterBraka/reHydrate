//
//  DateService.swift
//
//
//  Created by Petter vang Brakalsvålet on 28/01/2024.
//

import Foundation
import DateServiceInterface

public final class DateService: DateServiceType {
    private let calendar: Calendar
    
    public init(calendar: Calendar) {
        self.calendar = calendar
    }
    
    public func daysBetween(_ start: Date, end: Date) -> Int {
        calendar.dateComponents([.day], from: start, to: end).day ?? 0
    }
    
    public func getDate(byAddingDays days: Int, to date: Date) -> Date? {
        calendar.date(byAdding: .day, value: days, to: date)
    }
    
    public func getEnd(of date: Date) -> Date? {
        calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)
    }
    
    public func isDate(_ date: Date, inSameDayAs: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: inSameDayAs)
    }
}
