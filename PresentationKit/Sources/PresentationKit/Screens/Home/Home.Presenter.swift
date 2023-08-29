//
//  HomeViewModel.swift
//
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//

import Foundation
import HomePresentationInterface
import DayServiceInterface
import DrinkServiceInterface
import UnitServiceInterface

extension Screen.Home {
    public final class Presenter: HomePresenterType {
        public typealias ViewModel = Home.ViewModel
        public typealias Engine = (
            HasDayService &
            HasDrinksService &
            HasUnitService
        )
        public typealias Router = (
            HomeRoutable &
            HistoryRoutable &
            SettingsRoutable
        )
        
        private let engine: Engine
        private let router: Router
        
        public weak var scene: HomeSceneType?
        public private(set) var viewModel: ViewModel {
            didSet { scene?.perform(update: .viewModel) }
        }
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
            viewModel = ViewModel(date: .now,
                                  consumption: 0,
                                  goal: 0,
                                  smallUnit: .milliliters,
                                  largeUnit: .liters,
                                  drinks: [])
        }
        
        @MainActor
        public func perform(action: Home.Action) async {
            switch action {
            case .didAppear:
                let today = await engine.dayService.getToday()
                updateViewModel(
                    date: today.date,
                    consumption: today.consumed,
                    goal: today.goal
                )
            case .didTapHistory:
                router.showHistory()
            case .didTapSettings:
                router.showSettings()
            case let .didTapAddDrink(drink):
                do {
                    let consumption = try await engine.dayService.add(drink: .init(from: drink))
                    updateViewModel(consumption: consumption)
                } catch {
                    // TODO: log this
                }
            case let .didTapEditDrink(drink):
                router.showEdit(drink: drink)
            case let .didTapRemoveDrink(drink):
                do {
                    let consumption = try await engine.dayService.remove(drink: .init(from: drink))
                    updateViewModel(consumption: consumption)
                } catch {
                    // TODO: log this
                }
            }
        }
    }
}

extension Screen.Home.Presenter {
    private func updateViewModel(
        date: Date? = nil,
        consumption: Double? = nil,
        goal: Double? = nil
    ) {
        let currentSystem = engine.unitService.getUnitSystem()
        let isMetric = currentSystem == .metric
        let date = date ?? viewModel.date
        var consumption = consumption ?? viewModel.consumption
        var goal = goal ?? viewModel.goal
        var drinks: [ViewModel.Drink] = getDrinks().map { .init(from: $0) }
        
        consumption = engine.unitService.convert(consumption,
                                                 from: .litres,
                                                 to: isMetric ? .litres : .pint)
        goal = engine.unitService.convert(goal,
                                          from: .litres,
                                          to: isMetric ? .litres : .pint)
        drinks = drinks.map { drink in
            var drink = drink
            drink.size = engine.unitService.convert(drink.size,
                                                    from: .millilitres,
                                                    to: isMetric ? .millilitres : .ounces)
            return drink
        }
        
        viewModel = ViewModel(
            date: date,
            consumption: consumption,
            goal: goal,
            smallUnit: isMetric ? .milliliters : .imperialFluidOunces,
            largeUnit: isMetric ? .liters : .imperialPints,
            drinks: drinks
        )
    }
}

extension Screen.Home.Presenter {
    private func getDrinks() -> [Drink] {
        let result = engine.drinksService.getSavedDrinks()
        if case .success(let foundDrinks) = result, !foundDrinks.isEmpty {
            return foundDrinks
        } else {
            return engine.drinksService.resetToDefault()
        }
    }
}

extension Drink {
    init(from drink: Home.ViewModel.Drink) {
        self = Drink(id: drink.id,
                     size: drink.size,
                     container: .init(from: drink.container))
    }
}

extension Container {
    init(from container: Home.ViewModel.Container) {
        switch container {
        case .large:
            self = .large
        case .medium:
            self = .medium
        case .small:
            self = .small
        }
    }
}

extension Screen.Home.Presenter.ViewModel.Drink {
    init(from drink: Drink) {
        self = .init(id: drink.id,
                     size: drink.size,
                     container: .init(from: drink.container))
    }
}

extension Screen.Home.Presenter.ViewModel.Container {
    init(from container: Container) {
        switch container {
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        }
    }
}
