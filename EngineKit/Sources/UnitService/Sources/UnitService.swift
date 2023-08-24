//
//  UnitService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import Foundation
import UnitServiceInterface

public final class UnitService: UnitServiceType {
    public typealias Engine = (
        AnyObject
    )
    
    private let engine: Engine
    
    private var currentUnitSystem: UnitSystem = .metric
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func set(unitSystem: UnitSystem) {
        // TODO: write to UserDefaults
        currentUnitSystem = unitSystem
    }
    
    public func getUnitSystem() -> UnitSystem {
        currentUnitSystem
    }
    
    public func convert(_ value: Double,
                       from fromUnit: UnitModel,
                       to toUnit: UnitModel) -> Double {
        let value = Measurement(value: value, unit: fromUnit.toUnitVolume())
        return value.converted(to: toUnit.toUnitVolume()).value
    }
}

extension UnitModel {
    func toUnitVolume() -> UnitVolume {
        switch self {
        case .ounces:
            return .imperialFluidOunces
        case .pint:
            return .imperialPints
        case .millilitres:
            return .milliliters
        case .litres:
            return .liters
        }
    }
}
