//
//  Date+localized.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

extension Date {
    var localized: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd MMM"
        return formatter.string(from: self)
    }
}

extension Calendar {
    func endOfDay(for date: Date) -> Date? {
        self.date(bySettingHour: 23, minute: 59, second: 59, of: date)
    }
}
