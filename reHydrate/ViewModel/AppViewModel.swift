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
    case calender
}

final class AppViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var currenState: AppState = .home
    @Published var drinks = [Drink(type: .small, size: 250),
                             Drink(type: .medium, size: 500),
                             Drink(type: .large, size: 750)]
    @Published var today = DayRecord(date: Date(),
                                     consumed: 0,
                                     goal: 3)
    
    private func navigate(to state: AppState) {
        withAnimation {
            currenState = state
        }
    }
    
    func navigateTo(_ state: AppState) {
        navigate(to: state)
    }
}
