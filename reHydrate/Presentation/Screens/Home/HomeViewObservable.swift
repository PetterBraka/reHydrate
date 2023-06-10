//
//  HomeViewObservable.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import HomePresentationInterface

final class HomeScreenObservable: ObservableObject, HomeSceneType {
    private weak var presenter: HomePresenterType?

    @Published var date: Date
    @Published var consumed: Double
    @Published var goal: Double
    @Published var drinks: [Drink]
    @Published var unit: (small: UnitVolume, large: UnitVolume)

    init(date: Date,
         consumed: Double,
         goal: Double,
         drinks: [Drink],
         unit: (small: UnitVolume, large: UnitVolume)) {
        self.date = date
        self.consumed = consumed
        self.goal = goal
        self.drinks = drinks
        self.unit = unit
    }

    func perform(_ update: Home.Update) {
        switch update {
        case let .setDate(date):
            self.date = date
        case let .setConsumption(consumed):
            self.consumed = consumed
        case let .setGoal(goal):
            self.goal = goal
        case let .setUnit(small, large):
            unit = (small, large)
        }
    }

    func perform(_ action: Home.Action) {
        presenter?.perform(action)
    }
}
