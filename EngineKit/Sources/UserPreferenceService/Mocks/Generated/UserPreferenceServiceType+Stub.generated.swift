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
