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
        container.register(LegacyHomeViewModel.self) { _, state in
            LegacyHomeViewModel(navigateTo: state)
        }.inObjectScope(.container)

        // Calendar - ViewModel
        container.register(CalendarViewModel.self) { _, state in
            CalendarViewModel(navigateTo: state)
        }.inObjectScope(.container)

        // Settings - ViewModel
        container.register(SettingsViewModel.self) { _, state in
            SettingsViewModel(navigateTo: state)
        }.inObjectScope(.container)
    }
}
