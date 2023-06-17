//
//  SettingsViewObservable.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 17/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import LanguageServiceInterface
import DrinkServiceInterface
import SettingsPresentationInterface

final class SettingsViewObservable: ObservableObject, SettingsSceneType {
    private let presenter: SettingsPresenterType
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @Published var language: Language
    @Published var languageOptions: [Language]
    @Published var isDarkMode: Bool
    @Published var isMetric: Bool
    @Published var goal: Double
    @Published var unit: UnitVolume
    @Published var isRemindersOn: Bool
    @Published var remindersStart: Date
    @Published var remindersStartRange: ClosedRange<Date>
    @Published var remindersEnd: Date
    @Published var remindersEndRange: ClosedRange<Date>
    @Published var reminderFrequency: Int
    @Published var small: Double
    @Published var medium: Double
    @Published var large: Double
    
    func perform(update: Settings.Update) {
    }
    
    func perform(action: Settings.Action) {
        presenter.perform(action: action)
    }
}
