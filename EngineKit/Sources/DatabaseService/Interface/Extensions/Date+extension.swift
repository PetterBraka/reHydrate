//
//  Date+extension.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Foundation

public let dbDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter
}()

public let dbTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    formatter.timeZone = .gmt
    return formatter
}()

private let dbToDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    guard let dateFormat = dbDateFormatter.dateFormat,
          let timeFormate = dbTimeFormatter.dateFormat
    else {
        fatalError("Date or time formatter hasn't been set correctly!")
    }
    formatter.dateFormat = "\(dateFormat) \(timeFormate)"
    formatter.timeZone = .gmt
    return formatter
}()

public extension Date {
    func toDateString() -> String {
        dbDateFormatter.string(from: self)
    }
    
    func toTimeString() -> String {
        dbTimeFormatter.string(from: self)
    }
    
    func inSameDayAs(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    init?(date: String, time: String) {
        let dateAndTime = "\(date) \(time)"
        guard let date = dbToDateFormatter.date(from: dateAndTime)
        else { return nil }
        self = date
    }
}
