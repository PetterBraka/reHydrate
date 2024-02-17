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
    func read<Element: NSManagedObject>(
        matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?,
        _ context: NSManagedObjectContext
    ) async throws -> [Element]
}
