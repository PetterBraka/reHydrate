//
//  Date+Extensions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 30/01/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
extension Date {
    func inSameDayAs(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }
}
