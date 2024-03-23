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
    private let minuteInSeconds: TimeInterval = 60
    private let hourInSeconds: TimeInterval = 60 * 60
    private let dayInSeconds: TimeInterval = 24 * 60 * 60
    
    public init() {
        formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
    }
    
    public func now() -> Date {
        Date()
    }
    
    public func daysBetween(_ start: Date, end: Date) -> Int {
        let timeSince = end.timeIntervalSince(start)
        return Int(timeSince) / Int(dayInSeconds)
    }
    
    public func get(component: Component, from date: Date) -> Int {
        let timeInterval = date.timeIntervalSinceReferenceDate
        switch component {
        case .second:
            return Int(timeInterval.truncatingRemainder(dividingBy: minuteInSeconds))
        case .minute:
            return Int((timeInterval / minuteInSeconds).truncatingRemainder(dividingBy: 60))
        case .hour:
            return Int((timeInterval / hourInSeconds).truncatingRemainder(dividingBy: 24))
        case .day:
            assertionFailure("Can't accurately calculate the days")
            return 0
        }
    }
    
    public func getDate(byAdding value: Int, component: Component, to date: Date) -> Date {
        let value = TimeInterval(value)
        return switch component {
        case .second:
            date.addingTimeInterval(value)
        case .minute:
            date.addingTimeInterval(value * minuteInSeconds)
        case .hour:
            date.addingTimeInterval(value * hourInSeconds)
        case .day:
            date.addingTimeInterval(value * dayInSeconds)
        }
    }
    
    public func getStart(of date: Date) -> Date {
        let truncatingRemainder = date.timeIntervalSince1970.truncatingRemainder(dividingBy: dayInSeconds)
        let timeInterval = date.timeIntervalSince1970 - truncatingRemainder
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    public func getEnd(of date: Date) -> Date {
        let timeInterval = date.timeIntervalSince1970
        
        let secondsUntilEndOfDay: TimeInterval = (dayInSeconds - timeInterval.truncatingRemainder(dividingBy: dayInSeconds))
        
        return Date(timeIntervalSince1970: timeInterval + secondsUntilEndOfDay - 1)
    }
    
    public func isDate(_ date: Date, inSameDayAs: Date) -> Bool {
        formatter.string(from: date) == formatter.string(from: inSameDayAs)
    }
}
