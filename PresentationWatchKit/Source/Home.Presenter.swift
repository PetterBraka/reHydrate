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
import CommunicationKitInterface
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
            HasWatchService
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
            addObservers()
        }
        
        deinit {
            removeObservers()
        }
        
        public func perform(action: Home.Action) async {
            switch action {
            case .didAppear:
                await sync()
            case let .didTapAddDrink(container):
                guard let drink = viewModel.drinks.first(where: { $0.container == container })
                else { return }
                await add(drink: drink)
                await sendUpdatedToday()
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

// MARK: Watch communication
private extension Screen.Home.Presenter {
    func sendUpdatedToday() async {
        guard engine.watchService.isSupported(),
              engine.watchService.currentState == .activated
        else { return }
        let today = await engine.dayService.getToday()
        let message: [CommunicationUserInfo: Codable] = [
            .day: today
        ]
        engine.watchService.send(message: message) { [weak self] error in
            self?.engine.logger.error("Failed sending \(message) to iOS device", error: error)
        }
    }
}

// MARK: Phone communication
private extension Screen.Home.Presenter {
    func addObservers() {
        notificationCenter.addObserver(forName: .Shared.didReceiveApplicationContext,
                                       object: nil, queue: .current,
                                       using: processPhone(notification:))
        notificationCenter.addObserver(forName: .Shared.didReceiveMessage,
                                       object: nil, queue: .current,
                                       using: processPhone(notification:))
        notificationCenter.addObserver(forName: .Shared.didReceiveUserInfo,
                                       object: nil, queue: .current,
                                       using: processPhone(notification:))
    }
    
    func removeObservers() {
        notificationCenter.removeObserver(self, name: .Shared.didReceiveApplicationContext, object: nil)
        notificationCenter.removeObserver(self, name: .Shared.didReceiveMessage, object: nil)
        notificationCenter.removeObserver(self, name: .Shared.didReceiveUserInfo, object: nil)
    }
    
    func processPhone(notification: Notification) {
        guard let phoneInfo = notification.userInfo?.mapKeys() else {
            notificationCenter.post(name: .init("NotificationProcessed"), object: self)
            return
        }
        Task {
            let unit = processUnit(fromPhoneInfo: phoneInfo)
            let today = await processDay(fromPhoneInfo: phoneInfo)
            let drinks = await processDrinks(fromPhoneInfo: phoneInfo)
            
            updateViewModel(
                consumption: engine.unitService.convert(today.consumed, from: .litres, to: unit),
                goal: engine.unitService.convert(today.goal, from: .litres, to: unit),
                unit: unit.mapToDomain(),
                drinks: getDrinks(from: drinks)
            )
            notificationCenter.post(name: .init("NotificationProcessed"), object: self)
        }
    }
    
    func processUnit(fromPhoneInfo phoneInfo: [CommunicationUserInfo: Any]) -> UnitModel {
        let unitSystem: UnitSystem
        if let data = phoneInfo[.unitSystem] as? Data,
           let phoneUnitSystem = try? JSONDecoder().decode(UnitSystem.self, from: data) {
            unitSystem = phoneUnitSystem
            engine.unitService.set(unitSystem: phoneUnitSystem)
        } else {
            unitSystem = engine.unitService.getUnitSystem()
        }
        return unitSystem == .metric ? .litres : .pint
    }
    
    func processDay(fromPhoneInfo phoneInfo: [CommunicationUserInfo: Any]) async -> Day {
        let watchToday = await engine.dayService.getToday()
        guard let data = phoneInfo[.day] as? Data,
              let phoneDay = try? JSONDecoder().decode(Day.self, from: data),
              engine.dateService.isDate(phoneDay.date, inSameDayAs: engine.dateService.now())
        else { return watchToday }
        
        let consumedDiff = phoneDay.consumed - watchToday.consumed
        let drink = Drink(id: "phone-message", size: abs(consumedDiff), container: .medium)
        if consumedDiff < 0 {
            _ = try? await engine.dayService.add(drink: drink)
        } else if consumedDiff > 0 {
            _ = try? await engine.dayService.remove(drink: drink)
        }
        
        let goalDiff = phoneDay.goal - watchToday.goal
        if goalDiff < 0 {
            _ = try? await engine.dayService.increase(goal: abs(goalDiff))
        } else if goalDiff > 0 {
            _ = try? await engine.dayService.decrease(goal: abs(goalDiff))
        }
        
        return await engine.dayService.getToday()
    }
    
    func processDrinks(fromPhoneInfo phoneInfo: [CommunicationUserInfo: Any]) async -> [Drink] {
        var processedDrinks = [Drink]()
        let watchDrinks = await getDrinks()
        
        guard let data = phoneInfo[.drinks] as? Data,
              let phoneDrinks = try? JSONDecoder().decode([Drink].self, from: data),
              phoneDrinks != watchDrinks
        else { return watchDrinks }
        
        for phoneDrink in phoneDrinks {
            if let drink = watchDrinks.first(where: { $0.container == phoneDrink.container }), drink.size == phoneDrink.size {
                processedDrinks.append(drink)
            } else if watchDrinks.contains(where: { $0.container == phoneDrink.container }),
                      let drink = try? await engine.drinksService.edit(size: phoneDrink.size, of: phoneDrink.container) {
                processedDrinks.append(drink)
            } else if let drink = try? await engine.drinksService.add(size: phoneDrink.size, container: phoneDrink.container) {
                processedDrinks.append(drink)
            }
        }
        return processedDrinks
    }
}

fileprivate extension Dictionary where Key == AnyHashable {
    func mapKeys() -> [CommunicationUserInfo: Value]{
        reduce(into: [CommunicationUserInfo: Value]()) { partialResult, element in
            guard let key = CommunicationUserInfo(rawValue: "\(element.key)") else { return }
            partialResult[key] = element.value
        }
    }
}
