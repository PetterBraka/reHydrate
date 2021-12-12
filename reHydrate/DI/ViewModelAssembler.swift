//
//  ViewModelAssembler.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import Swinject

final class ViewModelAssembler: Assembly {
    func assemble(container: Container) {

        // App - ViewModel
        container.register(AppViewModel.self) { _ in
            AppViewModel()
        }.inObjectScope(.container)

        // Home - ViewModel
        container.register(HomeViewModel.self) { resolver, state in
            HomeViewModel(presistenceController: resolver.resolve(PresistenceControllerProtocol.self)!,
                          navigateTo: state)
        }.inObjectScope(.container)

        // Calendar - ViewModel
        container.register(CalendarViewModel.self) { resolver, state in
            CalendarViewModel(presistenceController: resolver.resolve(PresistenceControllerProtocol.self)!,
                              navigateTo: state)
        }.inObjectScope(.container)

        // Settings - ViewModel
        container.register(SettingsViewModel.self) { reslover, state in
            SettingsViewModel(presistenceController: reslover.resolve(PresistenceControllerProtocol.self)!,
                              navigateTo: state)
        }.inObjectScope(.container)
    }
}
