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
    private let inMemory: Bool
    private var backgroundContext: NSManagedObjectContext?
    
    private lazy var persistentContainer: NSPersistentContainer = {
        guard let objectModelURL = Bundle.module.url(forResource: "reHydrate", withExtension: "momd"),
              let objectModel = NSManagedObjectModel(contentsOf: objectModelURL)
        else {
            fatalError("Failed to retrieve the object model")
        }
        let persistentContainer = NSPersistentContainer(name: "reHydrate", managedObjectModel: objectModel)
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
            LoggingService.log(level: .debug, "Loaded persistent store: \(description)")
        }
        return persistentContainer
    }()
    
    public init(inMemory: Bool = false) {
        self.inMemory = inMemory
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
