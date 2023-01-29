//
//  SettingsViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 23/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreData
import Foundation
import SwiftUI
import Swinject

final class SettingsViewModel: ObservableObject {
    enum SheetType: String, Identifiable {
        var id: String {
            rawValue
        }

        case editIcon
        case credits
    }
    
    private let notificationManager: NotificationManager = MainAssembler.resolve()
    private let healthManager: HealthManagerProtocol = MainAssembler.resolve()
    private let dayRepository: DayRepository = MainAssembler.resolve()

    private let settingsRepository: SettingsRepository = MainAssembler.resolve()
    var language: Language { settingsRepository.language }
    var isDarkMode: Bool { settingsRepository.isDarkMode }
    var isMetric: Bool { settingsRepository.isMetric }
    var isRemindersOn: Bool { settingsRepository.isRemindersOn }
    var remindersStart: Date { settingsRepository.remindersStart }
    var remindersEnd: Date { settingsRepository.remindersEnd }
    var reminderFrequency: Int { settingsRepository.reminderFrequency }
    var smallDrink: Double { settingsRepository.smallDrink }
    var mediumDrink: Double { settingsRepository.mediumDrink }
    var largeDrink: Double { settingsRepository.largeDrink }

    @Published var isDarkModeOn = false
    @Published var languageOptions: [String] = [Localizable.english,
                                                Localizable.german,
                                                Localizable.icelandic,
                                                Localizable.norwegian]
    @Published var selectedLanguage: String = ""
    @Published var selectedUnit = Localizable.metricSystem
    @Published var selectedGoal: String = ""

    @Published var small: String = ""
    @Published var medium: String = ""
    @Published var large: String = ""
    @Published var unit: String = "ml"

    @Published var selectedRemindersOn: Bool = false
    @Published var remindersPremitted: Bool = false
    @Published var selectedStartDate: Date = DateComponents(calendar: .current, hour: 8, minute: 0).date ?? Date()
    @Published var selectedEndDate: Date = DateComponents(calendar: .current, hour: 22, minute: 0).date ?? Date()
    @Published var selectedFrequency: String = "60"

    var remindersStartRange: ClosedRange<Date> {
        let startRange = Calendar.current.startOfDay(for: selectedStartDate)
        if let endRange = Calendar.current.date(byAdding: .hour, value: -1, to: selectedEndDate) {
            return startRange ... endRange
        } else {
            let endRange = Calendar.current.date(bySettingHour: 12, minute: 00, second: 00, of: Date())!
            return startRange ... endRange
        }
    }

    var remindersEndRange: ClosedRange<Date> {
        if let startRange = Calendar.current.date(byAdding: .hour, value: 1, to: selectedStartDate),
           let endRange = Calendar.current.date(bySettingHour: 23, minute: 00, second: 00, of: selectedEndDate) {
            return startRange ... endRange
        } else {
            let startRange = Calendar.current.startOfDay(for: Date())
            let endRange = Calendar.current.date(bySettingHour: 23, minute: 00, second: 00, of: Date())!
            return startRange ... endRange
        }
    }

    @Published var today = Day(id: UUID(), consumption: 0, goal: 3, date: Date())

    @Published var showNotificationAlert: Bool = false
    @Published var showSheet: SheetType?
    private var tasks = Set<AnyCancellable>()

    private var navigateTo: (AppState) -> Void

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    init(navigateTo: @escaping ((AppState) -> Void)) {
        self.navigateTo = navigateTo
        isDarkModeOn = isDarkMode
        fetchToday()

        selectedLanguage = language.rawValue
        selectedRemindersOn = isRemindersOn
        selectedStartDate = remindersStart
        selectedEndDate = remindersEnd

        if isMetric {
            selectedUnit = Localizable.metricSystem
        } else {
            selectedUnit = Localizable.imperialSystem
        }

        setDrinks()
        selectedFrequency = "\(reminderFrequency)"
        checkNotificationAccess()
        setupSubscription()
    }

