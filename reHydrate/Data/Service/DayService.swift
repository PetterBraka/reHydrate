//
//  DayService.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import Foundation

final class DayService: ServiceProtocol {
    private let manager: CoreDataManager<DayModel>
    private let defaultSort = [NSSortDescriptor(keyPath: \DayModel.date, ascending: false)]

    init(context: NSManagedObjectContext) {
        manager = CoreDataManager<DayModel>(context: context)
    }

    func create(_ item: Day) async throws -> DayModel {
        let dayModel = try await manager.create()
        dayModel.updateCoreDataModel(item)
        try await save()
        return dayModel
    }

    func delete(_ item: Day) async throws {
        let predicate = NSPredicate(format: "id == %@", item.id.uuidString)
        let day = try await manager.get(using: predicate,
                                        sortDescriptors: defaultSort)
        manager.delete(day)
        try await manager.saveChanges()
    }

    func save() async throws {
        try await manager.saveChanges()
    }

    func getElement(for date: Date) async throws -> DayModel {
        let datePredicate = PredicateHelper.getPredicate(from: date)
        let day = try await manager.get(using: datePredicate,
                                        sortDescriptors: defaultSort)
        return day
    }

    func getLatestElement() async throws -> DayModel {
        guard let dayModel = try await manager.getLastObject(using: nil,
                                                             sortDescriptors: defaultSort)
        else {
            throw CoreDataError.elementNotFound
        }
        return dayModel
    }

    func getAll() async throws -> [DayModel] {
        let dayModels = try await manager.getAll(using: nil,
                                                 sortDescriptors: defaultSort)
        return dayModels
    }
}
