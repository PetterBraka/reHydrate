//
//  ConsumptionManager.swift
//  
//
//  Created by Petter vang Brakalsvålet on 07/08/2023.
//

import CoreData
import LoggingKit
import DBKitInterface

public final actor ConsumptionManager {
    private let database: DatabaseType
    private let logger: LoggerServicing
    
    public init(database: DatabaseType, logger: LoggerServicing) {
        self.database = database
        self.logger = logger
    }
    
    public func run<T>(
        resultType: T.Type = T.self,
        body: @MainActor @Sendable () throws -> T
    ) async rethrows -> T where T : Sendable {
        try await body()
    }
}

extension ConsumptionManager: ConsumptionManagerType {
    @discardableResult
    public func createEntry(
        date: Date,
        consumed: Double
    ) async throws -> ConsumptionModel {
        let context = await database.open()
        let newEntry = ConsumptionEntity(context: context)
        newEntry.id = UUID().uuidString
        newEntry.date = DatabaseFormatter.date.string(from: date)
        newEntry.time = DatabaseFormatter.time.string(from: date)
        newEntry.consumed = consumed
        try await database.save(context)
        logger.log(category: .consumptionDatabase, message: "Created \(newEntry)", error: nil, level: .debug)
        
        return ConsumptionModel(from: newEntry)
    }
    
    private func delete(_ entity: ConsumptionEntity) async throws {
        let context = await database.open()
        context.delete(entity)
        try await database.save(context)
    }
    
    public func delete(_ entry: ConsumptionModel) async throws {
        let context = await database.open()
        let datePredicate = NSPredicate(format: "date == %@", entry.date)
        let timePredicate = NSPredicate(format: "time == %@", entry.time)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, timePredicate])
        let entries: [ConsumptionEntity] = try await database.read(
            matching: predicate,
            sortBy: nil,
            limit: 1,
            context)
        guard let entry = entries.first else { return }
        try await delete(entry)
        logger.log(category: .consumptionDatabase, message: "Deleting \(entry)", error: nil, level: .debug)
    }

    public func fetchAll(at date: Date) async throws -> [ConsumptionModel] {
        let context = await database.open()
        let predicate = NSPredicate(format: "date == %@", DatabaseFormatter.date.string(from: date))
        let entries: [ConsumptionEntity] = try await database.read(
            matching: predicate,
            sortBy: [NSSortDescriptor(key: "time", ascending: true)],
            limit: nil,
            context)
        logger.log(category: .consumptionDatabase, message: "Found \(entries)", error: nil, level: .debug)
        return entries.compactMap { .init(from: $0) }
    }
    
    public func fetchAll() async throws -> [ConsumptionModel] {
        let context = await database.open()
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
        logger.log(category: .consumptionDatabase, message: "Found \(entries)", error: nil, level: .debug)
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
        "Consumption(" +
        "id:\(id ?? "No id"), " +
        "date:\(date ?? "No date"), " +
        "time:\(time ?? "No time"), " +
        "consumed:\(consumed))"
    }
}

extension ConsumptionEntity: @unchecked Sendable {}
