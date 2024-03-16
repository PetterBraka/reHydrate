// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import AppearanceServiceInterface

public protocol AppearanceServiceTypeSpying {
    var variableLog: [AppearanceServiceTypeSpy.VariableName] { get set }
    var methodLog: [AppearanceServiceTypeSpy.MethodName] { get set }
}

public final class AppearanceServiceTypeSpy: AppearanceServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
        case getAppearance
        case setAppearance
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
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
        methodLog.append(.setAppearance)
        realObject.setAppearance(appearance)
    }
}
