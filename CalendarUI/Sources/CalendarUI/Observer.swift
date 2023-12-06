//
//  Observer.swift
//
//
//  Created by Petter vang Brakalsvålet on 06/12/2023.
//

import Foundation

final class Observer: ObservableObject, SceneType {
    private let presenter: Presenter
    var viewModel: ViewModel { presenter.viewModel }
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func perform(update: Update) {
        switch update {
        case .viewModel:
            self.objectWillChange.send()
        }
    }
    
    
    func perform(action: Action) {
        presenter.perform(action: action)
    }
}
