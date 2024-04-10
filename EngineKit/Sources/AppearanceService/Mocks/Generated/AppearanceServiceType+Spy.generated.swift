// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import AppearanceServiceInterface

public protocol AppearanceServiceTypeSpying {
    var variableLog: [AppearanceServiceTypeSpy.VariableName] { get set }
    var lastvariabelCall: AppearanceServiceTypeSpy.VariableName? { get }
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
    public var lastvariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private let realObject: AppearanceServiceType
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
