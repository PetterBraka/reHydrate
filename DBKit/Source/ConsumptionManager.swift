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
    private let database: DatabaseType
    private let logger: LoggerServicing
    
    public init(database: DatabaseType, logger: LoggerServicing) {
        self.database = database
        self.logger = logger
    }
}

extension ConsumptionManager: ConsumptionManagerType {
    @discardableResult
    public func createEntry(
        date: Date,
        consumed: Double
    ) async throws -> ConsumptionModel {
        let newEntry = ConsumptionModel(
            id: UUID().uuidString,
            date: DatabaseFormatter.date.string(from: date),
            time: DatabaseFormatter.time.string(from: date),
            consumed: consumed
        )
        await database.insert(newEntry)
        try await database.save()
        logger.log(category: .consumptionDatabase, message: "Created \(newEntry)", error: nil, level: .debug)
        
        return newEntry
    }
    
    public func delete(_ entity: ConsumptionModel) async throws {
        await database.delete(entity)
        try await database.save()
    }

    public func fetchAll(at date: Date) async throws -> [ConsumptionModel] {
        let dateString = DatabaseFormatter.date.string(from: date)
        let predicate = #Predicate<ConsumptionModel> { $0.date == dateString }
        let entries: [ConsumptionModel] = try await database.read(
            matching: predicate,
            sortBy: [SortDescriptor(\ConsumptionModel.time, order: .forward)],
            limit: nil)
        logger.log(category: .consumptionDatabase, message: "Found \(entries)", error: nil, level: .debug)
        return entries
    }
    
    public func fetchAll() async throws -> [ConsumptionModel] {
        let entries: [ConsumptionModel] = try await database.read(
            matching: nil,
            sortBy: [SortDescriptor(\ConsumptionModel.date, order: .forward), SortDescriptor(\ConsumptionModel.time, order: .forward)],
            limit: nil)
        // Entries are sorted by date ascending, then time ascending by the sort descriptors above.
        logger.log(category: .consumptionDatabase, message: "Found \(entries)", error: nil, level: .debug)
        return entries
    }
}

