//
//  DatabaseService.swift
//
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import OSLog
import CoreData
import DBKitInterface

public class Database: DatabaseType {
    private var backgroundContext: NSManagedObjectContext?
    
    private let persistentContainer: NSPersistentContainer
    
    public init(appGroup: String, inMemory: Bool = false) {
        let databaseName = "reHydrate"
        
        guard let objectModelURL = Bundle.module.url(forResource: databaseName, withExtension: "momd"),
              let objectModel = NSManagedObjectModel(contentsOf: objectModelURL)
        else {
            let message = "Failed to retrieve the database object model"
            LoggingService.log(level: .error, message)
            fatalError(message)
        }
        
        guard let storeContainer = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup)
        else {
            let message = "Failed to created shared file container."
            LoggingService.log(level: .error, message)
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
                LoggingService.log(level: .error, message)
                fatalError(message)
            }
            LoggingService.log(level: .debug, "Loaded persistent store: \(description)")
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
            LoggingService.log(level: .debug, "Failed to save the context: \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
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
                LoggingService.log(level: .error, "Couldn't fetch items: \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
}

extension NSPredicate: @unchecked @retroactive Sendable {}

extension NSSortDescriptor: @unchecked @retroactive Sendable {}
