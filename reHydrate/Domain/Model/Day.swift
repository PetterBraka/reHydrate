//
//  Day.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

struct Day {
    let id: UUID
    var consumption: Double
    var goal: Double
    let date: Date!

    func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.isDate(self.date, inSameDayAs: date)
    }
    
    func toLocal() -> (consumption: String, goal: String) {
        let converted = UnitConversionHelper.getLocal(self)
        return (converted.consumtion.clean, converted.goal.clean)
    }
}
