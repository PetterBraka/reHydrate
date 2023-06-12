//
//  SceneFactory.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 11/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import EngineKit
import Presentation
import HomePresentationInterface
import DrinkServiceInterface

public final class SceneFactory {
    public static let shared = SceneFactory()
    
    private let engine = Engine()
    public let router = Router()
    
    init() {}
    
    func makeHomeScreen() -> HomeScreen {
        let presenter = Screen.Home.Presenter(engine: engine,
                                              router: router)
        var drinks: [DrinkServiceInterface.Drink]
        let result = engine.drinksService.getSavedDrinks()
        if case .success(let foundDrinks) = result, !foundDrinks.isEmpty {
            drinks = foundDrinks
        } else {
            drinks = engine.drinksService.resetToDefault()
        }
        
        let observer = HomeScreenObservable(presenter: presenter,
                                            date: .now, consumed: 0, goal: 3,
                                            drinks: drinks.map { .init(from: $0) },
                                            unit: (small: .milliliters, large: .liters))
        presenter.scene = observer
        
        return HomeScreen(observer: observer)
    }
}

extension Home.ViewModel.Drink {
    init(from drink: DrinkServiceInterface.Drink) {
        self = .init(id: drink.id,
                     size: drink.size,
                     container: .init(from: drink.container))
    }
}

extension Home.ViewModel.Container {
    init(from container: DrinkServiceInterface.Container) {
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
