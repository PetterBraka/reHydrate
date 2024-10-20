// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

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
        case set(value: Any, key: PreferenceKey)
        case get(key: PreferenceKey)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: UserPreferenceServiceType
    public init(realObject: UserPreferenceServiceType) {
        self.realObject = realObject
    }
}

extension UserPreferenceServiceTypeSpy: UserPreferenceServiceType {
    public func set<T: Codable>(_ value: T, for key: PreferenceKey) throws -> Void {
        methodLog.append(.set(value: value, key: key))
        try realObject.set(value, for: key)
    }
    public func get<T: Codable>(for key: PreferenceKey) -> T? {
        methodLog.append(.get(key: key))
        return realObject.get(for: key)
    }
}
// MARK: - AutoString
// swiftlint:disable all



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
