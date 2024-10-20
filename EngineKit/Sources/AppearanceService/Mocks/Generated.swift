// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import AppearanceServiceInterface

public protocol AppearanceServiceTypeSpying {
    var variableLog: [AppearanceServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: AppearanceServiceTypeSpy.VariableName? { get }
    var methodLog: [AppearanceServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: AppearanceServiceTypeSpy.MethodCall? { get }
}

public final class AppearanceServiceTypeSpy: AppearanceServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case getAppearance
        case setAppearance(appearance: Appearance)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: AppearanceServiceType
    public init(realObject: AppearanceServiceType) {
        self.realObject = realObject
    }
}

extension AppearanceServiceTypeSpy: AppearanceServiceType {
    public func getAppearance() -> Appearance {
        methodLog.append(.getAppearance)
        return realObject.getAppearance()
    }
    public func setAppearance(_ appearance: Appearance) -> Void {
        methodLog.append(.setAppearance(appearance: appearance))
        realObject.setAppearance(appearance)
    }
}

// MARK: - AutoString
// swiftlint:disable all



// MARK: - AutoStub
// swiftlint:disable all  
import Foundation
import AppearanceServiceInterface

public protocol AppearanceServiceTypeStubbing {
    var getAppearance_returnValue: Appearance { get set }
}

public final class AppearanceServiceTypeStub: AppearanceServiceTypeStubbing {
    public var getAppearance_returnValue: Appearance {
        get {
            if getAppearance_returnValues.isEmpty {
                .default
            } else {
                getAppearance_returnValues.removeFirst()
            }
        }
        set {
            getAppearance_returnValues.append(newValue)
        }
    }
    private var getAppearance_returnValues: [Appearance] = []

    public init() {}
}

extension AppearanceServiceTypeStub: AppearanceServiceType {
    public func getAppearance() -> Appearance {
        getAppearance_returnValue
    }

    public func setAppearance(_ appearance: Appearance) -> Void {
    }

}
