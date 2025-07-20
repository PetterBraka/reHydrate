//
//  ConsumptionManager.swift
//  
//
//  Created by Petter vang Brakalsvålet on 07/08/2023.
//

import Foundation
import SwiftData
import LoggingKit
import DBKitInterface

public final actor ConsumptionManager {
    private let context: ModelContext
    private let logger: LoggerServicing
    
    public init(container: ModelContainer, logger: LoggerServicing) {
        self.context = ModelContext(container)
        self.logger = logger
    }
}

extension ConsumptionManager: ConsumptionManagerType {
    @discardableResult
    public func createEntry(
        date: Date,
        consumed: Double
    ) async throws -> ConsumptionModel {
        let newEntity = ConsumptionEntity(
            id: UUID().uuidString,
            date: DatabaseFormatter.date.string(from: date),
            time: DatabaseFormatter.time.string(from: date),
            consumed: consumed
        )
        context.insert(newEntity)
        try save()
        logger.log(category: .consumptionDatabase, message: "Created \(newEntity)", error: nil, level: .debug)
        
        return newEntity.asModel
    }
    
    public func delete(_ entry: ConsumptionModel) async throws {
        let consumed = entry.consumed
        let date = entry.date
        let time = entry.time
        let predicate = #Predicate<ConsumptionEntity> {
            $0.consumed == consumed && $0.date == date && $0.time == time
        }
        let entities: [ConsumptionEntity] = try read(
            matching: predicate,
            limit: 1
        )
        guard let entity = entities.first else {
            throw DatabaseError.noElementFound
        }
        context.delete(entity)
        try save()
        logger.log(category: .consumptionDatabase, message: "Deleted \(entity)", error: nil, level: .debug)
    }
    
    public func fetchAll(at date: Date) async throws -> [ConsumptionModel] {
        let dateString = DatabaseFormatter.date.string(from: date)
        let predicate = #Predicate<ConsumptionEntity> { $0.date == dateString }
        
        let entries: [ConsumptionEntity] = try read(
            matching: predicate,
            sortBy: [SortDescriptor(\ConsumptionEntity.time, order: .forward)],
            limit: nil)
        logger.log(category: .consumptionDatabase, message: "Found \(entries)", error: nil, level: .debug)
        return entries.map { $0.asModel }
    }
    
    public func fetchAll() async throws -> [ConsumptionModel] {
        let entries: [ConsumptionEntity] = try read(
            matching: nil,
            sortBy: [SortDescriptor(\ConsumptionEntity.date, order: .forward), SortDescriptor(\ConsumptionEntity.time, order: .forward)],
            limit: nil)
        // Entries are sorted by date ascending, then time ascending by the sort descriptors above.
        logger.log(category: .consumptionDatabase, message: "Found \(entries)", error: nil, level: .debug)
        return entries.map { $0.asModel }
    }
}

private extension ConsumptionManager {
    func read<Element: PersistentModel>(
        matching: Predicate<Element>?,
        sortBy: [SortDescriptor<Element>] = [],
        limit: Int?
    ) throws -> [Element] {
        let fetchDescriptor = FetchDescriptor<Element>(predicate: matching, sortBy: sortBy)
        var results = try context.fetch(fetchDescriptor)
        if let limit {
            results = Array(results.prefix(limit))
        }
        return results
    }
    
    func save() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            logger.log(category: .consumptionDatabase, message: "Failed to save the context", error: error, level: .debug)
            throw error
        }
    }
}

