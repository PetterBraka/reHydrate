//
//  HomeScreenType.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//

import Foundation
import WatchEngineKit
import LoggingService
import PresentationWatchInterface
import DrinkServiceInterface
import UnitServiceInterface
import DayServiceInterface
import WatchCommsInterface
import DateServiceInterface

extension Screen.Home {
    public final class Presenter: HomePresenterType {
        public typealias ViewModel = Home.ViewModel
        public typealias Engine = (
            HasLoggingService &
            HasUnitService &
            HasDayService &
            HasDrinksService &
            HasDateService &
            HasWatchComms
        )
        
        private let engine: Engine
        private let formatter: DateFormatter
        private let notificationCenter: NotificationCenter
        
        public weak var scene: HomeSceneType?
        public private(set) var viewModel: ViewModel {
            didSet { scene?.perform(update: .viewModel) }
        }
        
        public init(engine: Engine, formatter: DateFormatter, notificationCenter: NotificationCenter) {
            self.engine = engine
            self.formatter = formatter
            self.notificationCenter = notificationCenter
            viewModel = ViewModel(consumption: 0, goal: 0, unit: .liters, drinks: [])
            
            updateViewModel(
                unit: getUnit().mapToDomain()
            )
            engine.watchComms.addObserver { [weak self] in
                self?.sync(didComplete: nil)
            }
        }
        
        deinit {
            engine.watchComms.removeObserver()
        }
        
        public func perform(action: Home.Action) async {
            switch action {
            case .didAppear:
                await sync()
            case let .didTapAddDrink(container):
                guard let drink = viewModel.drinks.first(where: { $0.container == container })
                else { return }
                await add(drink: drink)
                await engine.watchComms.sendDataToPhone()
            }
        }
        
        public func sync(didComplete: (() -> Void)?) {
            Task {
                await sync()
                didComplete?()
            }
        }
        
        private func sync() async {
            let unit = getUnit()
            let today = await engine.dayService.getToday()
            let drinks = await getDrinks()
            updateViewModel(
                consumption: engine.unitService.convert(today.consumed, from: .litres, to: unit),
                goal: engine.unitService.convert(today.goal, from: .litres, to: unit),
                unit: unit.mapToDomain(),
                drinks: getDrinks(from: drinks)
            )
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
    func getUnit() -> UnitModel {
        let unitSystem = engine.unitService.getUnitSystem()
        return unitSystem == .metric ? .litres : .pint
    }
}

private extension UnitModel {
    func mapToDomain() -> UnitVolume {
        switch self {
        case .ounces:.imperialFluidOunces
        case .pint: .imperialPints
        case .litres: .liters
        case .millilitres: .milliliters
        }
    }
}

// MARK: Day
private extension Screen.Home.Presenter {
    func add(drink: Home.ViewModel.Drink) async {
        do {
            let consumed = try await engine.dayService.add(drink: .init(from: drink))
            let unit = getUnit()
            updateViewModel(
                consumption: consumed,
                unit: unit.mapToDomain()
            )
        } catch {
            engine.logger.error("Could add drink of size \(drink.size)", error: error)
        }
    }
}

// MARK: Drink
private extension Screen.Home.Presenter {
    func getDrinks() async -> [Drink] {
        var drinks = (try? await engine.drinksService.getSaved()) ?? []
        if drinks.isEmpty {
            drinks = await engine.drinksService.resetToDefault()
        }
        return drinks
    }
    
    func getDrinks(from drinks: [Drink]) -> [Home.ViewModel.Drink] {
        let unitSystem = engine.unitService.getUnitSystem()
        let unitModel: UnitModel = unitSystem == .metric ? .millilitres : .ounces
        return drinks.compactMap { drink in
            guard let container = Home.ViewModel.Container(from: drink.container) else { return nil }
            return Home.ViewModel.Drink(
                id: drink.id,
                size: engine.unitService.convert(drink.size, from: .millilitres, to: unitModel),
                container: container
            )
        }
    }
}

private extension Home.ViewModel.Container {
    init?(from container: Container) {
        switch container {
        case .large:  self = .large
        case .medium: self = .medium
        case .small: self = .small
        case .health: return nil
        }
    }
}

private extension Drink {
    init(from drink: Home.ViewModel.Drink) {
        self.init(id: drink.id, size: drink.size, container: Container(from: drink.container))
    }
}

private extension Container {
    init(from container: Home.ViewModel.Container) {
        switch container {
        case .large: self = .large
        case .medium: self = .medium
        case .small: self = .small
        }
    }
}
