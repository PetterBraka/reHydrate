// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoEquatable
// swiftlint:disable all

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import UserPreferenceServiceInterface

public protocol UserPreferenceServiceTypeSpying {
    var variableLog: [UserPreferenceServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: UserPreferenceServiceTypeSpy.VariableName? { get }
    var methodLog: [UserPreferenceServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: UserPreferenceServiceTypeSpy.MethodCall? { get }
    var methodNameLog: [UserPreferenceServiceTypeSpy.MethodName] { get set }
}

public final class UserPreferenceServiceTypeSpy: UserPreferenceServiceTypeSpying {
    public enum VariableName: Equatable {
    }

    public enum MethodCall {
        case setValueKey(value: Any, key: PreferenceKey)
        case getKey(key: PreferenceKey)
    }

    public enum MethodName {
        case setValueKey
        case getKey
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: UserPreferenceServiceType
    public init(realObject: UserPreferenceServiceType) {
        self.realObject = realObject
    }
}

extension UserPreferenceServiceTypeSpy: UserPreferenceServiceType {
    public func set<T: Codable>(_ value: T, for key: PreferenceKey) throws -> Void {
        methodNameLog.append(.setValueKey)
        methodLog.append(.setValueKey(value: value, key: key))
        try realObject.set(value, for: key)
    }
    public func get<T: Codable>(for key: PreferenceKey) -> T? {
        methodNameLog.append(.getKey)
        methodLog.append(.getKey(key: key))
        return realObject.get(for: key)
    }
}

extension UserPreferenceServiceTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension UserPreferenceServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .setValueKey(let value, let key): "set(value: \(String(describing: value)), key: \(String(describing: key)))"
        case .getKey(let key): "get(key: \(String(describing: key)))"
        }
    }
}

extension UserPreferenceServiceTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .setValueKey: "setValueKey"
        case .getKey: "getKey"
        }
    }
}

extension UserPreferenceServiceTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.setValueKey(let lhs_value, let lhs_key), .setValueKey(let rhs_value, let rhs_key)): String(describing: lhs_value) == String(describing: rhs_value) && lhs_key == rhs_key
        case (.getKey(let lhs_key), .getKey(let rhs_key)): lhs_key == rhs_key
        default: false
        }
    }
}
// MARK: - AutoString
// swiftlint:disable all

import UserPreferenceServiceInterface


// MARK: - AutoStub
// swiftlint:disable all  
import Foundation
import UserPreferenceServiceInterface

public protocol UserPreferenceServiceTypeStubbing {
    var setValueKey_returnValue: Error? { get set }
    var getKey_returnValue: (any Decodable)? { get set }
}

public final class UserPreferenceServiceTypeStub: UserPreferenceServiceTypeStubbing {
    public var setValueKey_returnValue: Error? {
        get {
            if setValueKey_returnValues.isEmpty {
                nil
            } else {
                setValueKey_returnValues.removeFirst()
            }
        }
        set {
            setValueKey_returnValues.append(newValue)
        }
    }
    private var setValueKey_returnValues: [Error?] = []
    public var getKey_returnValue: (any Decodable)? {
        get {
            if getKey_returnValues.isEmpty {
                .default
            } else {
                getKey_returnValues.removeFirst()
            }
        }
        set {
            getKey_returnValues.append(newValue)
        }
    }
    private var getKey_returnValues: [(any Decodable)?] = []

    public init() {}
}

extension UserPreferenceServiceTypeStub: UserPreferenceServiceType {
    public func set<T: Codable>(_ value: T, for key: PreferenceKey) throws -> Void {
        if let setValueKey_returnValue {
            throw setValueKey_returnValue
        }
    }

    public func get<T: Codable>(for key: PreferenceKey) -> T? {
        getKey_returnValue as? T
    }

}