    func setupSubscription() {
        $isDarkModeOn
            .removeDuplicates()
            .sink { [weak self] value in
                self?.settingsRepository.isDarkMode = value
            }.store(in: &tasks)
        $today
            .sink { [weak self] day in
                guard let isMetric = self?.isMetric else { return }
                self?.selectedGoal = day.goal.convert(to: isMetric ? .liters : .imperialPints,
                                                      from: .liters).clean
            }.store(in: &tasks)
        $selectedLanguage
            .removeDuplicates().sink { [weak self] value in
                self?.settingsRepository.language = Language(rawValue: value.lowercased()) ?? .english
                self?.requestReminders()
            }.store(in: &tasks)
        $selectedUnit
            .sink { [weak self] unit in
                if Localizable.metricSystem == unit {
                    self?.unit = "ml"
                } else {
                    self?.unit = "pt"
                }
                self?.settingsRepository.isMetric = Localizable.metricSystem == unit
                self?.selectedGoal = self?.today.goal.convert(to: self?.isMetric ?? true ? .liters : .imperialPints,
                                                              from: .liters).clean ?? "3"
                self?.setDrinks()
                self?.requestReminders()
            }.store(in: &tasks)
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.checkNotificationAccess()
            }.store(in: &tasks)
        setupEditDrinkSubscription()
        setupNotificationSubscription()
    }

    func updateDrinkForSaving(with newValue: Double) -> Double {
        let metricValue = newValue.convert(
            to: .milliliters,
            from: isMetric ? .milliliters : .imperialPints
        )
        return metricValue.rounded()
    }

    func setupEditDrinkSubscription() {
        $small
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let value = Double(newValue),
                      let size = self?.updateDrinkForSaving(with: value)
                else { return }
                self?.settingsRepository.smallDrink = size
            }.store(in: &tasks)
        $medium
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let value = Double(newValue),
                      let size = self?.updateDrinkForSaving(with: value)
                else { return }
                self?.settingsRepository.mediumDrink = size
            }.store(in: &tasks)
        $large
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let value = Double(newValue),
                      let size = self?.updateDrinkForSaving(with: value)
                else { return }
                self?.settingsRepository.largeDrink = size
            }.store(in: &tasks)
    }

    func setupNotificationSubscription() {
        $selectedRemindersOn
            .sink { [weak self] isOn in
                if self?.isRemindersOn != isOn {
                    if self?.remindersPremitted == true {
                        self?.settingsRepository.isRemindersOn = isOn
                    }
                    self?.requestReminders()
                }
            }.store(in: &tasks)
        $selectedStartDate
            .removeDuplicates()
            .sink { [weak self] date in
                self?.updateStartTime(with: date)
            }.store(in: &tasks)
        $selectedEndDate
            .removeDuplicates()
            .sink { [weak self] date in
                self?.updateEndTime(with: date)
            }.store(in: &tasks)
    }

    func setDrinks() {
        var smallLocalDrink = smallDrink.convert(
            to: isMetric ? .milliliters : .imperialPints,
            from: .milliliters
        )
        if isMetric {
            smallLocalDrink.round()
        }
        small = "\(smallLocalDrink.clean)"
        var mediumLocalDrink = mediumDrink.convert(
            to: isMetric ? .milliliters : .imperialPints,
            from: .milliliters
        )
        if isMetric {
            mediumLocalDrink.round()
        }
        medium = "\(mediumLocalDrink.clean)"
        var largeLocalDrink = largeDrink.convert(
            to: isMetric ? .milliliters : .imperialPints,
            from: .milliliters
        )
        if isMetric {
            largeLocalDrink.round()
        }
        large = "\(largeLocalDrink.clean)"
    }

    func incrementGoal() {
        today.goal += 0.5
        updateGoal(today.goal)
    }

    func decrementGoal() {
        if today.goal > 0 {
            today.goal -= 0.5
            updateGoal(today.goal)
        }
    }

    func navigateToHome() {
        navigateTo(.home)
    }
}

// MARK: - Notification

extension SettingsViewModel {
    func toggleReminders() {
        selectedRemindersOn.toggle()
    }

    private func checkNotificationAccess() {
        notificationManager.center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    self.remindersPremitted = true
                } else {
                    self.remindersPremitted = false
                    self.selectedRemindersOn = false
                }
            }
        }
    }

    func updateStartTime(with date: Date) {
        guard remindersStart != date else { return }
        guard remindersStart < remindersEnd else { return }
        settingsRepository.remindersStart = date
        requestReminders()
    }

    func updateEndTime(with date: Date) {
        guard remindersEnd != date else { return }
        guard remindersStart < remindersEnd else { return }
        settingsRepository.remindersEnd = date
        requestReminders()
    }

    func getFrequency() -> String {
        "\(selectedFrequency) min"
    }

    func updateFrequency(shouldIncrese: Bool) {
        let increment = shouldIncrese ? 15 : -15
        guard var frequency = Int(selectedFrequency),
              shouldIncrese || (frequency > 15) else { return }
        frequency += increment
        selectedFrequency = "\(frequency)"
        settingsRepository.reminderFrequency = frequency
        requestReminders()
    }

    private func requestReminders() {
        notificationManager.deleteReminders()
        notificationManager.requestReminders(for: today)
    }
}

// MARK: - Save And Load

extension SettingsViewModel {
    func fetchToday() {
        Task {
            do {
                let day = try await dayRepository.fetchDay()
                today = day
            } catch {
                print("Failed fetching day \(error)")
            }
        }
    }

    private func updateGoal(_ newGoal: Double) {
        Task {
            do {
                let updatedDay = try await dayRepository.update(goal: newGoal, forDayAt: Date())
                today = updatedDay
            } catch {
                print("Error adding drink of type: \(newGoal), Error: \(error)")
            }
        }
    }
}
