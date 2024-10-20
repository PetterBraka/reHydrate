//
//  DayModel.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

public struct DayModel: Equatable, Sendable {
    public let id: String
    public let date: String
    public let consumed: Double
    public let goal: Double
    
    public init(id: String, date: String,
                consumed: Double,
                goal: Double) {
        self.id = id
        self.date = date
        self.consumed = consumed
        self.goal = goal
    }
}
