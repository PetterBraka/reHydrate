//
//  EditDrinkViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 13/03/2022.
//  Copyright © 2022 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import SwiftUI

class EditDrinkViewModel: ObservableObject {
    @Published var fillLevel: CGFloat
    @Published var drinkOptions: [Drink] = [
        Drink(type: .small, size: 300),
        Drink(type: .medium, size: 500),
        Drink(type: .large, size: 750)
    ]
    @Published var selectedDrink: Drink?
    @Published var fillLabel: String = "ml"
    @Published var minFill: CGFloat
    @Published var maxFill: CGFloat

    var tasks = Set<AnyCancellable>()

    init() {
        minFill = 0.2
        maxFill = 0.7
        fillLevel = 0.5
        setupSubscribers()
    }

    func setupSubscribers() {
        $fillLevel
            .sink { [weak self] fill in
                guard var drink = self?.selectedDrink,
                      let max = drink.type?.getMax() else { return }
                drink.size = CGFloat(max) * fill
                self?.selectedDrink?.size = CGFloat(max) * fill
                switch drink.type {
                case .small:
                    self?.drinkOptions[0] = drink
                case .medium:
                    self?.drinkOptions[1] = drink
                case .large:
                    self?.drinkOptions[2] = drink
                case .none:
                    break
                }
            }.store(in: &tasks)
    }

    func select(_ drink: Drink) {
        guard let max = drink.type?.getMax() else { return }
        selectedDrink = drink
        fillLevel = CGFloat(drink.size / Double(max))
    }
}
