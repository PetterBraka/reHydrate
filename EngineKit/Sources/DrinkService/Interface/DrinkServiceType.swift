//
//  DrinkServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation

public protocol DrinkServiceType {
    func addDrink(size: Double, container: Container) -> Result<Drink, DrinkDBError>
    func editDrink(editedDrink newDrink: Drink) -> Result<Drink, DrinkDBError>
    func removeDrink(withId id: UUID) -> Result<Void, DrinkDBError>
    func getSavedDrinks() -> Result<[Drink], DrinkDBError>
    func resetToDefault() -> [Drink]
}
