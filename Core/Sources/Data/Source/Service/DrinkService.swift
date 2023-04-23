//
//  DrinkService.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import Foundation
import DataInterface

public final class DrinkService {
    typealias DataModel = DrinkModel
    private let manager: CoreDataManager<DrinkModel>

    public init(context: NSManagedObjectContext) {
        manager = CoreDataManager<DrinkModel>(context: context)
    }

    public func create(id: UUID, ofSize size: Double) async throws -> DrinkModel {
        let drinkModel = try await manager.create()
        drinkModel.id = id
        drinkModel.size = size
        try await save()
        return drinkModel
    }

    public func delete(itemWithId id: UUID) async throws {
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        let drinkModel = try await manager.get(using: predicate,
                                               sortDescriptors: nil)
        manager.delete(drinkModel)
        try await manager.saveChanges()
    }

    public func save() async throws {
        try await manager.saveChanges()
    }
    
    public func getElement(with id: UUID) async throws -> DrinkModel {
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        let drinkModel = try await manager.get(using: predicate,
                                               sortDescriptors: nil)
        return drinkModel
    }

    public func getElement(for date: Date) async throws -> DrinkModel {
        let datePredicate = PredicateHelper.getPredicate(for: date)
        let drinkModel = try await manager.get(using: datePredicate,
                                               sortDescriptors: nil)
        return drinkModel
    }

    public func getLatestElement() async throws -> DrinkModel {
        guard let drinkModel = try await manager.getLastObject(using: nil,
                                                               sortDescriptors: nil)
        else {
            throw CoreDataError.elementNotFound
        }
        return drinkModel
    }

    public func getAll() async throws -> [DrinkModel] {
        let drinkModels = try await manager.getAll(using: nil,
                                                   sortDescriptors: nil)
        return drinkModels
    }
}
