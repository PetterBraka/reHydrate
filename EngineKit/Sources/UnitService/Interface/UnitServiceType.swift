//
//  UnitServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

public protocol UnitServiceType {
    func convert(_ value: Double, from fromUnit: UnitModel.Imperial, to toUnit: UnitModel.Metric) -> Double
    func convert(_ value: Double, from fromUnit: UnitModel.Metric, to toUnit: UnitModel.Imperial) -> Double
    func convert(_ value: Double, from fromUnit: UnitModel.Imperial, to toUnit: UnitModel.Imperial) -> Double
    func convert(_ value: Double, from fromUnit: UnitModel.Metric, to toUnit: UnitModel.Metric) -> Double
}
