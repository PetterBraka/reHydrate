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
        guard let drink = drinks.first
        else {
            throw DatabaseError.noElementFound
        }
        return drink
    }
    
    func fetchAllEntity() async throws -> [DrinkEntity] {
        try await database.read(
            matching: nil,
            sortBy: [NSSortDescriptor(key: "amount", ascending: true)],
            limit: nil,
            context)
    }
}

extension DrinkManager: DrinkManagerType {
    public func createNewDrink(size: Double, container: String) throws -> DrinkModel {
        let newDrink = DrinkEntity(context: context)
        newDrink.id = UUID().uuidString
        newDrink.amount = size
        newDrink.container = container
        try database.save(context)
        guard let newDrink = DrinkModel(from: newDrink)
        else {
            throw DatabaseError.creatingElement
        }
        return newDrink
    }
    
    public func edit(size: Double, of container: String) async throws -> DrinkModel {
        let drink = try await fetchEntity(container)
        drink.amount = size
        try database.save(context)
        guard let drink = DrinkModel(from: drink)
        else {
            throw DatabaseError.creatingElement
        }
        return drink
    }
    
    private func delete(_ drink: DrinkEntity) throws {
        context.delete(drink)
        try database.save(context)
    }
    
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
    
    public func deleteDrink(container: String) async throws {
        let drink = try await fetchEntity(container)
        try delete(drink)
    }
    
    public func deleteAll() async throws {
        let drinks = try await fetchAllEntity()
        for drink in drinks {
            try delete(drink)
        }
    }
    
    public func fetch(_ container: String) async throws -> DrinkModel {
        guard let drink = try await DrinkModel(from: fetchEntity(container))
        else {
            throw DatabaseError.couldNotMapElement
        }
        return drink
    }
    
    public func fetchAll() async throws -> [DrinkModel] {
        try await fetchAllEntity()
        .compactMap { .init(from: $0) }
    }
}

extension DrinkEntity {
    fileprivate convenience init(from model: DrinkModel) throws {
        self.init()
        self.id = model.id
        self.container = model.container
        self.amount = model.size
    }
}

private extension DrinkModel {
    init?(from model: DrinkEntity) {
        guard let id = model.id, let container = model.container
        else { return nil }
        self.init(id: id, size: model.amount, container: container)
    }
}
