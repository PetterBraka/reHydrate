//
//  ServiceAssembly.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import CoreInterfaceKit
import Swinject

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DayService.self) { resolver in
            let persistenceController = resolver.resolve(PersistenceControllerProtocol.self)!
            let viewContext = persistenceController.container.viewContext
            return DayService(context: viewContext)
        }
    }
}
