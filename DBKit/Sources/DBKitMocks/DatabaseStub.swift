//
//  DatabaseStub.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/08/2023.
//

import CoreData
import DBKitInterface

public protocol DatabaseStubbing {
    var open_returnValue: NSManagedObjectContext { get }
    var create_returnValue: Result<NSManagedObject, Error> { get }
    var readMatchingSortByLimit_returnValue: Result<[NSManagedObject], Error> { get }
    var deleteElement_returnValue: Error? { get }
}

public final class DatabaseStub: DatabaseStubbing {
    public var readMatchingOrderByLimit_returnValue: [NSManagedObject] = []
    public var open_returnValue: NSManagedObjectContext = .init(.privateQueue)
    public var create_returnValue: Result<NSManagedObject, Error> = .success(.init())
    public var readMatchingSortByLimit_returnValue: Result<[NSManagedObject], Error> = .success([])
    public var deleteElement_returnValue: Error? = nil
    public init() {}
}

extension DatabaseStub: DatabaseType {
    public func open() -> NSManagedObjectContext {
        open_returnValue
    }
    
    public func save(_ context: NSManagedObjectContext) {}
    
    public func create<Element: NSManagedObject>(_ context: NSManagedObjectContext) throws -> Element {
        switch create_returnValue {
        case let .success(element):
            return element as! Element
        case let .failure(error):
            throw error
        }
    }
    
    public func read<Element: NSManagedObject>(matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?, _ context: NSManagedObjectContext) async throws -> [Element] {
        switch readMatchingSortByLimit_returnValue {
        case let .success(elements):
            return elements as! [Element]
        case let .failure(error):
            throw error
        }
    }
    
    public func delete<Element: NSManagedObject>(_ element: Element, _ context: NSManagedObjectContext) throws {
        if let deleteElement_returnValue {
            throw deleteElement_returnValue
        }
    }
}
