//
//  DrinkServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation

public protocol DrinkServiceType {
    func add(size: Double, container: Container) async throws -> Drink
    func edit(size: Double, of drink: Drink) async throws -> Drink
    func remove(container: String) async throws
    func getSaved() async throws -> [Drink]
    func resetToDefault() async -> [Drink]
}
