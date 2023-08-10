//
//  HomeViewModel.swift
//
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//

import DayServiceInterface
import DrinkServiceInterface
import HomePresentationInterface

extension Screen.Home {
    public final class Presenter: HomePresenterType {
        public typealias Engine = (
            HasDayService
        )
        public typealias Router = (
            HomeRoutable &
            HistoryRoutable &
            SettingsRoutable
        )
        
        private let engine: Engine
        private let router: Router
        
        public weak var scene: HomeSceneType?
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
        }
        
        @MainActor
        public func perform(action: Home.Action) {
            switch action {
            case .didAppear:
                Task(priority: .high) {
                    let today = await engine.dayService.getToday()
                    scene?.perform(update: .setToday(consumption: today.consumed,
                                                     goal: today.goal,
                                                     date: today.date))
                }
            case .didTapHistory:
                router.showHistory()
            case .didTapSettings:
                router.showSettings()
            case let .didTapAddDrink(drink):
                let consumption = engine.dayService.add(drink: .init(from: drink))
                scene?.perform(update: .setConsumption(consumption))
            case let .didTapEditDrink(drink):
                router.showEdit(drink: drink)
            case let .didTapRemoveDrink(drink):
                let consumption = engine.dayService.remove(drink: .init(from: drink))
                scene?.perform(update: .setConsumption(consumption))
            }
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
