//
//  HomeViewObservable.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import UserNotifications
import HomePresentationInterface
import PresentationKit
import EngineKit

final class HomeScreenObservable: ObservableObject, HomeSceneType {
    private let presenter: HomePresenterType
    
    var viewModel: Home.ViewModel

    init(presenter: HomePresenterType) {
        self.presenter = presenter
        self.viewModel = presenter.viewModel
    }

    func perform(update: Home.Update) {
        switch update {
        case .viewModel:
            self.viewModel = presenter.viewModel
        }
        DispatchQueue.main.async { [weak self] in
            self?.objectWillChange.send()
        }
    }

    func perform(action: Home.Action) {
        Task {
            await presenter.perform(action: action)
        }
    }
}

extension HomeScreenObservable {
    static let mock = HomeScreenObservable(
        presenter: Screen.Home.Presenter(
            engine: Engine(reminders: [], celebrations: [],
                           notificationCenter: UNUserNotificationCenter.current()),
            router: Router())
    )
}
