//
//  DayService.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import CoreKit
import CoreInterfaceKit
import Foundation

final class DayService: ServiceProtocol {
    private let manager: CoreDataManager<DayModel>
    private let defaultSort = [NSSortDescriptor(keyPath: \DayModel.date,
                                                ascending: false)]

    init(context: NSManagedObjectContext) {
        manager = CoreDataManager<DayModel>(context: context)
    }

    func create(_ item: Day) async throws -> DayModel {
        let dayModel = try await manager.create()
        dayModel.update(with: item)
        try await save()
        return dayModel
    }

    func delete(_ item: Day) async throws {
        let day = try await manager.get(using: .getElement(with: item.id),
                                        sortDescriptors: defaultSort)
        manager.delete(day)
        try await manager.saveChanges()
    }

    func save() async throws {
        try await manager.saveChanges()
    }

    func getElement(for date: Date) async throws -> DayModel {
        try await manager.get(using: .getElement(at: date), sortDescriptors: defaultSort)
    }
    
    func getElement(with id: UUID) async throws -> DayModel {
        try await manager.get(using: .getElement(with: id), sortDescriptors: nil)
    }

    func getLatestElement() async throws -> DayModel {
        try await manager.getLastObject(using: nil, sortDescriptors: defaultSort)
    }

    func getAll() async throws -> [DayModel] {
        try await manager.getAll(using: nil, sortDescriptors: defaultSort)
    }
}
