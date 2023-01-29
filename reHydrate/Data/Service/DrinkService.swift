//
//  DrinkService.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import Foundation

final class DrinkService: ServiceProtocol {
    typealias DataModel = DrinkModel
    typealias DomainModel = Drink
    private let manager: CoreDataManager<DrinkModel>
    
    init(context: NSManagedObjectContext) {
        manager = CoreDataManager<DrinkModel>(context: context)
    }
    
    func create(_ item: Drink) async throws {
        let drinkModel = try await manager.create()
        drinkModel.updateCoreDataModel(item)
        try await save()
    }
    
    func delete(_ item: Drink) async throws {
        let predicate = NSPredicate(format: "id == %@", item.id.uuidString)
        let drinkModel = try await manager.get(using: predicate,
                                               sortDescriptors: nil)
        manager.delete(drinkModel)
        try await manager.saveChanges()
    }
    
    func save() async throws {
        try await manager.saveChanges()
    }
    
    func getElement(for date: Date) async throws -> DrinkModel {
        let datePredicate = PredicateHelper.getPredicate(from: date)
        let drinkModel = try await manager.get(using: datePredicate,
                                               sortDescriptors: nil)
        return drinkModel
    }
    
    func getLatestElement() async throws -> DrinkModel {
        guard let drinkModel = try await manager.getLastObject(using: nil,
                                                               sortDescriptors: nil) else {
            throw CoreDataError.elementNotFound
        }
        return drinkModel
    }
    
    func getAll() async throws -> [DrinkModel] {
        let drinkModels = try await manager.getAll(using: nil,
                                                 sortDescriptors: nil)
        return drinkModels
    }
}
