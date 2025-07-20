//
//  DrinkManager.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import Foundation
import LoggingKit
import DBKitInterface

public final actor DrinkManager {
    private let database: DatabaseType
    private let logger: LoggerServicing
    
    public init(database: DatabaseType, logger: LoggerServicing) {
        self.database = database
        self.logger = logger
    }
}

private extension DrinkManager {
    func fetchEntity(_ container: String) async throws -> DrinkModel {
        let predicate = #Predicate<DrinkModel> { $0.container == container }
        let drinks: [DrinkModel] = try await database.read(
            matching: predicate,
            sortBy: [SortDescriptor(\DrinkModel.size, order: .forward)],
            limit: 1)
        guard let drink = drinks.first else {
            throw DatabaseError.noElementFound
        }
        return drink
    }
    
    func fetchAllEntity() async throws -> [DrinkModel] {
        try await database.read(
            matching: nil,
            sortBy: [SortDescriptor(\DrinkModel.size, order: .forward)],
            limit: nil)
    }
}

extension DrinkManager: DrinkManagerType {
    public func createNewDrink(size: Double, container: String) async throws -> DrinkModel {
        let newDrink = DrinkModel(id: UUID().uuidString, size: size, container: container)
        await database.insert(newDrink)
        try await database.save()
        logger.log(category: .drinkDatabase, message: "Created drink \(newDrink)", error: nil, level: .debug)
        return newDrink
    }
    
    public func edit(size: Double, of container: String) async throws -> DrinkModel {
        let drink = try await fetchEntity(container)
        drink.size = size
        try await database.save()
        logger.log(category: .drinkDatabase, message: "Edited drink \(drink)", error: nil, level: .debug)
        return drink
    }
    
    public func delete(_ drink: DrinkModel) async throws {
        await database.delete(drink)
        try await database.save()
        logger.log(category: .drinkDatabase, message: "Deleted drink \(drink)", error: nil, level: .debug)
    }
    
    public func deleteDrink(container: String) async throws {
        let drink = try await fetchEntity(container)
        logger.log(category: .drinkDatabase, message: "Deleting \(drink)", error: nil, level: .debug)
        try await delete(drink)
    }
    
    public func deleteAll() async throws {
        let drinks = try await fetchAllEntity()
        logger.log(category: .drinkDatabase, message: "Deleting \(drinks)", error: nil, level: .debug)
        for drink in drinks {
            await database.delete(drink)
        }
        try await database.save()
    }
    
    public func fetch(_ container: String) async throws -> DrinkModel {
        let drink = try await fetchEntity(container)
        logger.log(category: .drinkDatabase, message: "Found drink \(drink)", error: nil, level: .debug)
        return drink
    }
    
    public func fetchAll() async throws -> [DrinkModel] {
        let drinks = try await fetchAllEntity()
        if drinks.isEmpty {
            throw DatabaseError.noElementFound
        }
        logger.log(category: .drinkDatabase, message: "Found \(drinks)", error: nil, level: .debug)
        return drinks
    }
}
