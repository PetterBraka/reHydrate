//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/02/2024.
//

import CoreData

public protocol DatabaseType<Element> {
    associatedtype Element: NSManagedObject
    
    func open() -> NSManagedObjectContext
    func save(_ context: NSManagedObjectContext) throws
    func create(_ context: NSManagedObjectContext) throws -> Element
    func read(matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?,
              _ context: NSManagedObjectContext) async throws -> [Element]
    func delete(_ element: Element, _ context: NSManagedObjectContext) throws
}
