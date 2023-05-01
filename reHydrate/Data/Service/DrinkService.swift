//
//  DrinkService.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import CoreInterfaceKit
import CoreKit
import Foundation

final class DrinkService: ServiceProtocol {
    private let manager: CoreDataManager<DrinkModel>

    init(context: NSManagedObjectContext) {
        manager = CoreDataManager<DrinkModel>(context: context)
    }

    func create(_ item: Drink) async throws -> DrinkModel {
        let drinkModel = try await manager.create()
        drinkModel.update(with: item)
        try await save()
        return drinkModel
    }

    func delete(_ item: Drink) async throws {
        let drinkModel = try await manager.get(using: .getElement(with: item.id),
                                               sortDescriptors: nil)
        manager.delete(drinkModel)
        try await manager.saveChanges()
    }

    func save() async throws {
        try await manager.saveChanges()
    }

    func getElement(for date: Date) async throws -> DrinkModel {
        try await manager.get(using: .getElement(at: date), sortDescriptors: nil)
    }

    func getElement(with id: UUID) async throws -> DrinkModel {
        try await manager.get(using: .getElement(with: id), sortDescriptors: nil)
    }

    func getLatestElement() async throws -> DrinkModel {
        try await manager.getLastObject(using: nil, sortDescriptors: nil)
    }

    func getAll() async throws -> [DrinkModel] {
        try await manager.getAll(using: nil, sortDescriptors: nil)
    }
}
