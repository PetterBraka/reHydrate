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
import PhoneCommsInterface
import UserPreferenceServiceInterface
import NotificationCenterServiceInterface

extension Screen.Home {
    public final class Presenter: HomePresenterType {
        public typealias ViewModel = Home.ViewModel
        public typealias Engine = (
            HasLoggingService &
            HasDayService &
            HasDrinksService &
            HasHealthService &
            HasUnitService &
            HasDateService &
            HasPhoneComms &
            HasUserPreferenceService &
            HasNotificationCenter
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
        
        private let formatter: DateFormatter
        
        public init(engine: Engine, router: Router, formatter: DateFormatter) {
            self.engine = engine
            self.router = router
            self.formatter = formatter
            viewModel = ViewModel(dateTitle: formatter.string(from: engine.dateService.now()),
                                  consumption: 0,
                                  goal: 0,
                                  smallUnit: .milliliters,
                                  largeUnit: .liters,
                                  drinks: [])
            
            engine.phoneComms.addObserver { [weak self] in
                self?.dayDidChange()
            }
            engine.notificationCenter.addObserver(self, name: .dayDidChange, selector: #selector(dayDidChange), object: nil)
            engine.notificationCenter.addObserver(self, name: .drinkDidChange, selector: #selector(drinkDidChange), object: nil)
        }
        
        deinit {
            engine.phoneComms.removeObserver()
            engine.notificationCenter.removeObserver(self, name: .dayDidChange)
            engine.notificationCenter.removeObserver(self, name: .drinkDidChange)
        }
        
        public func perform(action: Home.Action) async {
            switch action {
            case .didAppear, .didBecomeActive:
                var today = await engine.dayService.getToday()
                await syncDayWithHealth(&today)
                let drinks = await getDrinks()
                
                await updateViewModel(
                    date: today.date,
                    consumption: today.consumed,
                    goal: today.goal,
                    drinks: drinks
                )
            case .didBackground:
                await engine.phoneComms.sendDataToWatch()
                await setWidgetData()
            case .didTapHistory:
                router.showHistory()
            case .didTapSettings:
                router.showSettings()
            case let .didTapEditDrink(drink):
                let unitSystem = engine.unitService.getUnitSystem()
                let isMetric = unitSystem == .metric
                let smallUnit: UnitModel = isMetric ? .millilitres : .ounces
                
                let max: Double = switch drink.container {
                case .small: 400.0
                case .medium: 700.0
                case .large: 1200.0
                }
                
                let localMax = engine.unitService.convert(max, from: smallUnit, to: .millilitres)
                let localSize = engine.unitService.convert(drink.size, from: smallUnit, to: .millilitres)
                
                router.showEdit(drink: .init(
                    id: drink.id,
                    size: localSize,
                    fill: localSize / localMax,
                    container: drink.container
                ))
            case let .didTapAddDrink(drink):
                await addDrink(drink)
                await engine.phoneComms.sendDataToWatch()
            case let .didTapRemoveDrink(drink):
                await removeDrink(drink)
                await engine.phoneComms.sendDataToWatch()
            }
        }
        
        @objc
        private func dayDidChange() {
            Task.detached { [weak self] in
                guard let self else { return }
                var today = await engine.dayService.getToday()
                await syncDayWithHealth(&today)
                
                await updateViewModel(
                    date: today.date,
                    consumption: today.consumed,
                    goal: today.goal
                )
            }
        }
        
        @objc
        private func drinkDidChange() {
            Task.detached { [weak self] in
                guard let self else { return }
                let drinks = await getDrinks()
                await updateViewModel(drinks: drinks)
            }
        }
    }
}

extension Screen.Home.Presenter {
    private func updateViewModel(
        date: Date? = nil,
        consumption: Double? = nil,
        goal: Double? = nil,
        drinks: [ViewModel.Drink]? = nil
    ) async {
        let unitSystem = engine.unitService.getUnitSystem()
        let isMetric = unitSystem == .metric
        
        let title = if let date {
            formatter.string(from: date)
        } else {
            viewModel.dateTitle
        }
        
        let localConsumption = consumption ?? viewModel.consumption
        let localGoal = goal ?? viewModel.goal
        let localDrinks = drinks ?? viewModel.drinks
        
        viewModel = ViewModel(
            dateTitle: title,
            consumption: localConsumption,
            goal: localGoal,
            smallUnit: isMetric ? .milliliters : .imperialFluidOunces,
            largeUnit: isMetric ? .liters : .imperialPints,
            drinks: localDrinks
        )
    }
}

// MARK: - Drinks
extension Screen.Home.Presenter {
    private func getDrinks() async -> [ViewModel.Drink] {
        let drinks = if let savedDrinks = try? await engine.drinksService.getSaved(), !savedDrinks.isEmpty {
            savedDrinks
        } else {
            await engine.drinksService.resetToDefault()
        }
        
        let unitSystem = engine.unitService.getUnitSystem()
        let smallUnit = unitSystem == .metric ? UnitModel.millilitres : .ounces
        
        return drinks.compactMap { [weak self] drink -> ViewModel.Drink? in
            guard let self, let container = ViewModel.Container(from: drink.container) else { return nil }
            let max: Double = switch drink.container {
            case .small: 400.0
            case .medium: 700.0
            case .large: 1200.0
            case .health: 1
            }
            let localSize = engine.unitService.convert(drink.size, from: .millilitres, to: smallUnit)
            return ViewModel.Drink(
                id: drink.id,
                size: localSize,
                fill: drink.size / max,
                container: container
            )
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
    init?(from drink: Drink, fill: Double) {
        guard let container = Screen.Home.Presenter.ViewModel.Container(from: drink.container)
        else { return nil }
        self = .init(id: drink.id,
                     size: drink.size,
                     fill: fill,
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
            let drink = Drink(id: "health-\(UUID().uuidString)", size: size, container: .health)
            if let updatedDay = try? await engine.dayService.add(drink: drink) {
                day.consumed = updatedDay
            }
        } else {
            await exportToHealth(consumed: -diff)
        }
    }
    
    func exportToHealth(consumed: Double) async {
        guard consumed != 0 else { return }
        guard engine.healthService.isSupported  else { return }
        let unitSystem = engine.unitService.getUnitSystem()
        let litres = engine.unitService.convert(
            consumed,
            from: unitSystem == .metric ? .litres : .pint,
            to: .litres
        )
        do {
            try await engine.healthService.export(quantity: .init(unit: .litre, value: litres),
                                                  id: .dietaryWater,
                                                  date: engine.dateService.now())
        } catch {
            engine.logger.error("Could not export to health \(litres)", error: error)
        }
    }
    
    func getHealthTotal() async -> Double {
        do {
            let start = engine.dateService.getStart(of: engine.dateService.now())
            let end = engine.dateService.getEnd(of: engine.dateService.now())
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

// MARK: Widget data
private extension Screen.Home.Presenter {
    func setWidgetData() async {
        let today = await engine.dayService.getToday()
        let unitSystem = engine.unitService.getUnitSystem()
        
        let data = WidgetData(
            date: today.date,
            endOfDay: engine.dateService.getEnd(of: today.date),
            consumed: today.consumed,
            goal: today.goal,
            symbol: unitSystem == .metric ? UnitVolume.liters.symbol : UnitVolume.pints.symbol
        )
        do {
            try engine.userPreferenceService.set(data, for: "today-widget")
        } catch {
            engine.logger.error("Couldn't set widget data", error: error)
        }
    }
}

private struct WidgetData: Codable {
    let date: Date
    let endOfDay: Date
    let consumed: Double
    let goal: Double
    let symbol: String
}
