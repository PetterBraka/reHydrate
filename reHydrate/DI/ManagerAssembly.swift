//
//  ManagerAssembly.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import Swinject

class ManagerAssembly: Assembly {
    func assemble(container: Container) {
        // Presistence - Manager
        container.register(PresistenceControllerProtocol.self) { _ in
            PresistenceController()
        }.inObjectScope(.container)

        container.register(HealthManagerProtocol.self) { _ in
            HealthManager()
        }.inObjectScope(.container)

        container.register(NotificationManager.self) {_ in
            NotificationManager()
        }.inObjectScope(.container)
    }
}
