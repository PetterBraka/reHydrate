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
import UIKit

public final class SceneFactory: ObservableObject {
    public let engine: Engine
    public let router = Router()
    
    // Root presenters
    private lazy var homePresenter = Screen.Home.Presenter(engine: engine, router: router)
    private lazy var settingsPresenter = Screen.Settings.Presenter(engine: engine, router: router)
    
    // Port
    let notificationDelegate: NotificationDelegatePort
    
    init() {
        engine = Engine(
            appVersion: UIApplication.shared.appVersion,
            reminders: Reminder.all.map { .init(title: $0.title, body: $0.body) },
            celebrations: Celebration.all.map { .init(title: $0.title, body: $0.body) },
            notificationCenter: UNUserNotificationCenter.current(),
            openUrlService: OpenUrlPort(),
            alternateIconsService: AlternateIconsServicePort(), 
            appearancePort: AppearanceServicePort()
        )
        notificationDelegate = NotificationDelegatePort(engine: engine)
        engine.didCompleteNotificationAction = { [weak self] in
            self?.homePresenter.sync(didComplete: nil)
        }
    }
    
    func makeHomeScreen() -> HomeScreen {
        let observer = HomeScreenObservable(presenter: homePresenter)
        homePresenter.scene = observer
        
        return HomeScreen(observer: observer)
    }
    
    func makeSettingsScreen() -> SettingsScreen {
        let observer = SettingsScreenObservable(presenter: settingsPresenter)
        settingsPresenter.scene = observer

        return SettingsScreen(observer: observer)
    }
    
    func makeEditScreen(with drink: Home.ViewModel.Drink) -> EditContainerScreen {
        let presenter = Screen.EditContainer.Presenter(engine: engine,
                                                       router: router,
                                                       selectedDrink: .init(from: drink)) { [weak self] in
            self?.homePresenter.sync(didComplete: nil)
        }
        let observer = EditContainerScreenObservable(presenter: presenter)
        presenter.scene = observer
        
        return EditContainerScreen(observer: observer)
    }
    
    func makeCreditsScreen() -> CreditsScreen {
        let presenter = Screen.Settings.Credits.Presenter(engine: engine,
                                                       router: router)
        let observer = CreditsScreenObservable(presenter: presenter)
        presenter.scene = observer
        
        return CreditsScreen(observer: observer)
    }
    
    func makeAppIconScreen() -> AppIconScreen {
        let presenter = Screen.Settings.AppIcon.Presenter(engine: engine,
                                                          router: router)
        let observer = AppIconScreenObservable(presenter: presenter)
        presenter.scene = observer
        
        return AppIconScreen(observer: observer)
    }
}

extension Home.ViewModel.Drink {
    init(from drink: DrinkServiceInterface.Drink) {
        let container: Home.ViewModel.Container = switch drink.container {
        case .large: .large
        case .medium: .medium
        case .small: .small
        }

        self = .init(id: drink.id,
                     size: drink.size,
                     container: container)
    }
}

extension Drink {
    init(from drink: Home.ViewModel.Drink) {
        let container: Container = switch drink.container {
        case .large: .large
        case .medium: .medium
        case .small: .small
        }

        self = .init(
            id: drink.id,
            size: drink.size,
            container: container
        )
    }
}
