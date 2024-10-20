//
//  CoreData+ext.swift
//  DBKit
//
//  Created by Petter vang Brakalsvålet on 20/10/2024.
//

import CoreData

extension NSPredicate: @unchecked @retroactive Sendable {}
extension NSManagedObject: @unchecked @retroactive Sendable {}
extension NSSortDescriptor: @unchecked @retroactive Sendable {}
extension NSManagedObjectContext: @unchecked @retroactive Sendable {}
