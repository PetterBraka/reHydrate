//
//  AppViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

enum AppState {
    case home
    case settings
    case calendar
}

final class AppViewModel: ObservableObject {
    private var tasks = Set<AnyCancellable>()

    @Published var currenState: AppState = .home
    @Published var showPopUp: Bool = true
    @Published var editingDrink: Drink? = Drink(type: .small, size: 400)

    init() {
        NotificationCenter.default.publisher(for: .editDrink)
            .sink { notification in
                guard let drink = notification.object as? Drink else { return }
                self.editingDrink = drink
                self.showPopUp = true
            }.store(in: &tasks)
    }

    private func navigate(to state: AppState) {
        withAnimation {
            currenState = state
        }
    }

    func navigateTo(_ state: AppState) {
        navigate(to: state)
    }
}
