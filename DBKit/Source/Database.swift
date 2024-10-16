//
//  DatabaseService.swift
//
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import CoreData
import LoggingKit
import DBKitInterface

public class Database: DatabaseType {
    private var backgroundContext: NSManagedObjectContext?
    private let persistentContainer: NSPersistentContainer
    
    private let logger: LoggerServicing
    
    public init(appGroup: String, inMemory: Bool = false, logger: LoggerServicing) {
        let databaseName = "reHydrate"
        self.logger = logger
        
        guard let objectModelURL = Bundle.module.url(forResource: databaseName, withExtension: "momd"),
              let objectModel = NSManagedObjectModel(contentsOf: objectModelURL)
        else {
            let message = "Failed to retrieve the database object model"
            logger.log(category: .database, message: message, error: nil, level: .error)
            fatalError(message)
        }
        
        guard let storeContainer = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup)
        else {
            let message = "Failed to created shared file container."
            logger.log(category: .database, message: message, error: nil, level: .error)
            fatalError(message)
        }
        let storeURL = storeContainer.appendingPathComponent("\(databaseName).sqlite")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldInferMappingModelAutomatically = true
        
        persistentContainer = NSPersistentContainer(name: "reHydrate", managedObjectModel: objectModel)
        persistentContainer.persistentStoreDescriptions = [storeDescription]
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                let message = "Failed to load persistent stores: \(error.localizedDescription)"
                logger.log(category: .database, message: message, error: nil, level: .error)
                fatalError(message)
            }
            logger.log(category: .database, message: "Loaded persistent store: \(description)", error: nil, level: .debug)
        }
    }
    
    public func open() -> NSManagedObjectContext {
        if let backgroundContext {
            return backgroundContext
        } else {
            let context = persistentContainer.newBackgroundContext()
            backgroundContext = context
            return context
        }
    }
    
    public func save(_ context: NSManagedObjectContext) throws {
        // Verify that the context has uncommitted changes.
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            logger.log(category: .database, message: "Failed to save the context", error: error, level: .debug)
            throw error
        }
    }
    
    public func read<Element: NSManagedObject>(
        matching: NSPredicate?,
        sortBy: [NSSortDescriptor]?,
        limit: Int?,
        _ context: NSManagedObjectContext
    ) async throws -> [Element] {
        try await withCheckedThrowingContinuation { continuation in
            let fetchRequest = Element.fetchRequest()
            fetchRequest.predicate = matching
            fetchRequest.sortDescriptors = sortBy
            if let limit {
                fetchRequest.fetchLimit = limit
            }
            do {
                if let result = try context.fetch(fetchRequest) as? [Element] {
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(throwing: DatabaseError.couldNotMapElement)
                }
            } catch {
                logger.log(category: .database, message: "Couldn't fetch items", error: error, level: .error)
                continuation.resume(throwing: error)
            }
        }
    }
}
