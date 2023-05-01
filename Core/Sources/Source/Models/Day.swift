//
//  Day.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import CoreInterfaceKit

public struct Day: DayProtocol {
    public let id: UUID
    public var consumption: Double
    public var goal: Double
    public let date: Date
    
    public init(id: UUID = UUID(),
                consumption: Double,
                goal: Double,
                date: Date) {
        self.id = id
        self.consumption = consumption
        self.goal = goal
        self.date = date
    }

    public func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.isDate(self.date, inSameDayAs: date)
    }
}

extension Day: Equatable {
    public static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.consumption == rhs.consumption &&
        lhs.goal == rhs.goal &&
        lhs.date == rhs.date
    }
}
