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
import CommunicationKitInterface

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
            HasPhoneService
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
        }
        
        public func perform(action: Home.Action) async {
            switch action {
            case .didAppear, .didBecomeActive:
                await sync(didComplete: nil)
            case .didBackground:
                await sendAppContextToWatch()
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
                await sendComplicationDataToWatch()
            case let .didTapRemoveDrink(drink):
                await removeDrink(drink)
                await sendComplicationDataToWatch()
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
        let unitSystem = engine.unitService.getUnitSystem()
        let isMetric = unitSystem == .metric
        let smallUnit: UnitModel = isMetric ? .millilitres : .ounces
        let largeUnit: UnitModel = isMetric ? .litres : .pint
        
        let title = if let date {
            formatter.string(from: date)
        } else {
            viewModel.dateTitle
        }
        
        let localConsumption: Double
        if let consumption {
            localConsumption = engine.unitService.convert(consumption, from: .litres, to: largeUnit)
        } else {
            localConsumption = viewModel.consumption
        }
        
        let localGoal: Double
        if let goal {
            localGoal = engine.unitService.convert(goal, from: .litres, to: largeUnit)
        } else {
            localGoal = viewModel.goal
        }
        
        let localDrinks: [ViewModel.Drink] = await getDrinks().compactMap {
            guard let container = ViewModel.Container(from: $0.container) else { return nil }
            let max: Double = switch $0.container {
            case .small: 400.0
            case .medium: 700.0
            case .large: 1200.0
            case .health: 1
            }
            let localMax = engine.unitService.convert(max, from: .millilitres, to: smallUnit)
            let localSize = engine.unitService.convert($0.size, from: .millilitres, to: smallUnit)
            return ViewModel.Drink(
                id: $0.id,
                size: localSize,
                fill: localSize / localMax,
                container: container
            )
        }
        
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

// MARK: - Phone communication
private extension Screen.Home.Presenter {
    func getPhoneData() async -> [CommunicationUserInfo: Any] {
        await [
            .day: engine.dayService.getToday(),
            .drinks: getDrinks(),
            .unitSystem: engine.unitService.getUnitSystem()
        ]
    }
    
    func sendMessageToWatch() async {
        guard engine.phoneService.isSupported(),
              engine.phoneService.isReachable
        else { return }
        
        let message = await getPhoneData()
        engine.phoneService.send(message: message) { [weak self] error in
            self?.engine.logger.error("Failed sending \(message) to watchOS device", error: error)
        }
    }
    
    func sendComplicationDataToWatch() async {
        guard engine.phoneService.isSupported(),
              engine.phoneService.currentState == .activated
        else { return }
        if engine.phoneService.remainingComplicationUserInfoTransfers > 0 {
            let context = await getPhoneData()
            _ = engine.phoneService.transferComplication(userInfo: context)
        } else {
            await sendAppContextToWatch()
        }
    }
    
    func sendAppContextToWatch() async {
        guard engine.phoneService.isSupported(),
              engine.phoneService.currentState == .activated
        else { return }
        let context = await getPhoneData()
        do {
            try engine.phoneService.update(applicationContext: context)
        } catch {
            engine.logger.error("Failed updating context \(context) to watchOS device", error: error)
        }
    }
}

// MARK: Watch communication
private extension Screen.Home.Presenter {
    
}
