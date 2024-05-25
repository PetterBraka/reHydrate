//
//  HomeScreenType.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//

import Foundation
import LoggingService
import PresentationWatchInterface
import DrinkServiceInterface
import UnitServiceInterface
import DayServiceInterface

extension Screen.Home {
    public final class Presenter: HomePresenterType {
        public typealias ViewModel = Home.ViewModel
        public typealias Engine = (
            HasLoggingService &
            HasUnitService &
            HasDayService &
            HasDrinksService
        )
        
        private let engine: Engine
        
        public weak var scene: HomeSceneType?
        public private(set) var viewModel: ViewModel {
            didSet { scene?.perform(update: .viewModel) }
        }
        
        let formatter: DateFormatter
        
        public init(engine: Engine, formatter: DateFormatter) {
            self.engine = engine
            self.formatter = formatter
            viewModel = ViewModel(consumption: 0, goal: 0, unit: .liters, drinks: [])
            
            let unit = getUnit()
            updateViewModel(unit: unit)
        }
        
        public func perform(action: Home.Action) async {
            switch action {
            case .didAppear:
                let unit = getUnit()
                let today = await getToday()
                let drinks = await getDrinks()
                updateViewModel(
                    consumption: today.consumed,
                    goal: today.goal,
                    unit: unit,
                    drinks: drinks
                )
            case .didTapAddDrink(let drink):
                print("didTapAddDrink \(drink.container.rawValue)")
            }
        }
        
        public func sync(didComplete: (() -> Void)?) {
            print("sync")
        }
    }
}

private extension Screen.Home.Presenter {
    func updateViewModel(
        consumption: Double? = nil,
        goal: Double? = nil,
        unit: UnitVolume? = nil,
        drinks: [Home.ViewModel.Drink]? = nil
    ) {
        viewModel = .init(
            consumption: consumption ?? viewModel.consumption,
            goal: goal ?? viewModel.goal,
            unit: unit ?? viewModel.unit,
            drinks: drinks ?? viewModel.drinks
        )
    }
}

// MARK: Units
private extension Screen.Home.Presenter {
    func getUnit() -> UnitVolume {
        let unitSystem = engine.unitService.getUnitSystem()
        return unitSystem == .metric ? .liters : .imperialPints
    }
}

// MARK: Day
private extension Screen.Home.Presenter {
    func getToday() async -> Day {
        await engine.dayService.getToday()
    }
}

// MARK: Drink
private extension Screen.Home.Presenter {
    func getDrinks() async -> [Home.ViewModel.Drink] {
        var drinks = (try? await engine.drinksService.getSaved()) ?? []
        if drinks.isEmpty {
            drinks = await engine.drinksService.resetToDefault()
        }
        return drinks.compactMap { drink in
            Home.ViewModel.Drink(from: drink)
        }
    }
}

private extension Home.ViewModel.Drink {
    init?(from drink: Drink) {
        guard let container = Home.ViewModel.Container(from: drink.container) else { return nil }
        self.init(
            id: drink.id,
            size: drink.size,
            container: container
        )
    }
}

private extension Home.ViewModel.Container {
    init?(from container: Container) {
        switch container {
        case .large: 
            self = .large
        case .medium:
            self = .medium
        case .small:
            self = .small
        case .health:
            return nil
        }
    }
}
