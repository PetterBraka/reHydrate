//
//  UnitServiceStub.swift
//  
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import UnitServiceInterface

public protocol UnitServiceStubbing {
    var currentUnitSystem_returnValue: UnitSystem { get }
    var convert_returnValue: Double { get }
}

public final class UnitServiceStub: UnitServiceStubbing {
    public var currentUnitSystem_returnValue: UnitSystem = .default
    public var convert_returnValue: Double = .default
    
    public init() {}
}

extension UnitServiceStub: UnitServiceType {
    public func set(unitSystem: UnitSystem) {
        currentUnitSystem_returnValue = unitSystem
    }
    
    public func getUnitSystem() -> UnitSystem {
        currentUnitSystem_returnValue
    }
    
    public func convert(_ value: Double, from fromUnit: UnitModel, to toUnit: UnitModel) -> Double {
        convert_returnValue
    }
}
