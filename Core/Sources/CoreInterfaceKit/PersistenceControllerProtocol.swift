//
//  PersistenceControllerProtocol.swift
//
//
//  Created by Petter vang Brakalsvålet on 30/04/2023.
//

import CoreData

public protocol PersistenceControllerProtocol {
    var container: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
}
