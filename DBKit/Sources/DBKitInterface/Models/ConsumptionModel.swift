//
//  ConsumptionModel.swift
//  
//
//  Created by Petter vang Brakalsvålet on 07/08/2023.
//

public struct ConsumptionModel: Equatable {
    public let id: String
    public let date: String
    public let time: String
    public let consumed: Double
    
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
