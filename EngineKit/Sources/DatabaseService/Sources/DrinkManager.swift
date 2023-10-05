//
//  DrinkManager.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import Foundation
import Blackbird
import DatabaseServiceInterface

public final class DrinkManager: DrinkManagerType {
    private let database: DatabaseType
    
    public init(database: DatabaseType) {
        self.database = database
    }
    
    public func createNewDrink(size: Double, container: String) async throws -> DrinkModel {
        let newDrink = DrinkModel(id: UUID().uuidString,
                                  size: size,
                                  container: container)
        try await database.write(newDrink)
        return newDrink
    }
    
    public func edit(size: Double, of container: String) async throws -> DrinkModel {
        var drink = try await fetch(container)
        drink.size = size
        try await database.write(drink)
        return drink
    }
    
    public func delete(_ drink: DrinkModel) async throws {
        try await database.delete(drink)
    }
    
    public func deleteDrink(container: String) async throws {
        try await database.delete(matching: .like(\DrinkModel.$container, container))
    }
    
    public func deleteAll() async throws {
        try await database.deleteAll(DrinkModel(id: "", size: 0, container: ""))
    }
    
    public func fetch(_ container: String) async throws -> DrinkModel {
        let drinks = try await database.read(matching: .like(\DrinkModel.$container, container),
                                             orderBy: .ascending(\.$size),
                                             limit: 1)
        guard let drink = drinks.first
        else {
            throw DatabaseError.noElementFound
        }
        return drink
    }
    
    public func fetchAll() async throws -> [DrinkModel] {
        let drinks = try await database.read(matching: nil,
                                             orderBy: .ascending(\DrinkModel.$size),
                                             limit: nil)
        return drinks
    }
}
