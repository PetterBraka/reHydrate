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
        LoggingService.log(level: .debug, "Created consumption \(newEntry)")
        
        return ConsumptionModel(from: newEntry)
    }
    
    private func delete(_ entity: ConsumptionEntity) throws {
        context.delete(entity)
        try database.save(context)
        LoggingService.log(level: .debug, "Deleted consumption \(entity)")
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
        LoggingService.log(level: .debug, "Found consumption \(entries)")
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
        LoggingService.log(level: .debug, "Found consumption \(entries)")
        return entries.compactMap { .init(from: $0) }
    }
    
    public func fetchAll() async throws -> [ConsumptionModel] {
        let entries: [ConsumptionEntity] = try await database.read(
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
        LoggingService.log(level: .debug, "Found consumption \(entries)")
        return entries.compactMap { .init(from: $0) }
    }
}

package extension ConsumptionModel {
    init(from model: ConsumptionEntity) {
        self.init(id: model.id ?? "",
                  date: model.date ?? "",
                  time: model.time ?? "",
                  consumed: model.consumed)
    }
}

extension ConsumptionEntity {
    public override var description: String {
        "Consumption: \n\t" +
        "id:\(id ?? "No id")\n\t" +
        "date:\(date ?? "No date")\n\t" +
        "time:\(time ?? "No time")\n\t" +
        "consumed:\(consumed)\n"
    }
}
