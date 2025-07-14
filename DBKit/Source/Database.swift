//
//  DatabaseService.swift
//
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Foundation
import SwiftData
import LoggingKit
import DBKitInterface

public final actor Database: DatabaseType {
    private let modelContext: ModelContext
    private let modelContainer: ModelContainer
    private let logger: LoggerServicing
    
    public init(
        appGroup: String,
        inMemory: Bool = false,
        schema: Schema,
        logger: LoggerServicing,
    ) {
        self.logger = logger
        
        let dbURL: URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)
        let config: ModelConfiguration
        
        if inMemory {
            config = .init(isStoredInMemoryOnly: true)
        } else if let dbURL {
            config = .init(url: dbURL.appendingPathComponent("reHydrate.sqlite"))
        } else {
            let message = "Failed to create shared file container."
            logger.log(category: .database, message: message, error: nil, level: .error)
            fatalError(message)
        }
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: config)
        } catch {
            let message = "Failed to load persistent model container: \(error.localizedDescription)"
            logger.log(category: .database, message: message, error: error, level: .error)
            fatalError(message)
        }
        modelContext = ModelContext(modelContainer)
    }
    
    public func insert<Model: PersistentModel & Sendable>(_ model: Model) async {
        modelContext.insert(model)
    }
    
    public func delete<Model: PersistentModel & Sendable>(_ model: Model) async {
        modelContext.delete(model)
    }
    
    public func save() async throws {
        guard modelContext.hasChanges else { return }
        
        do {
            try modelContext.save()
        } catch {
            logger.log(category: .database, message: "Failed to save the context", error: error, level: .debug)
            throw error
        }
    }
    
    public func read<Element: PersistentModel & Sendable>(
        matching: Predicate<Element>?,
        sortBy: [SortDescriptor<Element>] = [],
        limit: Int?
    ) async throws -> [Element] {
        let fetchDescriptor = FetchDescriptor<Element>(predicate: matching, sortBy: sortBy)
        var results = try modelContext.fetch(fetchDescriptor)
        if let limit {
            results = Array(results.prefix(limit))
        }
        return results
    }
}

