//
//  DayModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import Foundation
import CoreInterfaceKit

extension DayModel: DomainMappable {
    public func toDomainModel() -> Day {
        Day(id: id ?? UUID(),
            consumption: consumtion,
            goal: goal,
            date: date ?? .now)
    }
    
    public func update(with item: Day) {
        id = item.id
        consumtion = item.consumption
        goal = item.goal
        date = item.date
    }
}
