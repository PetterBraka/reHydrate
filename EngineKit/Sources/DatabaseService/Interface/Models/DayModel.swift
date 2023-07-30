//
//  DayModel.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Blackbird

public struct DayModel: BlackbirdModel {
    public static var primaryKey: [BlackbirdColumnKeyPath] = [\.$date]
    
    @BlackbirdColumn public var id: String
    @BlackbirdColumn public var date: String
    @BlackbirdColumn public var consumed: Double
    @BlackbirdColumn public var goal: Double
    
    public init(id: String, date: String, consumed: Double, goal: Double) {
        self.id = id
        self.date = date
        self.consumed = consumed
        self.goal = goal
    }
}
