// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import UnitServiceInterface

public protocol UnitServiceTypeSpying {
    var variableLog: [UnitServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: UnitServiceTypeSpy.VariableName? { get }
    var methodLog: [UnitServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: UnitServiceTypeSpy.MethodCall? { get }
}

public final class UnitServiceTypeSpy: UnitServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case setUnitSystem(unitSystem: UnitSystem)
        case getUnitSystem
        case convertValueFromUnitToUnit(value: Double, fromUnit: UnitModel, toUnit: UnitModel)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: UnitServiceType
    public init(realObject: UnitServiceType) {
        self.realObject = realObject
    }
}

extension UnitServiceTypeSpy: UnitServiceType {
    public func set(unitSystem: UnitSystem) -> Void {
        methodLog.append(.setUnitSystem(unitSystem: unitSystem))
        realObject.set(unitSystem: unitSystem)
    }
    public func getUnitSystem() -> UnitSystem {
        methodLog.append(.getUnitSystem)
        return realObject.getUnitSystem()
    }
    public func convert(_ value: Double, from fromUnit: UnitModel, to toUnit: UnitModel) -> Double {
        methodLog.append(.convertValueFromUnitToUnit(value: value, fromUnit: fromUnit, toUnit: toUnit))
        return realObject.convert(value, from: fromUnit, to: toUnit)
    }
}

extension UnitServiceTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension UnitServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .setUnitSystem(let unitSystem): "set(\(String(describing: unitSystem)))"
        case .getUnitSystem: "getUnitSystem"
        case .convertValueFromUnitToUnit(let value, let fromUnit, let toUnit): "convert(\(String(describing: value)), \(String(describing: fromUnit)), \(String(describing: toUnit)))"
        }
    }
}
// MARK: - AutoString
// swiftlint:disable all

import UnitServiceInterface

extension UnitModel: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ounces: "ounces"
        case .pint: "pint"
        case .litres: "litres"
        case .millilitres: "millilitres"
        }
    }
}

extension UnitSystem: CustomStringConvertible {
    public var description: String {
        switch self {
        case .imperial: "imperial"
        case .metric: "metric"
        }
    }
}

// MARK: - AutoStub
// swiftlint:disable all  
import Foundation
import UnitServiceInterface

public protocol UnitServiceTypeStubbing {
    var getUnitSystem_returnValue: UnitSystem { get set }
    var convertValueFromUnitToUnit_returnValue: Double { get set }
}

public final class UnitServiceTypeStub: UnitServiceTypeStubbing {
    public var getUnitSystem_returnValue: UnitSystem {
        get {
            if getUnitSystem_returnValues.isEmpty {
                .default
            } else {
                getUnitSystem_returnValues.removeFirst()
            }
        }
        set {
            getUnitSystem_returnValues.append(newValue)
        }
    }
    private var getUnitSystem_returnValues: [UnitSystem] = []
    public var convertValueFromUnitToUnit_returnValue: Double {
        get {
            if convertValueFromUnitToUnit_returnValues.isEmpty {
                .default
            } else {
                convertValueFromUnitToUnit_returnValues.removeFirst()
            }
        }
        set {
            convertValueFromUnitToUnit_returnValues.append(newValue)
        }
    }
    private var convertValueFromUnitToUnit_returnValues: [Double] = []

    public init() {}
}

extension UnitServiceTypeStub: UnitServiceType {
    public func set(unitSystem: UnitSystem) -> Void {
    }

    public func getUnitSystem() -> UnitSystem {
        getUnitSystem_returnValue
    }

    public func convert(_ value: Double, from fromUnit: UnitModel, to toUnit: UnitModel) -> Double {
        convertValueFromUnitToUnit_returnValue
    }

}
