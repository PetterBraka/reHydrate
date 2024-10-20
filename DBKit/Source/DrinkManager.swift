//
//  DrinkManager.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import Foundation
import CoreData
import LoggingKit
import DBKitInterface

public final actor DrinkManager {
    private let database: DatabaseType
    private let logger: LoggerServicing
    
    public init(database: DatabaseType, logger: LoggerServicing) {
        self.database = database
        self.logger = logger
    }
    
    public func run<T>(
        resultType: T.Type = T.self,
        body: @MainActor @Sendable () throws -> T
    ) async rethrows -> T where T : Sendable {
        try await body()
    }
}

private extension DrinkManager {
    func fetchEntity(_ container: String) async throws -> DrinkEntity {
        let context = await database.open()
        let drinks: [DrinkEntity] = try await database.read(
            matching: .init(format: "container == %@", container),
            sortBy: [NSSortDescriptor(key: "amount", ascending: true)],
            limit: 1,
            context)
        guard let drink = drinks.first
        else {
            throw DatabaseError.noElementFound
        }
        return drink
    }
    
    func fetchAllEntity() async throws -> [DrinkEntity] {
        let context = await database.open()
        let drinks: [DrinkEntity] = try await database.read(
            matching: nil,
            sortBy: [NSSortDescriptor(key: "amount", ascending: true)],
            limit: nil,
            context)
        return drinks
    }
}

extension DrinkManager: DrinkManagerType {
    public func createNewDrink(size: Double, container: String) async throws -> DrinkModel {
        let context = await database.open()
        let newDrink = DrinkEntity(context: context)
        newDrink.id = UUID().uuidString
        newDrink.amount = size
        newDrink.container = container
        try await database.save(context)
        logger.log(category: .drinkDatabase, message: "Created drink \(newDrink)", error: nil, level: .debug)
        return DrinkModel(from: newDrink)
    }
    
    public func edit(size: Double, of container: String) async throws -> DrinkModel {
        let context = await database.open()
        let drink = try await fetchEntity(container)
        drink.amount = size
        try await database.save(context)
        logger.log(category: .drinkDatabase, message: "Edited drink \(drink)", error: nil, level: .debug)
        return DrinkModel(from: drink)
    }
    
    private func delete(_ drink: DrinkEntity) async throws {
        let context = await database.open()
        context.delete(drink)
        try await database.save(context)
        logger.log(category: .drinkDatabase, message: "Deleted drink \(drink)", error: nil, level: .debug)
    }
    
    public func delete(_ drink: DrinkModel) async throws {
        let context = await database.open()
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "container == %@", drink.container),
            NSPredicate(format: "amount == %f", drink.size)
        ])
        let drinks: [DrinkEntity] = try await database.read(
            matching: predicate,
            sortBy: nil,
            limit: 1,
            context
        )
        logger.log(category: .drinkDatabase, message: "Deleting \(drinks)", error: nil, level: .debug)
        for drink in drinks {
            try await delete(drink)
        }
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
            try await delete(drink)
        }
    }
    
    public func fetch(_ container: String) async throws -> DrinkModel {
        let drink = try await fetchEntity(container)
        logger.log(category: .drinkDatabase, message: "Found drink \(drink)", error: nil, level: .debug)
        return DrinkModel(from: drink)
    }
    
    public func fetchAll() async throws -> [DrinkModel] {
        let drinks = try await fetchAllEntity()
        logger.log(category: .drinkDatabase, message: "Found \(drinks)", error: nil, level: .debug)
        return drinks.compactMap { .init(from: $0) }
    }
}

package extension DrinkModel {
    init(from model: DrinkEntity) {
        self.init(id: model.id ?? "",
                  size: model.amount,
                  container: model.container ?? "")
    }
}

extension DrinkEntity {
    public override var description: String {
        "Drink(" +
        "id:\(id ?? "No id"), " +
        "amount:\(amount), " +
        "container:\(container ?? "No container"))"
    }
}

extension DrinkEntity: @unchecked Sendable {}
