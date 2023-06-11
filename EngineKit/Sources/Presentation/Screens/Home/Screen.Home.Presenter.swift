//
//  HomeViewModel.swift
//
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//

import DayServiceInterface
import HomePresentationInterface

extension Screen.Home {
    public final class Presenter: HomePresenterType {
        public typealias Engine = (
            HasConsumptionService
        )
        public typealias Router = (
            HomeRoutable
        )
        
        private let engine: Engine
        private let router: Router
        
        public weak var scene: HomeSceneType?
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
        }
        
        public func perform(action: Home.Action) {
            switch action {
            case .didTapHistory:
                router.showHistory()
            case .didTapSettings:
                router.showSettings()
            case let .didTapAddDrink(drink):
                let consumption = engine.consumptionService.add(drink: .init(from: drink))
                scene?.perform(update: .setConsumption(consumption))
            case let .didTapEditDrink(drink):
                router.showEdit(drink: drink)
            case let .didTapRemoveDrink(drink):
                let consumption = engine.consumptionService.remove(drink: .init(from: drink))
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
