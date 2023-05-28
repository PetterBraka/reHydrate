//
//  ManagerAssembly.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreInterfaceKit
import CoreKit
import Foundation
import Swinject

class ManagerAssembly: Assembly {
    func assemble(container: Container) {
        // Persistence - Manager
        container.register(PersistenceControllerProtocol.self) { _ in
            PersistenceController()
        }.inObjectScope(.container)

        container.register(HealthManagerProtocol.self) { _ in
            HealthManager()
        }.inObjectScope(.container)

        container.register(NotificationManager.self) { _ in
            NotificationManager()
        }.inObjectScope(.container)
    }
}
