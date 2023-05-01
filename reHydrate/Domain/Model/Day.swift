//
//  Day.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import CoreInterfaceKit
import CoreKit

public struct Day: DayProtocol {
    public let id: UUID
    public var consumption: Double
    public var goal: Double
    public let date: Date
    
    private let settingsRepo: SettingsRepository = MainAssembler.resolve()

    func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.isDate(self.date, inSameDayAs: date)
    }

    func toLocal() -> (consumption: String, goal: String) {
        let converted = UnitConversionHelper.getLocal(self,
                                                      inMetric: settingsRepo.isMetric)
        return (converted.consumtion.clean, converted.goal.clean)
    }
}
