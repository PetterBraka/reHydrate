//
//  DrinkServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation

public protocol DrinkServiceType {
    func addDrink(size: Double, container: Container) throws -> Drink
    func editDrink(editedDrink newDrink: Drink) throws -> Drink
    func removeDrink(withId id: UUID) throws
    func getSavedDrinks() throws -> [Drink]
    func resetToDefault() -> [Drink]
}
