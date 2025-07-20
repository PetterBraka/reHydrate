//
//  DayEntity.swift
//  DBKit
//
//  Created by Petter vang Brakalsvålet on 20/07/2025.
//

import SwiftData
import DBKitInterface

@Model
public class DayEntity: Equatable {
    public var id: String
    public var date: String
    public var consumed: Double
    public var goal: Double
    
    public init(id: String, date: String,
                consumed: Double,
                goal: Double) {
        self.id = id
        self.date = date
        self.consumed = consumed
        self.goal = goal
    }
    
    public var asModel: DayModel {
        DayModel(id: id, date: date, consumed: consumed, goal: goal)
    }
}
