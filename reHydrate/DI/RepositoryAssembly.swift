//
//  RepositoryAssembly.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Swinject

class RepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SettingsRepository.self) { _ in
            SettingsRepository()
        }.inObjectScope(.container)
    }
}
