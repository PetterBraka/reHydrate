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
    public var setValueKey_returnValue: Error? = nil
    public var getKey_returnValue: (any Decodable)? = nil

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
