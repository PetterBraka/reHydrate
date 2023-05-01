//
//  PresistenceController.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import CoreInterfaceKit

public struct PresistenceController: PresistenceControllerProtocol {
    static func empty() -> PresistenceController {
        PresistenceController(inMemory: true)
    }

    public var container: NSPersistentContainer

    public init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "reHydrate")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}