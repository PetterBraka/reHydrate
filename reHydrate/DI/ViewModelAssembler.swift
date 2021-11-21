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
        }
        
        // Home - ViewModel
        container.register(HomeViewModel.self) { resolver, state in
            HomeViewModel(presistenceController: resolver.resolve(PresistenceControllerProtocol.self)!,
                          navigateTo: state)
        }
    }
}
