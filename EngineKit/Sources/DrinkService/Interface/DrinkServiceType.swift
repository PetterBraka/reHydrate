//
//  DrinkServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation

public protocol DrinkServiceType {
    func addDrink(size: Double, container: Container) async throws -> Drink
    func editDrink(editedDrink newDrink: Drink) async throws -> Drink
    func remove(container: String) async throws
    func getSavedDrinks() async throws -> [Drink]
    func resetToDefault() async -> [Drink]
}
