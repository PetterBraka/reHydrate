//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 23/04/2023.
//

import Data
import DataInterface
import DomainInterface

extension DayModel: DomainMappable {
    public func toDomainModel() throws -> Day {
        guard let id, let date
        else {
            throw MappingError.proppertyWasNil
        }
        return Day(id: id,
            consumption: consumtion,
            goal: goal,
            date: date)
    }
    
    public func update(with item: Day) {
        id = item.id
        consumtion = item.consumption
        goal = item.goal
        date = item.date
    }
}
