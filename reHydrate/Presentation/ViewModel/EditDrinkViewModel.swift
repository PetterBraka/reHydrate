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
    @Published var selectedDrink: Drink
    @Published var fillLabel: String = "ml"
    @Published var minFill: CGFloat
    @Published var maxFill: CGFloat
    var emptySpace: CGFloat

    private let settingsRepository: SettingsRepository = MainAssembler.resolve()
    var isMetric: Bool { settingsRepository.isMetric }
    var smallDrink: Double { settingsRepository.smallDrink }
    var mediumDrink: Double { settingsRepository.mediumDrink }
    var largeDrink: Double { settingsRepository.largeDrink }

    var tasks = Set<AnyCancellable>()

    init(drink: Drink) {
        selectedDrink = drink
        minFill = 0.2
        maxFill = 1
        fillLevel = 0.5

        switch drink.type {
        case .small:
            emptySpace = 25
        case .medium, .large:
            emptySpace = 75
        }

        let max = Double(drink.type.max)
        let level = Double(drink.size) / max
        fillLevel = level
        setupSubscribers()
    }

    func setupSubscribers() {
        $fillLevel
            .sink { [weak self] fill in
                guard let drink = self?.selectedDrink,
                      let isMetric = self?.isMetric else { return }
                let max = drink.type.max
                var size: Double
                size = Double(max) * Double(fill)
                var drinkValue = size.convert(
                    to: isMetric ? .milliliters : .imperialPints,
                    from: .milliliters
                )
                if isMetric {
                    drinkValue.round()
                }
                self?.selectedDrink.size = drinkValue
                self?.fillLabel = drinkValue.clean + (isMetric ? "ml" : "pt")
            }.store(in: &tasks)
    }

    func select(_ drink: Drink) {
        let max = drink.type.max
        selectedDrink = drink
        fillLevel = CGFloat(drink.size / Double(max))
    }

    func saveDrink() {
        let drinkValue = selectedDrink.size.convert(
            to: .milliliters,
            from: isMetric ? .milliliters : .imperialPints
        )
        switch selectedDrink.type {
        case .small:
            settingsRepository.smallDrink = drinkValue
        case .medium:
            settingsRepository.mediumDrink = drinkValue
        case .large:
            settingsRepository.largeDrink = drinkValue
        }
        NotificationCenter.default.post(name: .savedDrink, object: drinkValue)
    }
}
