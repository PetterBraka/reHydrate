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
import UserNotifications

public final class SceneFactory: ObservableObject {
    public let engine = Engine(
        reminders: Reminder.all.map { .init(title: $0.title, body: $0.body) },
        celebrations: Celebration.all.map { .init(title: $0.title, body: $0.body) },
        notificationCenter: UNUserNotificationCenter.current(),
        notificationOptions: [.alert, .sound]
    )
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
        let observer = SettingsScreenObservable(
            presenter: presenter,
            language: engine.languageService.getSelectedLanguage(),
            languageOptions: engine.languageService.getLanguageOptions(),
            isDarkMode: true // TODO: Petter add dark mode
        )
        presenter.scene = observer

        return SettingsScreen(observer: observer)
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
