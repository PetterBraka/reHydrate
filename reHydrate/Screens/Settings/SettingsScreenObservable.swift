//
//  SettingsScreenObservable.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 17/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import LanguageServiceInterface
import DrinkServiceInterface
import SettingsPresentationInterface
import PresentationKit

final class SettingsScreenObservable: ObservableObject, SettingsSceneType {
    public typealias ViewModel = Settings.ViewModel
    private let presenter: Screen.Settings.Presenter
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @Published var language: Language
    @Published var languageOptions: [Language]
    @Published var isDarkMode: Bool
    var viewModel: ViewModel
    
    init(presenter: Screen.Settings.Presenter,
         language: Language,
         languageOptions: [Language],
         isDarkMode: Bool) {
        self.presenter = presenter
        self.viewModel = presenter.viewModel
        self.language = language
        self.languageOptions = languageOptions
        self.isDarkMode = isDarkMode
    }
    
    func perform(update: Settings.Update) {
        switch update {
        case .viewModel:
            self.viewModel = presenter.viewModel
        }
        DispatchQueue.main.async { [weak self] in
            self?.objectWillChange.send()
        }
    }
    
    func perform(action: Settings.Action) {
        Task {
            await presenter.perform(action: action)
        }
    }
}
