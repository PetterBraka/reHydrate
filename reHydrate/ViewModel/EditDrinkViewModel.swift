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

    @Preference(\.smallDrink) private var smallDrink
    @Preference(\.mediumDrink) private var mediumDrink
    @Preference(\.largeDrink) private var largeDrink
    @Preference(\.isUsingMetric) private var isMetric

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

        let max = Double(drink.type.getMax())
        let level = Double(drink.size) / max
        fillLevel = level
        setupSubscribers()
    }

    func setupSubscribers() {
        $fillLevel
            .sink { [weak self] fill in
                guard var drink = self?.selectedDrink else { return }
                let max = drink.type.getMax()
                var size: Double
                size = Double(max) * Double(fill)
                drink.size = size.rounded()
                self?.selectedDrink.size = size.rounded()
                self?.fillLabel = "\(Int(size))ml"
            }.store(in: &tasks)
    }

    func select(_ drink: Drink) {
        let max = drink.type.getMax()
        selectedDrink = drink
        fillLevel = CGFloat(drink.size / Double(max))
    }

    func saveDrink() {
        let drinkSize = Measurement(value: selectedDrink.size, unit: UnitVolume.milliliters)
        let drinkValue = drinkSize.converted(to: isMetric ? .milliliters : .imperialPints).value
        switch selectedDrink.type {
        case .small:
            smallDrink = drinkValue
        case .medium:
            mediumDrink = drinkValue
        case .large:
            largeDrink = drinkValue
        }
        NotificationCenter.default.post(name: .savedDrink, object: selectedDrink)
    }
}
