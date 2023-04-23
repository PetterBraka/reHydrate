//
//  CoreDataManagerProtocol.swift
//  
//
//  Created by Petter vang Brakalsvålet on 23/04/2023.
//

import Foundation

public protocol CoreDataManagerProtocol {
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
