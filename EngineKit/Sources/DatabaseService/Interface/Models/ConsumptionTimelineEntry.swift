//
//  ConsumptionTimelineEntery.swift
//  
//
//  Created by Petter vang Brakalsvålet on 07/08/2023.
//

import Blackbird
import Foundation

public struct ConsumptionTimelineEntry: BlackbirdModel {
    @BlackbirdColumn public var id: String
    @BlackbirdColumn public var date: String
    @BlackbirdColumn public var time: String
    @BlackbirdColumn public var consumed: Double
    
    public init(id: String,
                date: String,
                time: String,
                consumed: Double) {
        self.id = id
        self.date = date
        self.consumed = consumed
        self.time = time
    }
}
