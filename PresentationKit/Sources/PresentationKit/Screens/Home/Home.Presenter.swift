//
//  HomeViewModel.swift
//
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//

import Foundation
import LoggingService
import PresentationInterface
import DayServiceInterface
import DrinkServiceInterface
import UnitServiceInterface

extension Screen.Home {
    public final class Presenter: HomePresenterType {
        public typealias ViewModel = Home.ViewModel
        public typealias Engine = (
            HasLoggingService &
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
        
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE - dd MMM"
            return formatter
        }()
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
            viewModel = ViewModel(dateTitle: formatter.string(from: .now),
                                  consumption: 0,
                                  goal: 0,
                                  smallUnit: .milliliters,
                                  largeUnit: .liters,
                                  drinks: [])
        }
        
        public func perform(action: Home.Action) async {
            switch action {
            case .didAppear:
                await sync(didComplete: nil)
            case .didTapHistory:
                router.showHistory()
            case .didTapSettings:
                router.showSettings()
            case let .didTapAddDrink(drink):
                do {
                    let consumption = try await engine.dayService.add(drink: .init(from: drink))
                    await updateViewModel(consumption: consumption)
                } catch {
                    engine.logger.error("Could not add drink of size \(drink.size)", error: error)
                }
            case let .didTapEditDrink(drink):
                router.showEdit(drink: drink)
            case let .didTapRemoveDrink(drink):
                do {
                    let consumption = try await engine.dayService.remove(drink: .init(from: drink))
                    await updateViewModel(consumption: consumption)
                } catch {
                    engine.logger.error("Could not remove drink of size \(drink.size)", error: error)
                }
            }
        }
        
        private func sync(didComplete: (() -> Void)?) async {
            let today = await engine.dayService.getToday()
            await updateViewModel(
                date: today.date,
                consumption: today.consumed,
                goal: today.goal
            )
            didComplete?()
        }
        
        public func sync(didComplete: (() -> Void)?) {
            Task {
                await sync(didComplete: didComplete)
            }
        }
    }
}

extension Screen.Home.Presenter {
    private func updateViewModel(
        date: Date? = nil,
        consumption: Double? = nil,
        goal: Double? = nil
    ) async {
        let currentSystem = engine.unitService.getUnitSystem()
        let isMetric = currentSystem == .metric
        let title = if let date {
            formatter.string(from: date)
        } else {
            viewModel.dateTitle
        }
        var consumption = consumption ?? viewModel.consumption
        var goal = goal ?? viewModel.goal
        var drinks: [ViewModel.Drink] = await getDrinks().map { .init(from: $0) }
        
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
            dateTitle: title,
            consumption: consumption,
            goal: goal,
            smallUnit: isMetric ? .milliliters : .imperialFluidOunces,
            largeUnit: isMetric ? .liters : .imperialPints,
            drinks: drinks
        )
    }
}

extension Screen.Home.Presenter {
    private func getDrinks() async -> [Drink] {
        if let drinks = try? await engine.drinksService.getSaved(),
           !drinks.isEmpty {
            return drinks
        } else {
            return await engine.drinksService.resetToDefault()
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
