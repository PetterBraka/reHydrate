//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation

public struct Day {
    public let id: UUID
    public let date: Date
    public var consumed: Double
    public var goal: Double
    
    public init(id: UUID = UUID(),
                date: Date,
                consumed: Double,
                goal: Double) {
        self.id = id
        self.date = date
        self.consumed = consumed
        self.goal = goal
    }
}
