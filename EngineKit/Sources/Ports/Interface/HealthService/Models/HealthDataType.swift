//
//  HealthDataType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 25/11/2023.
//

public enum HealthDataType: Hashable {
    case water(HealthUnit)
    
    public var identifier: QuantityTypeIdentifier {
        switch self {
        case .water:
                .dietaryWater
        }
    }
    
    public var unit: HealthUnit {
        switch self {
        case let .water(unit):
            unit
        }
    }
}
