// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoEquatable
// swiftlint:disable all

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import UnitServiceInterface

public protocol UnitServiceTypeSpying {
    var variableLog: [UnitServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: UnitServiceTypeSpy.VariableName? { get }
    var methodLog: [UnitServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: UnitServiceTypeSpy.MethodCall? { get }
    var methodNameLog: [UnitServiceTypeSpy.MethodName] { get set }
}

public final class UnitServiceTypeSpy: UnitServiceTypeSpying {
    public enum VariableName: Equatable {
    }

    public enum MethodCall {
        case setUnitSystem(unitSystem: UnitSystem)
        case getUnitSystem
        case convertValueFromUnitToUnit(value: Double, fromUnit: UnitModel, toUnit: UnitModel)
    }

    public enum MethodName {
        case setUnitSystem
        case getUnitSystem
        case convertValueFromUnitToUnit
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: UnitServiceType
    public init(realObject: UnitServiceType) {
        self.realObject = realObject
    }
}

extension UnitServiceTypeSpy: UnitServiceType {
    public func set(unitSystem: UnitSystem) -> Void {
        methodNameLog.append(.setUnitSystem)
        methodLog.append(.setUnitSystem(unitSystem: unitSystem))
        realObject.set(unitSystem: unitSystem)
    }
    public func getUnitSystem() -> UnitSystem {
        methodNameLog.append(.getUnitSystem)
        methodLog.append(.getUnitSystem)
        return realObject.getUnitSystem()
    }
    public func convert(_ value: Double, from fromUnit: UnitModel, to toUnit: UnitModel) -> Double {
        methodNameLog.append(.convertValueFromUnitToUnit)
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
        case .setUnitSystem(let unitSystem): "set(unitSystem: \(String(describing: unitSystem)))"
        case .getUnitSystem: "getUnitSystem"
        case .convertValueFromUnitToUnit(let value, let fromUnit, let toUnit): "convert(value: \(String(describing: value)), fromUnit: \(String(describing: fromUnit)), toUnit: \(String(describing: toUnit)))"
        }
    }
}

extension UnitServiceTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .setUnitSystem: "setUnitSystem"
        case .getUnitSystem: "getUnitSystem"
        case .convertValueFromUnitToUnit: "convertValueFromUnitToUnit"
        }
    }
}

extension UnitServiceTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.setUnitSystem(let lhs_unitSystem), .setUnitSystem(let rhs_unitSystem)): lhs_unitSystem == rhs_unitSystem
        case (.getUnitSystem, .getUnitSystem): true
        case (.convertValueFromUnitToUnit(let lhs_value, let lhs_fromUnit, let lhs_toUnit), .convertValueFromUnitToUnit(let rhs_value, let rhs_fromUnit, let rhs_toUnit)): lhs_value == rhs_value && lhs_fromUnit == rhs_fromUnit && lhs_toUnit == rhs_toUnit
        default: false
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
