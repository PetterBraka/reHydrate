//
//  DayService.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import Foundation
import DataInterface

public final class DayService {
    private let manager: CoreDataManager<DayModel>
    private let defaultSort = [NSSortDescriptor(keyPath: \DayModel.date, ascending: false)]

    public init(context: NSManagedObjectContext) {
        manager = CoreDataManager<DayModel>(context: context)
    }

    public func createDay(id: UUID,
                   consumption: Double,
                   goal: Double,
                   date: Date) async throws -> DayModel {
        let dayModel = try await manager.create()
        dayModel.id = id
        dayModel.consumtion = consumption
        dayModel.goal = goal
        dayModel.date = date
        try await save()
        return dayModel
    }

    public func delete(itemWithId id: UUID) async throws {
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        let day = try await manager.get(using: predicate,
                                        sortDescriptors: defaultSort)
        manager.delete(day)
        try await manager.saveChanges()
    }

    public func save() async throws {
        try await manager.saveChanges()
    }

    public func getElement(for date: Date) async throws -> DayModel {
        let datePredicate = PredicateHelper.getPredicate(for: date)
        let day = try await manager.get(using: datePredicate,
                                        sortDescriptors: defaultSort)
        return day
    }

    public func getLatestElement() async throws -> DayModel {
        guard let dayModel = try await manager.getLastObject(using: nil,
                                                             sortDescriptors: defaultSort)
        else {
            throw CoreDataError.elementNotFound
        }
        return dayModel
    }

    public func getAll() async throws -> [DayModel] {
        let dayModels = try await manager.getAll(using: nil,
                                                 sortDescriptors: defaultSort)
        return dayModels
    }
}
