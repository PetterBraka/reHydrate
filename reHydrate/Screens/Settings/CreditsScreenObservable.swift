//
//  CreditsScreenObservable.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import CreditsPresentationInterface
import PresentationKit

final class CreditsScreenObservable: ObservableObject, CreditsSceneType {
    public typealias ViewModel = Credits.ViewModel
    private let presenter: Screen.Settings.Credits.Presenter
    
    var viewModel: ViewModel
    var alert: Alert? { .init(from: viewModel.error) }
    
    init(presenter: Screen.Settings.Credits.Presenter) {
        self.presenter = presenter
        self.viewModel = presenter.viewModel
    }
    
    func perform(update: Credits.Update) {
        switch update {
        case .viewModel:
            self.viewModel = presenter.viewModel
        }
        DispatchQueue.main.async { [weak self] in
            self?.objectWillChange.send()
        }
    }
    
    func perform(action: Credits.Action) {
        Task {
            await presenter.perform(action: action)
        }
    }
}

extension CreditsScreenObservable {
    enum Alert: LocalizedError {
        case unableToOpenLink
        
        var errorDescription: String? {
            switch self {
            case .unableToOpenLink:
                LocalizedString(
                    "ui.credits.alert.link.title",
                    value: "Unable to open link",
                    comment: "An alert displayed when the user tries to open a link which is broken"
                )
            }
        }
        
        var message: String {
            switch self {
            case .unableToOpenLink:
                LocalizedString(
                    "ui.credits.alert.link.message",
                    value: "Please try again",
                    comment: "An alert displayed when the user tries to open a link which is broken"
                )
            }
        }
        
        init?(from error: Credits.ViewModel.Error?) {
            guard let error else { return nil }
            switch error {
            case .unableToOpenLink:
                self = .unableToOpenLink
            }
        }
    }
}
