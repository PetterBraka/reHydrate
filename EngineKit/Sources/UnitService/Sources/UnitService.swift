//
//  UnitService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import Foundation
import UnitServiceInterface
import UserPreferenceServiceInterface

public final class UnitService: UnitServiceType {
    public typealias Engine = (
        HasUserPreferenceService
    )
    
    private let engine: Engine
    
    private let preferenceKey = "UnitSystem"
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func set(unitSystem: UnitSystem) {
        try? engine.userPreferenceService.set(unitSystem, for: preferenceKey)
    }
    
    public func getUnitSystem() -> UnitSystem {
        engine.userPreferenceService.get(for: preferenceKey) ?? .metric
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

extension UnitSystem: Codable {}
