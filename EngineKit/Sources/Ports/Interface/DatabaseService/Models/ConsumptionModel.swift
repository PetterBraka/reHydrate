//
//  ConsumptionTimelineEntery.swift
//  
//
//  Created by Petter vang Brakalsvålet on 07/08/2023.
//

public struct ConsumptionModel: Equatable {
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
}
