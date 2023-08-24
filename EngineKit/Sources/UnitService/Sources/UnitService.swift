//
//  UnitService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import Foundation
import UnitServiceInterface

public final class UnitService: UnitServiceType {
    public init() {}
    
    public func convert(_ value: Double,
                       from fromUnit: UnitModel.Imperial,
                       to toUnit: UnitModel.Metric) -> Double {
        let value = Measurement(value: value, unit: fromUnit.toUnitVolume())
        return value.converted(to: toUnit.toUnitVolume()).value
    }
    
    public func convert(_ value: Double,
                       from fromUnit: UnitModel.Metric,
                       to toUnit: UnitModel.Imperial) -> Double {
        let value = Measurement(value: value, unit: fromUnit.toUnitVolume())
        return value.converted(to: toUnit.toUnitVolume()).value
    }
    
    public func convert(_ value: Double,
                       from fromUnit: UnitModel.Imperial,
                       to toUnit: UnitModel.Imperial) -> Double {
        let value = Measurement(value: value, unit: fromUnit.toUnitVolume())
        return value.converted(to: toUnit.toUnitVolume()).value
    }
    
    public func convert(_ value: Double, 
                       from fromUnit: UnitModel.Metric,
                       to toUnit: UnitModel.Metric) -> Double {
        let value = Measurement(value: value, unit: fromUnit.toUnitVolume())
        return value.converted(to: toUnit.toUnitVolume()).value
    }
}

extension UnitModel.Imperial {
    func toUnitVolume() -> UnitVolume {
        switch self {
        case .ounces:
            return .imperialFluidOunces
        case .pint:
            return .imperialPints
        }
    }
}

extension UnitModel.Metric {
    func toUnitVolume() -> UnitVolume {
        switch self {
        case .millilitres:
            return .milliliters
        case .litres:
            return .liters
        }
    }
}
