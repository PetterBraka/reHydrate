//
//  ConsumptionManager.swift
//  
//
//  Created by Petter vang Brakalsvålet on 07/08/2023.
//

import CoreData
import DBKitInterface

public final class ConsumptionManager {
    private let database: DatabaseType
    private let context: NSManagedObjectContext
    
    public init(database: DatabaseType) {
        self.database = database
        self.context = database.open()
    }

}

extension ConsumptionManager: ConsumptionManagerType {
    @discardableResult
    public func createEntry(
        date: Date,
        consumed: Double
    ) throws -> ConsumptionModel {
        let newEntry = ConsumptionEntity(context: context)
        newEntry.id = UUID().uuidString
        newEntry.date = DatabaseFormatter.date.string(from: date)
        newEntry.time = DatabaseFormatter.time.string(from: date)
        newEntry.consumed = consumed
        try database.save(context)
        
        guard let newEntry = ConsumptionModel(from: newEntry)
        else {
            throw DatabaseError.creatingElement
        }
        return newEntry
    }
    
    private func delete(_ day: ConsumptionEntity) throws {
        context.delete(day)
        try database.save(context)
    }
    
    public func delete(_ entry: ConsumptionModel) async throws {
        let datePredicate = NSPredicate(format: "date == %@", entry.date)
        let timePredicate = NSPredicate(format: "time == %@", entry.time)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, timePredicate])
        let entries: [ConsumptionEntity] = try await database.read(
            matching: predicate,
            sortBy: nil,
            limit: 1,
            context)
        guard let entry = entries.first else { return }
        try delete(entry)
    }

    public func fetchAll(at date: Date) async throws -> [ConsumptionModel] {
        let predicate = NSPredicate(format: "date == %@", DatabaseFormatter.date.string(from: date))
        let entries: [ConsumptionEntity] = try await database.read(
            matching: predicate,
            sortBy: [NSSortDescriptor(key: "time", ascending: true)],
            limit: nil,
            context)
        return entries.compactMap { .init(from: $0) }
    }
    
    public func fetchAll() async throws -> [ConsumptionModel] {
        try await database.read(
            matching: nil,
            sortBy: [NSSortDescriptor(key: "date", ascending: true)],
            limit: nil,
            context)
        .sorted { (lhs: ConsumptionEntity , rhs: ConsumptionEntity) in
            guard let lhsTime = lhs.time, let rhsTime = rhs.time,
                  let lhsDate = lhs.date, let rhsDate = rhs.date
            else { return false }
            if lhsDate == rhsDate {
                return lhsTime > rhsTime
            } else {
                return lhsDate > rhsDate
            }
        }
        .compactMap { .init(from: $0) }
    }
}

private extension ConsumptionEntity {
    convenience init(from model: ConsumptionModel) throws {
        self.init()
        self.id = model.id
        self.date = model.date
        self.consumed = model.consumed
        self.time = model.time
    }
}

private extension ConsumptionModel {
    init?(from model: ConsumptionEntity) {
        guard let id = model.id, let date = model.date, let time = model.time
        else { return nil }
        self.init(id: id, date: date, time: time, consumed: model.consumed)
    }
}
