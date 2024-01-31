//
//  DayModel.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

public struct DayModel: Equatable {
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
}
