//
//  HomeViewObservable.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import HomePresentationInterface
import PresentationKit
import EngineKit

final class HomeScreenObservable: ObservableObject, HomeSceneType {
    private let presenter: HomePresenterType

    @Published var date: Date
    @Published var consumed: Double
    @Published var goal: Double
    @Published var drinks: [Home.ViewModel.Drink]
    @Published var unit: (small: UnitVolume, large: UnitVolume)

    init(presenter: HomePresenterType,
         date: Date,
         consumed: Double,
         goal: Double,
         drinks: [Home.ViewModel.Drink],
         unit: (small: UnitVolume, large: UnitVolume)) {
        self.presenter = presenter
        self.date = date
        self.consumed = consumed
        self.goal = goal
        self.drinks = drinks
        self.unit = unit
        perform(action: .didAppear)
    }

    func perform(update: Home.Update) {
        switch update {
        case let .setToday(consumption, goal, date):
            self.consumed = consumption
            self.goal = goal
            self.date = date
        case let .setDate(date):
            self.date = date
        case let .setConsumption(consumed):
            self.consumed = consumed
        case let .setGoal(goal):
            self.goal = goal
        case let .setUnit(small, large):
            unit = (small, large)
        case let .setDrink(newDrink):
            drinks = drinks.map { $0.id == newDrink.id ? newDrink : $0}
        }
    }

    func perform(action: Home.Action) {
        presenter.perform(action: action)
    }
}

extension HomeScreenObservable {
    static let mock = HomeScreenObservable(
        presenter: Screen.Home.Presenter(engine: Engine(), router: Router()),
        date: .now,
        consumed: 0.200,
        goal: 3.2,
        drinks: [
            .init(size: 300, container: .small),
            .init(size: 500, container: .medium),
            .init(size: 750, container: .large)
        ],
        unit: (small: .milliliters, large: .liters)
    )
}
