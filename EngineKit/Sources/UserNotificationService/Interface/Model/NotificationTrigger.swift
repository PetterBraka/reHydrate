//
//  NotificationTrigger.swift
//
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//

import Foundation

public struct NotificationTrigger {
    public let repeats: Bool
    public let dateComponents: DateComponents
    
    public init(repeats: Bool, dateComponents: DateComponents) {
        self.repeats = repeats
        self.dateComponents = dateComponents
    }
}

public extension NotificationTrigger {
    var date: Date? {
        var dateComponents = dateComponents
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
    }
}
