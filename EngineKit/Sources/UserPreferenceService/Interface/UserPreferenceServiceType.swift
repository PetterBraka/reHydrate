//
//  UserPreferenceServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import Foundation

public protocol UserPreferenceServiceType {
    func set<T: Encodable>(_ value: T, for key: String) throws
    func get<T: Decodable>(for key: String) -> T?
}
