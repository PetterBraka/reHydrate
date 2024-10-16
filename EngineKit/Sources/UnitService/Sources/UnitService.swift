//
//  UnitService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import Foundation
import LoggingService
import UnitServiceInterface
import UserPreferenceServiceInterface
import NotificationCenterServiceInterface

public final class UnitService: UnitServiceType {
    public typealias Engine = (
        HasUserPreferenceService &
        HasNotificationCenter &
        HasLoggerService
    )
    
    private let engine: Engine
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func set(unitSystem: UnitSystem) {
        do {
            try engine.userPreferenceService.set(unitSystem, for: .unit)
            engine.notificationCenter.post(name: .unitDidChange)
        } catch {
            engine.logger.log(category: .userPreferences, message: "Failed to set unit system to \(unitSystem.rawValue)", error: error, level: .error)
        }
    }
    
    public func getUnitSystem() -> UnitSystem {
        return engine.userPreferenceService.get(for: .unit) ?? .metric
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
