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
    var methodNameLog: [AppearanceServiceTypeSpy.MethodName] { get set }
}

public final class AppearanceServiceTypeSpy: AppearanceServiceTypeSpying {
    public enum VariableName: Equatable {
    }

    public enum MethodCall {
        case getAppearance
        case setAppearanceAppearance(appearance: Appearance)
    }

    public enum MethodName {
        case getAppearance
        case setAppearanceAppearance
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: AppearanceServiceType
    public init(realObject: AppearanceServiceType) {
        self.realObject = realObject
    }
}

extension AppearanceServiceTypeSpy: AppearanceServiceType {
    public func getAppearance() -> Appearance {
        methodNameLog.append(.getAppearance)
        methodLog.append(.getAppearance)
        return realObject.getAppearance()
    }
    public func setAppearance(_ appearance: Appearance) -> Void {
        methodNameLog.append(.setAppearanceAppearance)
        methodLog.append(.setAppearanceAppearance(appearance: appearance))
        realObject.setAppearance(appearance)
    }
}

extension AppearanceServiceTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension AppearanceServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .getAppearance: "getAppearance"
        case .setAppearanceAppearance(let appearance): "setAppearance(appearance: \(String(describing: appearance)))"
        }
    }
}

extension AppearanceServiceTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .getAppearance: "getAppearance"
        case .setAppearanceAppearance: "setAppearanceAppearance"
        }
    }
}

// MARK: - AutoString
// swiftlint:disable all

import AppearanceServiceInterface


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
