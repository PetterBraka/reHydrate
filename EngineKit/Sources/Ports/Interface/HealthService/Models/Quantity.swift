//
//  Quantity.swift
//
//
//  Created by Petter vang Brakalsvålet on 25/11/2023.
//

public struct Quantity {
    public let unit: HealthUnit
    public let value: Double
    
    public init(unit: HealthUnit, value: Double) {
        self.unit = unit
        self.value = value
    }
}
