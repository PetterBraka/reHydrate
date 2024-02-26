//
//  UnitServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

public protocol UnitServiceType {
    func set(unitSystem: UnitSystem)
    func getUnitSystem() -> UnitSystem
    func convert(_ value: Double, from fromUnit: UnitModel, to toUnit: UnitModel) -> Double
}
