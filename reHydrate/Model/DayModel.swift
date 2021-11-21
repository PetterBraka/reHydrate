//
//  DayModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import CoreData

extension DayModel: DomainMappable {
    func toDomainModel() -> Day {
        return Day(id: self.id ?? UUID(),
                   consumption: self.consumtion,
                   goal: self.goal,
                   date: self.date)
    }
    
    func updateCoreDataModel(_ day: Day) {
        self.id = day.id
        self.consumtion = day.consumption
        self.goal = day.goal
        self.date = day.date
    }
}
