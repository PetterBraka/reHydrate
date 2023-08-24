//
//  UnitServiceStub.swift
//  
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import UnitServiceInterface

public protocol UnitServiceStubbing {
    var convertImperialToImperial_returnValue: Double { get }
    var convertImperialToMetric_returnValue: Double { get }
    var convertMetricToImperial_returnValue: Double { get }
    var convertMetricToMetric_returnValue: Double { get }
}

public final class UnitServiceStub: UnitServiceStubbing {
    public var convertImperialToImperial_returnValue: Double = .default
    public var convertImperialToMetric_returnValue: Double = .default
    public var convertMetricToImperial_returnValue: Double = .default
    public var convertMetricToMetric_returnValue: Double = .default
    
    public init() {}
}

extension UnitServiceStub: UnitServiceType {
    public func convert(_ value: Double,
                       from fromUnit: UnitModel.Imperial,
                       to toUnit: UnitModel.Metric) -> Double {
        convertImperialToImperial_returnValue
    }
    
    public func convert(_ value: Double,
                       from fromUnit: UnitModel.Metric,
                       to toUnit: UnitModel.Imperial) -> Double {
        convertImperialToMetric_returnValue
    }
    
    public func convert(_ value: Double,
                       from fromUnit: UnitModel.Imperial,
                       to toUnit: UnitModel.Imperial) -> Double {
        convertMetricToImperial_returnValue
    }
    
    public func convert(_ value: Double,
                       from fromUnit: UnitModel.Metric,
                       to toUnit: UnitModel.Metric) -> Double {
        convertMetricToMetric_returnValue
    }
    
    
}
