//
//  Repository.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import Foundation
import CoreInterfaceKit

public final class CoreDataManager<Entity: NSManagedObject>: CoreDataManagerProtocol {
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func create() async throws -> Entity {
        let className = String(describing: Entity.self)
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className,
                                                                      into: context) as? Entity
        else {
            throw CoreDataError.invalidManagedObjectType
        }
        return managedObject
    }
    
    /// Will try to save the changes made but if it fails it will roll it back
    public func saveChanges() async throws {
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
    
    public func delete(_ entity: Entity) {
        context.delete(entity)
    }
    
    public func get(using predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?) async throws -> Entity {
        let entityName = String(describing: Entity.self)
        let request = NSFetchRequest<Entity>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        let results = try context.fetch(request)
        guard let singleElement = results.first else {
            throw CoreDataError.elementNotFound
        }
        return singleElement
    }
    
    public func getLastObject(using predicate: NSPredicate?,
                       sortDescriptors _: [NSSortDescriptor]?) async throws -> Entity {
        let entityName = String(describing: Entity.self)
        let request = NSFetchRequest<Entity>(entityName: entityName)
        request.sortDescriptors = []
        request.predicate = predicate
        request.fetchLimit = 1
        
        let results = try context.fetch(request)
        guard let element = results.first
        else {
            throw CoreDataError.elementNotFound
        }
        return element
    }
    
    public func getAll(using predicate: NSPredicate?,
                sortDescriptors: [NSSortDescriptor]?) async throws -> [Entity] {
        let entityName = String(describing: Entity.self)
        let request = NSFetchRequest<Entity>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        let results = try context.fetch(request)
        return results
    }
}
