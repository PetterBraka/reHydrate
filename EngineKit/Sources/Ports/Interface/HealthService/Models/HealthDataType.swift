//
//  HealthDataType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 25/11/2023.
//

public enum HealthDataType: CaseIterable {
    case water
    
    public var identifier: QuantityTypeIdentifier {
        switch self {
        case .water:
                .dietaryWater
        }
    }
}
