// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import UserPreferenceServiceInterface

public protocol UserPreferenceServiceTypeSpying {
    var variableLog: [UserPreferenceServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: UserPreferenceServiceTypeSpy.VariableName? { get }
    var methodLog: [UserPreferenceServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: UserPreferenceServiceTypeSpy.MethodCall? { get }
}

public final class UserPreferenceServiceTypeSpy: UserPreferenceServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case set(value: Any, key: String)
        case get(key: String)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private let realObject: UserPreferenceServiceType
    public init(realObject: UserPreferenceServiceType) {
        self.realObject = realObject
    }
}

extension UserPreferenceServiceTypeSpy: UserPreferenceServiceType {
    public func set<T: Codable>(_ value: T, for key: String) throws -> Void {
        methodLog.append(.set(value: value, key: key))
        try realObject.set(value, for: key)
    }
    public func get<T: Codable>(for key: String) -> T? {
        methodLog.append(.get(key: key))
        return realObject.get(for: key)
    }
}
