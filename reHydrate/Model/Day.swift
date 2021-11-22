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
}

protocol DomainMappable {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
    func updateCoreDataModel(_ model: DomainModelType)
}
