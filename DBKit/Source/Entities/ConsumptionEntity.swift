//
//  ConsumptionEntity.swift
//  DBKit
//
//  Created by Petter vang Brakalsvålet on 20/07/2025.
//

import SwiftData
import DBKitInterface

@Model
public final class ConsumptionEntity: Equatable {
    public var id: String
    public var date: String
    public var time: String
    public var consumed: Double
    
    public init(id: String,
                date: String,
                time: String,
                consumed: Double) {
        self.id = id
        self.date = date
        self.consumed = consumed
        self.time = time
    }
    
    public var asModel: ConsumptionModel {
        ConsumptionModel(id: id, date: date, time: time, consumed: consumed)
    }
}
