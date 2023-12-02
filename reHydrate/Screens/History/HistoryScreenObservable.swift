//
//  HistoryScreenObservable.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 28/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import HistoryPresentationInterface
import PresentationKit

final class HistoryScreenObservable: ObservableObject, HistorySceneType {
    public typealias ViewModel = History.ViewModel
    private let presenter: Screen.History.Presenter
    
    var viewModel: ViewModel
    
    init(presenter: Screen.History.Presenter) {
        self.presenter = presenter
        self.viewModel = presenter.viewModel
    }
    
    func perform(update: History.Update) {
        switch update {
        case .viewModel:
            viewModel = presenter.viewModel
        }
        DispatchQueue.main.async { [weak self] in
            self?.objectWillChange.send()
        }
    }
    
    func perform(action: History.Action) {
        Task {
            await presenter.perform(action: action)
        }
    }
}
