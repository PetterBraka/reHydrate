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
    
    public func getEnd(of date: Date) -> Date? {
        calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)
    }
}
