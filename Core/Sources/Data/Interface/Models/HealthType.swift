//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 23/04/2023.
//

import HealthKit

public enum HealthType: CaseIterable {
    case water

    public func toObjectType() -> HKObjectType {
        switch self {
        case .water:
            return .quantityType(forIdentifier: .dietaryWater)!
        }
    }

    public func toSampleType() -> HKQuantityType {
        switch self {
        case .water:
            return .quantityType(forIdentifier: .dietaryWater)!
        }
    }
}
