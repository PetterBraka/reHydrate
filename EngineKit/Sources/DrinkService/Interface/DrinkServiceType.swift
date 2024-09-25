//
//  DrinkServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation

public protocol DrinkServiceType {
    func add(size: Double, container: Container) async throws -> Drink
    func edit(size: Double, of drink: Container) async throws -> Drink
    func remove(container: Container) async throws
    func getSaved() async throws -> [Drink]
    func resetToDefault() async -> [Drink]
}
