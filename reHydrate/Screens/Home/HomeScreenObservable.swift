//
//  HomeViewObservable.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import PresentationInterface
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
        Task { @MainActor [weak self] in
            self?.objectWillChange.send()
        }
    }
    
    func perform(action: Home.Action) async {
        await presenter.perform(action: action)
    }
    
    func perform(action: Home.Action) {
        Task {
            await perform(action: action)
        }
    }
}
