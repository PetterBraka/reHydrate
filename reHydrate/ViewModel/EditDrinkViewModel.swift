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

    @Preference(\.smallDrink) private var smallDrink
    @Preference(\.mediumDrink) private var mediumDrink
    @Preference(\.largeDrink) private var largeDrink
    @Preference(\.isUsingMetric) private var isMetric

    var tasks = Set<AnyCancellable>()

    init(drink: Drink) {
        selectedDrink = drink
        minFill = 0.2
        maxFill = 0.75
        fillLevel = 0.5

        guard let max = drink.type?.getMax() else { return }
        fillLevel = Double(drink.size) / Double(max)
        setupSubscribers()
    }

    func setupSubscribers() {
        $fillLevel
            .sink { [weak self] fill in
                guard var drink = self?.selectedDrink,
                      let max = drink.type?.getMax() else { return }
                let size = Double(max) * Double(fill)
                drink.size = size
                self?.selectedDrink.size = size
                self?.fillLabel = "\(Int(size))ml"
            }.store(in: &tasks)
    }

    func select(_ drink: Drink) {
        guard let max = drink.type?.getMax() else { return }
        selectedDrink = drink
        fillLevel = CGFloat(drink.size / Double(max))
    }

    func saveDrink() {
        let drinkSize = Measurement(value: smallDrink, unit: UnitVolume.milliliters)
        let drinkValue = drinkSize.converted(to: isMetric ? .milliliters : .imperialPints).value
        switch selectedDrink.type {
        case .small:
            smallDrink = drinkValue
        case .medium:
            mediumDrink = drinkValue
        case .large:
            largeDrink = drinkValue
        default:
            break
        }
    }
}
