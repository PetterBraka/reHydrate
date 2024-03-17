//
//  Date+ext.swift
//  reHydrateTests
//
//  Created by Petter vang Brakalsvålet on 17/03/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

extension Date {
    init(
        year: Int, month: Int, day: Int,
        hours: Int = 0, minutes: Int = 0, seconds: Int = 0
    ) {
        let dateString = "\(day)-\(month)-\(year) \(hours):\(minutes):\(seconds) +0000"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        guard let date = formatter.date(from: dateString )
        else { fatalError("Invalid date - \(dateString)") }
        self = date
    }
}
