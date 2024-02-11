//
//  DatabaseStub.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/08/2023.
//

import CoreData
import DBKitInterface

public protocol DatabaseStubbing<StubbedElement> {
    associatedtype StubbedElement: NSManagedObject
    var open_returnValue: NSManagedObjectContext { get }
    var create_returnValue: Result<StubbedElement, Error> { get }
    var readMatchingSortByLimit_returnValue: Result<[StubbedElement], Error> { get }
    var deleteElement_returnValue: Error? { get }
}

public final class DatabaseStub<StubbedElement: NSManagedObject>: DatabaseStubbing {
    public var readMatchingOrderByLimit_returnValue: [StubbedElement] = []
    public var open_returnValue: NSManagedObjectContext = .init(.privateQueue)
    public var create_returnValue: Result<StubbedElement, Error> = .success(.init())
    public var readMatchingSortByLimit_returnValue: Result<[StubbedElement], Error> = .success([])
    public var deleteElement_returnValue: Error? = nil
    public init() {}
}

extension DatabaseStub: DatabaseType {
    public func open() -> NSManagedObjectContext {
        open_returnValue
    }
    
    public func save(_ context: NSManagedObjectContext) {}
    
    public func create(_ context: NSManagedObjectContext) throws -> StubbedElement {
        switch create_returnValue {
        case let .success(element):
            return element
        case let .failure(error):
            throw error
        }
    }
    
    public func read(matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?, _ context: NSManagedObjectContext) async throws -> [StubbedElement] {
        switch readMatchingSortByLimit_returnValue {
        case let .success(elements):
            return elements
        case let .failure(error):
            throw error
        }
    }
    
    public func delete(_ element: StubbedElement, _ context: NSManagedObjectContext) throws {
        if let deleteElement_returnValue {
            throw deleteElement_returnValue
        }
    }
}
