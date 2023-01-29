//
//  Repository.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    associatedtype Entity

    func create() async throws -> Entity
    func delete(_ day: Entity)
    func get(using predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?) async throws -> Entity
    func getLastObject(using predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?) async throws -> Entity?
    func getAll(using predicate: NSPredicate?,
                sortDescriptors: [NSSortDescriptor]?) async throws -> [Entity]
}

enum CoreDataError: Error {
    case invalidManagedObjectType
    case elementNotFound
}

class CoreDataManager<Entity: NSManagedObject>: CoreDataManagerProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func create() async throws -> Entity {
        let className = String(describing: Entity.self)
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className,
                                                                      into: context) as? Entity
        else {
            throw CoreDataError.invalidManagedObjectType
        }
        return managedObject
    }

    func saveChanges() async throws {
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }

    func delete(_ entity: Entity) {
        context.delete(entity)
    }

    func get(using predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?) async throws -> Entity {
        let entityName = String(describing: Entity.self)
        let request = NSFetchRequest<Entity>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        guard let results = try? context.fetch(request) else {
            throw CoreDataError.invalidManagedObjectType
        }
        guard let singleElement = results.first else {
            throw CoreDataError.elementNotFound
        }
        return singleElement
    }

    func getLastObject(using predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?) async throws -> Entity? {
        let entityName = String(describing: Entity.self)
        let request = NSFetchRequest<Entity>(entityName: entityName)
        request.sortDescriptors = []
        request.predicate = predicate
        request.fetchLimit = 1

        guard let results = try? context.fetch(request) else {
            throw CoreDataError.invalidManagedObjectType
        }
        return results.first
    }

    func getAll(using predicate: NSPredicate?,
                sortDescriptors: [NSSortDescriptor]?) async throws -> [Entity] {
        let entityName = String(describing: Entity.self)
        let request = NSFetchRequest<Entity>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        guard let result = try? context.fetch(request) else {
            throw CoreDataError.invalidManagedObjectType
        }
        return result
    }
}
