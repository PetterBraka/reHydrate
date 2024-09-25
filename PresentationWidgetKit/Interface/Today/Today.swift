//
//  Today.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/09/2024.
//

import Foundation

public enum Today {
    public struct ViewModel {
        public let date: Date
        public let endOfDay: Date
        public let consumed: Double
        public let goal: Double
        public let symbol: String
        
        public init(date: Date, endOfDay: Date, consumed: Double, goal: Double, symbol: String) {
            self.date = date
            self.endOfDay = endOfDay
            self.consumed = consumed
            self.goal = goal
            self.symbol = symbol
        }
    }
}
