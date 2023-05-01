//
//  RepositoryAssembly.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import CoreInterfaceKit
import Swinject

class RepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SettingsRepository.self) { _ in
            SettingsRepository()
        }.inObjectScope(.container)

        container.register(DayRepository.self) { resolver in
            DayRepository(service: resolver.resolve(DayService.self)!)
        }.inObjectScope(.container)

        if #available(iOS 16.4, *) {
            container.register(DrinkRepository.self) { resolver in
                DrinkRepository(service: resolver.resolve(DrinkService.self)!)
            }.inObjectScope(.container)
        }
    }
}
