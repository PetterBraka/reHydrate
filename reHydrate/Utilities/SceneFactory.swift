//
//  SceneFactory.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 11/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import EngineKit
import PresentationKit
import HomePresentationInterface
import DrinkServiceInterface

public final class SceneFactory: ObservableObject {
    public let engine = Engine()
    public let router = Router()
    
    init() {}
    
    func makeHomeScreen() -> HomeScreen {
        let presenter = Screen.Home.Presenter(engine: engine,
                                              router: router)
        let observer = HomeScreenObservable(presenter: presenter)
        presenter.scene = observer
        
        return HomeScreen(observer: observer)
    }
    
    func makeSettingsScreen() -> SettingsScreen {
        let presenter = Screen.Settings.Presenter(engine: engine,
                                                  router: router)
        let drinks = getDrinks()
        let observer = SettingsScreenObservable(
            presenter: presenter,
            viewModel: presenter.viewModel,
            language: engine.languageService.getSelectedLanguage(),
            languageOptions: engine.languageService.getLanguageOptions(),
            isDarkMode: true, // TODO: Petter add dark mode
            isRemindersOn: false, // TODO: Petter add Reminders
            remindersStart: .distantPast,
            remindersStartRange: Date.distantPast ... .distantFuture,
            remindersEnd: .distantFuture,
            remindersEndRange: Date.distantPast ... .distantFuture,
            reminderFrequency: 60,
            small: drinks[0],
            medium: drinks[1],
            large: drinks[2])
        presenter.scene = observer

        return SettingsScreen(observer: observer)
    }
}

private extension SceneFactory {
    func getDrinks() -> [Drink] {
        let result = engine.drinksService.getSavedDrinks()
        if case .success(let foundDrinks) = result, !foundDrinks.isEmpty {
            return foundDrinks
        } else {
            return engine.drinksService.resetToDefault()
        }
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
