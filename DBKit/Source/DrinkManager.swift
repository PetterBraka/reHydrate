//
//  DrinkManager.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import Foundation
import DBKitInterface
import CoreData

public final class DrinkManager {
    private let database: DatabaseType
    private let context: NSManagedObjectContext
    
    public init(database: DatabaseType) {
        self.database = database
        self.context = database.open()
    }
}

private extension DrinkManager {
    func fetchEntity(_ container: String) async throws -> DrinkEntity {
        let drinks: [DrinkEntity] = try await database.read(
            matching: .init(format: "container == %@", container),
            sortBy: [NSSortDescriptor(key: "amount", ascending: true)],
            limit: 1,
            context)
        LoggingService.log(level: .debug, "Found drink \(drinks)")
        guard let drink = drinks.first
        else {
            throw DatabaseError.noElementFound
        }
        return drink
    }
    
    func fetchAllEntity() async throws -> [DrinkEntity] {
        let drinks: [DrinkEntity] = try await database.read(
            matching: nil,
            sortBy: [NSSortDescriptor(key: "amount", ascending: true)],
            limit: nil,
            context)
        LoggingService.log(level: .debug, "Found drink \(drinks)")
        return drinks
    }
}

extension DrinkManager: @preconcurrency DrinkManagerType {
    @MainActor
    public func createNewDrink(size: Double, container: String) throws -> DrinkModel {
        let newDrink = DrinkEntity(context: context)
        newDrink.id = UUID().uuidString
        newDrink.amount = size
        newDrink.container = container
        try database.save(context)
        LoggingService.log(level: .debug, "Created drink \(newDrink)")
        return DrinkModel(from: newDrink)
    }
    
    @MainActor
    public func edit(size: Double, of container: String) async throws -> DrinkModel {
        let drink = try await fetchEntity(container)
        drink.amount = size
        try database.save(context)
        LoggingService.log(level: .debug, "Edited drink \(drink)")
        return DrinkModel(from: drink)
    }
    
    @MainActor
    private func delete(_ drink: DrinkEntity) throws {
        context.delete(drink)
        try database.save(context)
        LoggingService.log(level: .debug, "Deleted drink \(drink)")
    }
    
    @MainActor
    public func delete(_ drink: DrinkModel) async throws {
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
        for drink in drinks {
            try delete(drink)
        }
    }
    
    @MainActor
    public func deleteDrink(container: String) async throws {
        let drink = try await fetchEntity(container)
        try delete(drink)
    }
    
    @MainActor
    public func deleteAll() async throws {
        let drinks = try await fetchAllEntity()
        for drink in drinks {
            try delete(drink)
        }
    }
    
    public func fetch(_ container: String) async throws -> DrinkModel {
        try await DrinkModel(from: fetchEntity(container))
    }
    
    public func fetchAll() async throws -> [DrinkModel] {
        try await fetchAllEntity()
        .compactMap { .init(from: $0) }
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
        "Drink: \n\t" +
        "id:\(id ?? "No id")\n\t" +
        "amount:\(amount)\n\t" +
        "container:\(container ?? "No container")\n"
    }
}
