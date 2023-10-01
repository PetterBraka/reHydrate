//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 01/10/2023.
//

import UserNotifications

public extension UNNotificationTrigger {
    var date: Date? {
        if let calendarTrigger = self as? UNCalendarNotificationTrigger {
            var dateComponents = calendarTrigger.dateComponents
            if dateComponents.day == nil {
                dateComponents.setValue(1, for: .day)
            }
            if dateComponents.month == nil {
                dateComponents.setValue(1, for: .month)
            }
            if dateComponents.year == nil {
                dateComponents.setValue(2023, for: .year)
            }
            return Calendar.current.date(from: dateComponents)
        } else if let timeIntervalTrigger = self as? UNTimeIntervalNotificationTrigger {
            let currentDate = Date()
            return currentDate.addingTimeInterval(timeIntervalTrigger.timeInterval)
        } else {
            return nil
        }
    }
}
