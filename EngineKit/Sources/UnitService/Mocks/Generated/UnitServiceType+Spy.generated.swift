// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import UnitServiceInterface

public protocol UnitServiceTypeSpying {
    var variableLog: [UnitServiceTypeSpy.VariableName] { get set }
    var methodLog: [UnitServiceTypeSpy.MethodName] { get set }
}

public final class UnitServiceTypeSpy: UnitServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
            case set_unitSystem
            case getUnitSystem
            case convert_from_to
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: UnitServiceType
    public init(realObject: UnitServiceType) {
        self.realObject = realObject
    }
}

extension UnitServiceTypeSpy: UnitServiceType {
    public func set(unitSystem: UnitSystem) -> Void {
        methodLog.append(.set_unitSystem)
        realObject.set(unitSystem: unitSystem)
    }
    public func getUnitSystem() -> UnitSystem {
        methodLog.append(.getUnitSystem)
        return realObject.getUnitSystem()
    }
    public func convert(_ value: Double, from fromUnit: UnitModel, to toUnit: UnitModel) -> Double {
        methodLog.append(.convert_from_to)
        return realObject.convert(value, from: fromUnit, to: toUnit)
    }
}
