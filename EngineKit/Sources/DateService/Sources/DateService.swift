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
    
    let calendar = Calendar.current
    
    public init() {
        formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = .current
    }
    
    public func now() -> Date {
        Date()
    }
    
    public func daysBetween(_ start: Date, end: Date) -> Int {
        calendar.dateComponents([.day], from: start, to: end).day ?? 0
    }
    
    public func get(component: Component, from date: Date) -> Int {
        return switch component {
        case .second:
            calendar.component(.second, from: date)
        case .minute:
            calendar.component(.minute, from: date)
        case .hour:
            calendar.component(.hour, from: date)
        case .day:
            calendar.component(.day, from: date)
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
        return calendar.startOfDay(for: date)
    }
    
    public func getEnd(of date: Date) -> Date {
        let start = getStart(of: date)
        let dateWithHours = getDate(byAdding: 23, component: .hour, to: start)
        let dateWithMinutes = getDate(byAdding: 59, component: .minute, to: dateWithHours)
        return getDate(byAdding: 59, component: .second, to: dateWithMinutes)
    }
    
    public func isDate(_ date: Date, inSameDayAs: Date) -> Bool {
        formatter.string(from: date) == formatter.string(from: inSameDayAs)
    }
}
