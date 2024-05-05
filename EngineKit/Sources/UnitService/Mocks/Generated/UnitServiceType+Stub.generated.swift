// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
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
