//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/02/2024.
//

import CoreData

public protocol DatabaseType {
    func open() -> NSManagedObjectContext
    func save(_ context: NSManagedObjectContext) throws
//    func create<Element: NSManagedObject>(_ context: NSManagedObjectContext) throws -> Element
    func read<Element: NSManagedObject>(matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?,
              _ context: NSManagedObjectContext) async throws -> [Element]
//    func delete<Element: NSManagedObject>(_ element: Element, _ context: NSManagedObjectContext) throws
}
