//
//  AppViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum AppState {
    case home
    case settings
    case calendar
}

final class AppViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()

    @Published var currenState: AppState = .home

    private func navigate(to state: AppState) {
        withAnimation {
            currenState = state
        }
    }

    func navigateTo(_ state: AppState) {
        navigate(to: state)
    }
}
