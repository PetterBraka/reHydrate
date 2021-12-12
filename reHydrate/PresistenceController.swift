//
//  {resostemceController.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreData

protocol PresistenceControllerProtocol {
    var container: NSPersistentContainer { get }
}

struct PresistenceController: PresistenceControllerProtocol {
    static func empty() -> PresistenceController {
        PresistenceController(inMemory: true)
    }

    var container: NSPersistentContainer

    init(inMemory: Bool = false) {
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
