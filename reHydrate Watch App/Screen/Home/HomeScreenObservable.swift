//
//  HomeScreenObservable.swift
//  reHydrate Watch App
//
//  Created by Petter vang Brakalsvålet on 25/05/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import PresentationWatchInterface
import PresentationWatchKit
import EngineKit

final class HomeScreenObservable: ObservableObject, HomeSceneType {
    private let presenter: HomePresenterType
    
    var viewModel: Home.ViewModel
    
    init(presenter: HomePresenterType) {
        self.presenter = presenter
        self.viewModel = presenter.viewModel
    }
    
    func perform(update: Home.Update) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch update {
            case .viewModel:
                self.viewModel = presenter.viewModel
            }
            self.objectWillChange.send()
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
