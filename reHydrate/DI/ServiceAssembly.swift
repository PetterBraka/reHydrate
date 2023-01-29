//
//  ServiceAssembly.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Swinject

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DayServiceProtocol.self) { resolver in
            let presistenceController = resolver.resolve(PresistenceControllerProtocol.self)!
            let viewContext = presistenceController.container.viewContext
            return DayService(context: viewContext)
        }
    }
}
