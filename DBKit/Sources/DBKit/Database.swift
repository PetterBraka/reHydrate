//
//  DatabaseService.swift
//
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import OSLog
import CoreData
import DBKitInterface

public class Database<Element: NSManagedObject>: DatabaseType {
    private let logger: Logger
    private let inMemory: Bool
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
        
        persistentContainer.loadPersistentStores { [logger] description, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
            logger.debug("Loaded persistent store: \(description, privacy: .sensitive)")
        }
        return persistentContainer
    }()
    
    public init(inMemory: Bool = false) {
        let logger = Logger(subsystem: "reHydrate", category: "DataBase")
        self.logger = logger
        self.inMemory = inMemory
    }
    
    public func open() -> NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public func save(_ context: NSManagedObjectContext) throws {
        // Verify that the context has uncommitted changes.
        guard context.hasChanges else { return }
        
        try context.performAndWait {
            do {
                try context.save()
            } catch {
                logger.debug("Failed to save the context: \(error.localizedDescription, privacy: .private)")
                throw error
            }
        }
    }
    
    public func create(_ context: NSManagedObjectContext) throws -> Element {
        try context.performAndWait {
            let className = String(describing: Element.self)
            guard let managedObject = NSEntityDescription.insertNewObject(
                forEntityName: className,
                into: context
            ) as? Element
            else {
                throw DatabaseError.couldNotMapElement
            }
            return managedObject
        }
    }

    public func read(
        matching: NSPredicate?,
        sortBy: [NSSortDescriptor]?,
        limit: Int?,
        _ context: NSManagedObjectContext
    ) async throws -> [Element] {
        try await withCheckedThrowingContinuation { [self] continuation in
            let fetchRequest = Element.fetchRequest()
            fetchRequest.predicate = matching
            fetchRequest.sortDescriptors = sortBy
            if let limit {
                fetchRequest.fetchLimit = limit
            }
            context.performAndWait { [self] in
                do {
                    if let result = try context.fetch(fetchRequest) as? [Element] {
                        continuation.resume(returning: result)
                    } else {
                        continuation.resume(throwing: DatabaseError.couldNotMapElement)
                    }
                } catch {
                    self.logger.error("Couldn't fetch items: \(error, privacy: .private)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func delete(
        _ element: Element,
        _ context: NSManagedObjectContext
    ) throws {
        logger.info("Deleting element: \(String(describing: element))")
        try context.performAndWait {
            context.delete(element)
            do {
                try context.save()
            } catch {
                logger.error("Couldn't delete element \(error.localizedDescription)")
                context.rollback()
                throw error
            }
        }
    }
}
