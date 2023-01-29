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

protocol Repository {
    associatedtype Day

    func create() async throws -> Day
    func delete(_ day: Day)
    func get(using predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?) async throws -> Day
    func getLastObject(using predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?) async throws -> Day?
    func getAll(using predicate: NSPredicate?,
                sortDescriptors: [NSSortDescriptor]?) async throws -> [Day]
}

enum CoreDataError: Error {
    case invalidManagedObjectType
    case elementNotFound
}

class CoreDataRepository<Day: NSManagedObject>: Repository {
    private let managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        managedObjectContext = context
    }

    func create() async throws -> Day {
        let className = String(describing: Day.self)
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className,
                                                                      into: managedObjectContext) as? Day
        else {
            throw CoreDataError.invalidManagedObjectType
        }
        return managedObject
    }

    func delete(_ day: Day) {
        managedObjectContext.delete(day)
    }

    func get(using predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?) async throws -> Day {
        let entityName = String(describing: Day.self)
        let request = NSFetchRequest<Day>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        guard let results = try? managedObjectContext.fetch(request) else {
            throw CoreDataError.invalidManagedObjectType
        }
        guard let singleElement = results.first else {
            throw CoreDataError.elementNotFound
        }
        return singleElement
    }

    func getLastObject(using predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?) async throws -> Day? {
        let entityName = String(describing: Day.self)
        let request = NSFetchRequest<Day>(entityName: entityName)
        request.sortDescriptors = []
        request.predicate = predicate
        request.fetchLimit = 1

        guard let results = try? managedObjectContext.fetch(request) else {
            throw CoreDataError.invalidManagedObjectType
        }
        return results.first
    }

    func getAll(using predicate: NSPredicate?,
                sortDescriptors: [NSSortDescriptor]?) async throws -> [Day] {
        let entityName = String(describing: Day.self)
        let request = NSFetchRequest<Day>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        guard let result = try? managedObjectContext.fetch(request) else {
            throw CoreDataError.invalidManagedObjectType
        }
        return result
    }
}
