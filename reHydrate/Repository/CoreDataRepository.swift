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
    func get(id: String,
             predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?) async throws -> Day
    func get(date: Date,
             predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?) async throws -> Day
    func getLastObject(predicate: NSPredicate?) async throws -> Day?
    func getAll(predicate: NSPredicate?,
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

    func get(id: String,
             predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?) async throws -> Day {
        let entityName = String(describing: Day.self)
        let request = NSFetchRequest<Day>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let results = try? managedObjectContext.fetch(request) else {
            throw CoreDataError.invalidManagedObjectType
        }
        guard let singleElement = results.first else {
            throw CoreDataError.elementNotFound
        }
        return singleElement
    }

    func get(date: Date,
             predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?) async throws -> Day {
        let entityName = String(describing: Day.self)
        let request = NSFetchRequest<Day>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        // Get day's beginning & tomorrows beginning time
        let startOfDay = Calendar.current.startOfDay(for: date)
        let startOfNextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
        // Sets conditions for date to be within day
        let fromPredicate = NSPredicate(format: "date >= %@", startOfDay as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", startOfNextDay! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
            [fromPredicate, toPredicate])
        request.predicate = datePredicate
        guard let results = try? managedObjectContext.fetch(request) else {
            throw CoreDataError.invalidManagedObjectType
        }
        guard let singleElement = results.first else {
            throw CoreDataError.elementNotFound
        }
        return singleElement
    }

    func getLastObject(predicate: NSPredicate?) async throws -> Day? {
        let entityName = String(describing: Day.self)
        let request = NSFetchRequest<Day>(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.predicate = predicate
        request.fetchLimit = 1

        guard let results = try? managedObjectContext.fetch(request) else {
            throw CoreDataError.invalidManagedObjectType
        }
        return results.first
    }

    func getAll(predicate: NSPredicate?,
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
