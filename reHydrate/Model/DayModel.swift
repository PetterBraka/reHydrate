//
//  DayModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import Foundation

extension DayModel: DomainMappable {
    func toDomainModel() -> Day {
        Day(id: id ?? UUID(),
            consumption: consumtion,
            goal: goal,
            date: date)
    }

    func updateCoreDataModel(_ day: Day) {
        id = day.id
        consumtion = day.consumption
        goal = day.goal
        date = day.date
    }
}
