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
import PortsInterface
import UnitServiceInterface
import DateServiceInterface

extension Screen.Home {
    public final class Presenter: HomePresenterType {
        public typealias ViewModel = Home.ViewModel
        public typealias Engine = (
            HasLoggingService &
            HasDayService &
            HasDrinksService &
            HasHealthService &
            HasUnitService &
            HasDateService
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
                await addDrink(drink)
            case let .didTapEditDrink(drink):
                router.showEdit(drink: drink)
            case let .didTapRemoveDrink(drink):
                await removeDrink(drink)
            }
        }
        
        private func sync(didComplete: (() -> Void)?) async {
            var today = await engine.dayService.getToday()
            
            await syncDayWithHealth(&today)
            
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
        var drinks: [ViewModel.Drink] = await getDrinks().compactMap { .init(from: $0) }
        
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

// MARK: - Drinks
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

private extension Screen.Home.Presenter.ViewModel.Drink {
    init?(from drink: Drink) {
        guard let container = Screen.Home.Presenter.ViewModel.Container(from: drink.container)
        else { return nil }
        self = .init(id: drink.id,
                     size: drink.size,
                     container: container)
    }
}

private extension Screen.Home.Presenter.ViewModel.Container {
    init?(from container: Container) {
        switch container {
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        case .health:
            return nil
        }
    }
}

// MARK: - Update consumption
private extension Screen.Home.Presenter {
    func addDrink(_ drink: ViewModel.Drink) async {
        do {
            let consumption = try await engine.dayService.add(drink: .init(from: drink))
            let diff = consumption - viewModel.consumption
            await exportToHealth(consumed: diff)
            await updateViewModel(consumption: consumption)
        } catch {
            engine.logger.error("Could not add drink of size \(drink.size)", error: error)
        }
    }
    
    func removeDrink(_ drink: ViewModel.Drink) async {
        do {
            let consumption = try await engine.dayService.remove(drink: .init(from: drink))
            let diff = consumption - viewModel.consumption
            await exportToHealth(consumed: diff)
            await updateViewModel(consumption: consumption)
        } catch {
            engine.logger.error("Could not remove drink of size \(drink.size)", error: error)
        }
    }
}

// MARK: - Health
private extension Screen.Home.Presenter {
    func requestHealthAccessIfNeeded() async {
        let healthData = [HealthDataType.water(.litre)]
        guard await engine.healthService.shouldRequestAccess(for: healthData)
        else { return }
        do {
            try await engine.healthService.requestAuth(toReadAndWrite: Set(healthData))
        } catch {
            engine.logger.error("Could get access to health", error: error)
        }
    }
    
    func syncDayWithHealth(_ day: inout Day) async {
        guard engine.healthService.isSupported else { return }
        await requestHealthAccessIfNeeded()
        let healthTotal = await getHealthTotal()
        let diff = healthTotal - day.consumed
        if diff > 0 {
            let unitSystem = engine.unitService.getUnitSystem()
            let size = engine.unitService.convert(
                diff,
                from: .litres,
                to: unitSystem == .metric ? .millilitres : .ounces)
            let drink = Drink(id: UUID().uuidString, size: size, container: .health)
            if let updatedDay = try? await engine.dayService.add(drink: drink) {
                day.consumed = updatedDay
            }
        } else {
            await exportToHealth(consumed: -diff)
        }
    }
    
    func exportToHealth(consumed: Double) async {
        let unitSystem = engine.unitService.getUnitSystem()
        let litres = engine.unitService.convert(
            consumed,
            from: unitSystem == .metric ? .litres : .pint,
            to: .litres
        )
        do {
            try await engine.healthService.export(quantity: .init(unit: .litre, value: litres),
                                                  id: .dietaryWater, date: .now)
        } catch {
            engine.logger.error("Could not export to health \(litres)", error: error)
        }
    }
    
    func getHealthTotal() async -> Double {
        do {
            let start = engine.dateService.getStart(of: .now)
            let end = engine.dateService.getEnd(of: .now)
            let sum = try await engine.healthService.readSum(
                .water(.litre), start: start, end: end,
                intervalComponents: .init(day: 1)
            )
            let unitSystem = engine.unitService.getUnitSystem()
            return engine.unitService.convert(
                sum,
                from: .litres,
                to: unitSystem == .metric ? .litres : .pint
            )
        } catch {
            engine.logger.error("Couldn't get health data", error: error)
            return 0
        }
    }
}
