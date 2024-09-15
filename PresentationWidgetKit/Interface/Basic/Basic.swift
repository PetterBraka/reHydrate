//
//  Basic.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/09/2024.
//

import Foundation

public enum Basic {
    public struct ViewModel {
        public let date: Date
        public let consumed: Double
        public let goal: Double
        public let symbol: String
        
        public init(date: Date, consumed: Double, goal: Double, symbol: String) {
            self.date = date
            self.consumed = consumed
            self.goal = goal
            self.symbol = symbol
        }
    }
}
