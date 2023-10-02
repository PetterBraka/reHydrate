//
//  DrinkService.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import DrinkServiceInterface
import Foundation

public final class DrinkService: DrinkServiceType {
    private var db: [Drink] = []
    
    public init() {}
    
    public func addDrink(size: Double, container: Container) -> Drink {
        let newDrink = Drink(id: UUID(), size: size, container: container)
        db.append(newDrink)
        return newDrink
    }
    
    public func editDrink(editedDrink newDrink: Drink) throws -> Drink {
        if let index = db.firstIndex(where: { $0.id == newDrink.id }) {
            db[index] = newDrink
            return db[index]
        } else {
            throw DrinkDBError.itemNotFound
        }
    }
    
    public func removeDrink(withId id: UUID) throws {
        if let index = db.firstIndex(where: { $0.id == id }) {
            db.remove(at: index)
        } else {
            throw DrinkDBError.itemNotFound
        }
    }
    
    public func getSavedDrinks() -> [Drink] {
        db
    }
    
    public func resetToDefault() -> [Drink] {
        let defaultDrinks: [Drink] = [
            .init(id: UUID(), size: 300, container: .small),
            .init(id: UUID(), size: 500, container: .medium),
            .init(id: UUID(), size: 750, container: .large)
            
        ]
        db = defaultDrinks
        return defaultDrinks
    }
}
