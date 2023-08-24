//
//  UserPreferenceService.swift
//
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import Foundation
import UserPreferenceServiceInterface

public final class UserPreferenceService: UserPreferenceServiceType {
    private let encoder: JSONEncoder = JSONEncoder()
    private let decoder: JSONDecoder = JSONDecoder()
    
    private let defaults: UserDefaults
    
    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    public func set<T: Codable>(_ value: T, for key: String) throws {
        let data = try encoder.encode(value)
        defaults.setValue(data, forKey: key)
    }
    
    public func get<T: Codable>(for key: String) -> T? {
        guard let data = defaults.data(forKey: key),
              let value = try? decoder.decode(T.self, from: data)
        else { return nil }
        return value
    }
}
