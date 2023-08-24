//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import Foundation
import UserPreferenceServiceInterface

public protocol UserPreferenceServiceStubbing {
    var set_returnError: Error? { get }
    var get_returnValue: Decodable? { get }
}

public final class UserPreferenceServiceStub: UserPreferenceServiceStubbing {
    public var set_returnError: Error?
    public var get_returnValue: Decodable?
    
    public init() {}
}

extension UserPreferenceServiceStub: UserPreferenceServiceType {
    public func set<T>(_ value: T, for key: String) throws where T : Encodable {
        if let set_returnError {
            throw set_returnError
        }
    }
    
    public func get<T>(for key: String) -> T? where T : Decodable {
        return get_returnValue as? T
    }
}
