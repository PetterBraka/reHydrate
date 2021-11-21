//
//  Repository.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import Combine
import CoreData

protocol Repository {
    associatedtype Day
    
    func create() -> AnyPublisher<Day, Error>
    func delete(_ day: Day) -> AnyPublisher<Bool, Error>
    func get(id: String, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?)
    -> AnyPublisher<Day?, Error>
    func get(date: Date, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?)
    -> AnyPublisher<Day?, Error>
    func getAll(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?)
    -> AnyPublisher<[Day], Error>
}

enum CoreDataError: Error {
    case invalidManagedObjectType
    case elementNotFound
}

class CoreDataRepository<T: NSManagedObject>: Repository {
    typealias Day = T
    
    private let managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func create() -> AnyPublisher<T, Error> {
        Future { promise in
            let className = String(describing: Day.self)
            guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className,
                                                                          into: self.managedObjectContext)
                    as? Day else { return promise(.failure(CoreDataError.invalidManagedObjectType)) }
            return promise(.success(managedObject))
        }
        .eraseToAnyPublisher()
    }
    
    func delete(_ day: T) -> AnyPublisher<Bool, Error> {
        Future { promise in
            self.managedObjectContext.delete(day)
            return promise(.success(true))
        }
        .eraseToAnyPublisher()
    }
    
    func get(id: String,
             predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?) -> AnyPublisher<T?, Error> {
        Future { promise in
            let entityName = String(describing: Day.self)
            let request = NSFetchRequest<Day>(entityName: entityName)
            request.sortDescriptors = sortDescriptors
            request.predicate = predicate
            request.predicate = NSPredicate(format: "id == %@", id)
            do {
                if let singleElement = try? self.managedObjectContext.fetch(request) {
                    return promise(.success(singleElement.first ?? nil))
                } else {
                    return promise(.failure(CoreDataError.invalidManagedObjectType))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func get(date: Date, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> AnyPublisher<T?, Error> {
        Future { promise in
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
            do {
                guard let results = try? self.managedObjectContext.fetch(request) else {
                    return promise(.failure(CoreDataError.invalidManagedObjectType))
                }
                guard let singleResult = results.first else {
                    return promise(.failure(CoreDataError.elementNotFound))
                }
                return promise(.success(singleResult))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getAll(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> AnyPublisher<[T], Error> {
        Future { promise in
            let entityName = String(describing: Day.self)
            let request = NSFetchRequest<Day>(entityName: entityName)
            request.sortDescriptors = sortDescriptors
            request.predicate = predicate
            do {
                guard let result = try? self.managedObjectContext.fetch(request) else {
                    return promise(.failure(CoreDataError.invalidManagedObjectType))
                }
                return promise(.success(result))
            }
        }
        .eraseToAnyPublisher()
    }
    
}