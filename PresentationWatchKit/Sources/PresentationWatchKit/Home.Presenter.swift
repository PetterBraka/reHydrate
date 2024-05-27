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
import WatchCommunicationKitInterface

extension Screen.Home {
    public final class Presenter: HomePresenterType {
        public typealias ViewModel = Home.ViewModel
        public typealias Engine = (
            HasLoggingService &
            HasUnitService &
            HasDayService &
            HasDrinksService &
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
                sync(didComplete: nil)
            case let .didTapAddDrink(drink):
                await add(drink: drink)
                await sendUpdatedToday()
            }
        }
        
        public func sync(didComplete: (() -> Void)?) {
            Task {
                let unit = getUnit()
                let today = await getToday()
                let drinks = await getDrinks()
                updateViewModel(
                    consumption: engine.unitService.convert(today.consumed, from: .litres, to: unit),
                    goal: engine.unitService.convert(today.goal, from: .litres, to: unit),
                    unit: unit.mapToDomain(),
                    drinks: drinks
                )
                didComplete?()
            }
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
        case .pint: .pints
        case .litres: .liters
        case .millilitres: .milliliters
        }
    }
}

// MARK: Day
private extension Screen.Home.Presenter {
    func getToday() async -> Day {
        await engine.dayService.getToday()
    }
    
    func add(drink: Home.ViewModel.Drink) async {
        do {
            let consumed = try await engine.dayService.add(drink: .init(from: drink))
            let unit = getUnit()
            updateViewModel(
                consumption: engine.unitService.convert(consumed, from: .litres, to: unit),
                unit: unit.mapToDomain()
            )
        } catch {
            engine.logger.error("Could add drink of size \(drink.size)", error: error)
        }
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
        self.init(id: drink.id, size: drink.size, container: container)
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
        let watchService = engine.watchService
        guard watchService.isSupported(),
              watchService.currentState == .activated
        else { return }
        let today = await getToday()
        let message: [String: Any] = [
            "today": today
        ]
        watchService.send(message: message, replyHandler: nil) { [weak self] error in
            self?.engine.logger.error("Failed sending \(message) to iOS device", error: error)
        }
    }
}

// MARK: Phone communication
private extension Screen.Home.Presenter {
    func addObservers() {
        notificationCenter.addObserver(forName: .Watch.didReceiveApplicationContext, 
                                       object: self, queue: .current,
                                       using: didReceiveApplicationContextHandler)
        notificationCenter.addObserver(forName: .Watch.didReceiveMessage, 
                                       object: self, queue: .current,
                                       using: didReceiveMessageHandler)
        notificationCenter.addObserver(forName: .Watch.didReceiveMessageData, 
                                       object: self, queue: .current,
                                       using: didReceiveMessageDataHandler)
        notificationCenter.addObserver(forName: .Watch.didReceiveUserInfo, 
                                       object: self, queue: .current,
                                       using: didReceiveUserInfoHandler)
    }
    
    func removeObservers() {
        notificationCenter.removeObserver(self, name: .Watch.didReceiveApplicationContext, object: nil)
        notificationCenter.removeObserver(self, name: .Watch.didReceiveMessage, object: nil)
        notificationCenter.removeObserver(self, name: .Watch.didReceiveMessageData, object: nil)
        notificationCenter.removeObserver(self, name: .Watch.didReceiveUserInfo, object: nil)
    }
    
    func didReceiveApplicationContextHandler(_ notification: Notification) {}
    // This might have a response handle
    func didReceiveMessageHandler(_ notification: Notification) {}
    // This might have a response handle
    func didReceiveMessageDataHandler(_ notification: Notification) {}
    func didReceiveUserInfoHandler(_ notification: Notification) {}
}
