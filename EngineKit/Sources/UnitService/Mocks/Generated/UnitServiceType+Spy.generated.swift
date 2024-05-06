// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

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
        case set(unitSystem: UnitSystem)
        case getUnitSystem
        case convert(value: Double, fromUnit: UnitModel, toUnit: UnitModel)
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
        methodLog.append(.set(unitSystem: unitSystem))
        realObject.set(unitSystem: unitSystem)
    }
    public func getUnitSystem() -> UnitSystem {
        methodLog.append(.getUnitSystem)
        return realObject.getUnitSystem()
    }
    public func convert(_ value: Double, from fromUnit: UnitModel, to toUnit: UnitModel) -> Double {
        methodLog.append(.convert(value: value, fromUnit: fromUnit, toUnit: toUnit))
        return realObject.convert(value, from: fromUnit, to: toUnit)
    }
}
