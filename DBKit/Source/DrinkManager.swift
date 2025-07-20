//
//  DrinkManager.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import SwiftData
import Foundation
import LoggingKit
import DBKitInterface

public final actor DrinkManager {
    private let context: ModelContext
    private let logger: LoggerServicing
    
    public init(container: ModelContainer, logger: LoggerServicing) {
        self.context = ModelContext(container)
        self.logger = logger
    }
}

private extension DrinkManager {
    func deleteEntity(_ entity: DrinkEntity) throws {
        context.delete(entity)
        try save()
    }
    
    func fetchEntity(_ container: String) async throws -> DrinkEntity {
        let predicate = #Predicate<DrinkEntity> { $0.container == container }
        let drinks: [DrinkEntity] = try read(
            matching: predicate,
            sortBy: [SortDescriptor(\DrinkEntity.size, order: .forward)],
            limit: 1)
        guard let drink = drinks.first else {
            throw DatabaseError.noElementFound
        }
        return drink
    }
    
    func fetchAllEntity() async throws -> [DrinkEntity] {
        try read(sortBy: [SortDescriptor(\DrinkEntity.size, order: .forward)])
    }
}

extension DrinkManager: DrinkManagerType {
    public func createNewDrink(size: Double, container: String) async throws -> DrinkModel {
        let newDrink = DrinkEntity(id: UUID().uuidString, size: size, container: container)
        context.insert(newDrink)
        try save()
        logger.log(category: .drinkDatabase, message: "Created \(newDrink)", error: nil, level: .debug)
        return newDrink.asModel
    }
    
    public func edit(size: Double, of container: String) async throws -> DrinkModel {
        let drink = try await fetchEntity(container)
        drink.size = size
        try save()
        logger.log(category: .drinkDatabase, message: "Updated \(drink)", error: nil, level: .debug)
        return drink.asModel
    }
    
    public func delete(_ drink: DrinkModel) async throws {
        let size = drink.size
        let container = drink.container
        let predicate = #Predicate<DrinkEntity> {
            $0.size == size && $0.container == container
        }
        let entities = try read(matching: predicate, limit: 1)
        guard let entity = entities.first else {
            throw DatabaseError.noElementFound
        }
        try deleteEntity(entity)
        logger.log(category: .drinkDatabase, message: "Deleted \(drink)", error: nil, level: .debug)
    }
    
    public func deleteDrink(container: String) async throws {
        let drink = try await fetchEntity(container)
        try deleteEntity(drink)
        logger.log(category: .drinkDatabase, message: "Deleted \(drink)", error: nil, level: .debug)
    }
    
    public func deleteAll() async throws {
        let drinks = try await fetchAllEntity()
        for drink in drinks {
            context.delete(drink)
        }
        try save()
        logger.log(category: .drinkDatabase, message: "Deleted \(drinks)", error: nil, level: .debug)
    }
    
    public func fetch(_ container: String) async throws -> DrinkModel {
        let drink = try await fetchEntity(container)
        logger.log(category: .drinkDatabase, message: "Found \(drink)", error: nil, level: .debug)
        return drink.asModel
    }
    
    public func fetchAll() async throws -> [DrinkModel] {
        let drinks = try await fetchAllEntity()
        if drinks.isEmpty {
            throw DatabaseError.noElementFound
        }
        logger.log(category: .drinkDatabase, message: "Found \(drinks)", error: nil, level: .debug)
        return drinks.map { $0.asModel }
    }
}

private extension DrinkManager {
    func read<Element: PersistentModel>(
        matching: Predicate<Element>? = nil,
        sortBy: [SortDescriptor<Element>] = [],
        limit: Int? = nil
    ) throws -> [Element] {
        let fetchDescriptor = FetchDescriptor<Element>(predicate: matching, sortBy: sortBy)
        var results = try context.fetch(fetchDescriptor)
        if let limit {
            results = Array(results.prefix(limit))
        }
        return results
    }
    
    func save() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            logger.log(category: .drinkDatabase, message: "Failed to save the context", error: error, level: .debug)
            throw error
        }
    }
}

