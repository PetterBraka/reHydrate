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
    
    @Published var language: Language
    @Published var languageOptions: [Language]
    @Published var isDarkMode: Bool
    var viewModel: ViewModel
    var alert: Alert? { .init(from: viewModel.error) }
    
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

extension SettingsScreenObservable {
    public enum Alert: LocalizedError {
        case unauthorizedAccessOfNotifications
        case somethingWentWrong
        case invalidFrequency
        case cantOpenUrl
        
        public var errorDescription: String? {
            switch self {
            case .somethingWentWrong:
                LocalizedString(
                    "ui.generic.alert.title",
                    value: "Something went wrong",
                    comment: "An generic alert"
                )
            case .unauthorizedAccessOfNotifications:
                LocalizedString(
                    "ui.settings.alert.missingAuth.title",
                    value: "Notification access denied",
                    comment: "An message displayed when the user tries to set enable reminders but they have denied access to use notifications.")
            case .invalidFrequency:
                LocalizedString(
                    "ui.settings.alert.invalidFrequency.title",
                    value: "Frequency is too low",
                    comment: "An alert displayed when the user sets and invalid reminders frequency")
            case .cantOpenUrl:
                LocalizedString(
                    "ui.settings.alert.cantOpenUrl.title",
                    value: "Unable to open",
                    comment: "An alert displayed when we are unable to open a url")
            }
        }
        
        var message: String {
            switch self {
            case .somethingWentWrong:
                LocalizedString(
                    "ui.generic.alert.message",
                    value: "Please try again",
                    comment: "An generic alert"
                )
            case .unauthorizedAccessOfNotifications:
                LocalizedString(
                    "ui.settings.alert.missingAuth.message",
                    value: "Please enable access",
                    comment: "An alert displayed when the user tries to set enable reminders but they have denied access to use notifications."
                )
            case .invalidFrequency:
                LocalizedString(
                    "ui.settings.alert.invalidFrequency.message",
                    value: "Please increase it",
                    comment: "An alert displayed when the user sets and invalid reminders frequency"
                )
            case .cantOpenUrl:
                LocalizedString(
                    "ui.settings.alert.cantOpenUrl.message",
                    value: "Please try again later",
                    comment: "An alert displayed when we are unable to open a url"
                )
            }
        }
        
        init?(from error: Settings.ViewModel.Error?) {
            switch error {
            case .somethingWentWrong:
                self = .somethingWentWrong
            case .unauthorized:
                self = .unauthorizedAccessOfNotifications
            case .lowFrequency:
                self = .invalidFrequency
            case .cantOpenUrl:
                self = .cantOpenUrl
            case .none, .invalidDates,
                    .invalidStart, .invalidStop,
                    .missingReminders:
                return nil
            }
        }
    }
}
