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
        container.register(AppViewModel.self) { _ in
            AppViewModel()
        }
    }
}
