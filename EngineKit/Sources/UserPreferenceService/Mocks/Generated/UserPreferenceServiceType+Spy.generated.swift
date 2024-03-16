// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import UserPreferenceServiceInterface

public protocol UserPreferenceServiceTypeSpying {
    var variableLog: [UserPreferenceServiceTypeSpy.VariableName] { get set }
    var methodLog: [UserPreferenceServiceTypeSpy.MethodName] { get set }
}

public final class UserPreferenceServiceTypeSpy: UserPreferenceServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
        case set_for
        case get_for
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: UserPreferenceServiceType
    public init(realObject: UserPreferenceServiceType) {
        self.realObject = realObject
    }
}

extension UserPreferenceServiceTypeSpy: UserPreferenceServiceType {
    public func set<T: Codable>(_ value: T, for key: String) throws -> Void {
        methodLog.append(.set_for)
        try realObject.set(value, for: key)
    }
    public func get<T: Codable>(for key: String) -> T? {
        methodLog.append(.get_for)
        return realObject.get(for: key)
    }
}
