// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import UserPreferenceServiceInterface

public protocol UserPreferenceServiceTypeStubbing {
    var setValueKey_returnValue: Error? { get set }
    var getKey_returnValue: (any Decodable)? { get set }
}

public final class UserPreferenceServiceTypeStub: UserPreferenceServiceTypeStubbing {
    public var setValueKey_returnValue: Error? {
        get {
            if setValueKey_returnValues.count > 0 {
                let value = setValueKey_returnValues.removeFirst()
                if setValueKey_returnValues.isEmpty {
                    setValueKey_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return setValueKey_returnValues.first ?? nil
            }
        }
        set {
            setValueKey_returnValues.append(newValue)
        }
    }
    private var setValueKey_returnValues: [Error?] = []
    public var getKey_returnValue: (any Decodable)? {
        get {
            if getKey_returnValues.count > 0 {
                let value = getKey_returnValues.removeFirst()
                if getKey_returnValues.isEmpty {
                    getKey_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return getKey_returnValues.first ?? nil
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
    public func set<T: Codable>(_ value: T, for key: String) throws -> Void {
        if let setValueKey_returnValue {
            throw setValueKey_returnValue
        }
    }

    public func get<T: Codable>(for key: String) -> T? {
        getKey_returnValue as? T
    }

}
