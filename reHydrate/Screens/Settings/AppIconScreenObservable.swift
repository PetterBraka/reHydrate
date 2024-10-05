//
//  AppIconScreenObservable.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import PresentationInterface
import PresentationKit

final class AppIconScreenObservable: ObservableObject, AppIconSceneType {
    public typealias ViewModel = AppIcon.ViewModel
    private let presenter: Screen.Settings.AppIcon.Presenter
    
    var viewModel: ViewModel
    var alert: Alert? { .init(from: viewModel.error) }
    
    init(presenter: Screen.Settings.AppIcon.Presenter) {
        self.presenter = presenter
        self.viewModel = presenter.viewModel
    }
    
    func perform(update: AppIcon.Update) {
        switch update {
        case .viewModel:
            self.viewModel = presenter.viewModel
        }
        Task { @MainActor [weak self] in
            self?.objectWillChange.send()
        }
    }
    
    func perform(action: AppIcon.Action) {
        Task {
            await presenter.perform(action: action)
        }
    }
}

extension AppIconScreenObservable {
    enum Alert: LocalizedError {
        case doesNotSupportAlternateIcon
        case failedSettingNewIcon
        
        var errorDescription: String? {
            switch self {
            case .doesNotSupportAlternateIcon:
                LocalizedString(
                    "ui.appIcon.alert.unsupported.title",
                    value: "Alternative icons is unsupport",
                    comment: "An alert displayed if the device doesn't support a different icon"
                )
            case .failedSettingNewIcon:
                LocalizedString(
                    "ui.appIcon.alert.failedSetting.title",
                    value: "Failed setting new icon",
                    comment: "An alert displayed if we failed setting a different icon"
                )
            }
        }
        
        var message: String {
            switch self {
            case .doesNotSupportAlternateIcon:
                LocalizedString(
                    "ui.appIcon.alert.unsupported.message",
                    value: "Looks like your device doesn't support alternative icons.",
                    comment: "An alert displayed if the device doesn't support a different icon"
                )
            case .failedSettingNewIcon:
                LocalizedString(
                    "ui.appIcon.alert.failedSetting.message",
                    value: "Please try again later",
                    comment: "An alert displayed if we failed setting a different icon"
                )
            }
        }
        
        init?(from error: AppIcon.ViewModel.Error?) {
            guard let error else { return nil }
            switch error {
            case .donNotSupportAlternateIcons:
                self = .doesNotSupportAlternateIcon
            case .failedSettingAlternateIcons:
                self = .failedSettingNewIcon
            }
        }
    }
}
