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
    @Published var isRemindersOn: Bool
    @Published var remindersStart: Date
    @Published var remindersStartRange: ClosedRange<Date>
    @Published var remindersEnd: Date
    @Published var remindersEndRange: ClosedRange<Date>
    @Published var reminderFrequency: Int?
    @Published var small: Drink
    @Published var medium: Drink
    @Published var large: Drink
    var viewModel: ViewModel
    
    init(presenter: Screen.Settings.Presenter, 
         viewModel: ViewModel,
         language: Language,
         languageOptions: [Language],
         isDarkMode: Bool,
         isRemindersOn: Bool,
         remindersStart: Date,
         remindersStartRange: ClosedRange<Date>,
         remindersEnd: Date,
         remindersEndRange: ClosedRange<Date>,
         reminderFrequency: Int,
         small: DrinkServiceInterface.Drink,
         medium: DrinkServiceInterface.Drink,
         large: DrinkServiceInterface.Drink) {
        self.presenter = presenter
        self.language = language
        self.languageOptions = languageOptions
        self.isDarkMode = isDarkMode
        self.isRemindersOn = isRemindersOn
        self.remindersStart = remindersStart
        self.remindersStartRange = remindersStartRange
        self.remindersEnd = remindersEnd
        self.remindersEndRange = remindersEndRange
        self.reminderFrequency = reminderFrequency
        self.small = small
        self.medium = medium
        self.large = large
        self.viewModel = viewModel
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
        presenter.perform(action: action)
    }
}
