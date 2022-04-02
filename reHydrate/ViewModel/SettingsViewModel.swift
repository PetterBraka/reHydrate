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

    @AppStorage("language") var language = LocalizationService.shared.language
    @Preference(\.isDarkMode) private var isDarkMode
    @Preference(\.isUsingMetric) private var isMetric
    @Preference(\.isRemindersOn) private var isRemindersOn
    @Preference(\.remindersStart) private var remindersStart
    @Preference(\.remindersEnd) private var remindersEnd
    @Preference(\.remindersInterval) private var reminderFrequency
    @Preference(\.smallDrink) private var smallDrink
    @Preference(\.mediumDrink) private var mediumDrink
    @Preference(\.largeDrink) private var largeDrink

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

    private var presistenceController: PresistenceControllerProtocol
    private var notificationManager = NotificationManager.shared
    private var healthManager = MainAssembler.shared.container.resolve(HealthManagerProtocol.self)!
    private var viewContext: NSManagedObjectContext
    private var tasks = Set<AnyCancellable>()

    private var navigateTo: (AppState) -> Void
    private var dayManager: DayManager

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    init(presistenceController: PresistenceControllerProtocol,
         navigateTo: @escaping ((AppState) -> Void)) {
        self.presistenceController = presistenceController
        viewContext = presistenceController.container.viewContext
        dayManager = DayManager(context: viewContext)
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
                self?.isDarkMode = value
            }.store(in: &tasks)
        $today
            .sink { [weak self] day in
                guard let isMetric = self?.isMetric else { return }
                self?.selectedGoal = day.goal.convert(to: isMetric ? .liters : .imperialPints,
                                                      from: .liters).clean
            }.store(in: &tasks)
        $selectedLanguage
            .removeDuplicates().sink { [weak self] value in
                self?.language = Language(rawValue: value.lowercased()) ?? .english
                self?.requestReminders()
            }.store(in: &tasks)
        $selectedUnit
            .sink { [weak self] unit in
                if Localizable.metricSystem == unit {
                    self?.unit = "ml"
                } else {
                    self?.unit = "pt"
                }
                self?.isMetric = Localizable.metricSystem == unit
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

    func updateDrink(with newValue: Double) -> Double {
        let unit = isMetric ? UnitVolume.milliliters : .imperialPints
        let size = Measurement(value: newValue, unit: unit)
        let metricSize = size.converted(to: .milliliters).value
        return metricSize
    }

    func setupEditDrinkSubscription() {
        $small
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let value = Double(newValue),
                      let size = self?.updateDrink(with: value)
                else { return }
                self?.smallDrink = size
            }.store(in: &tasks)
        $medium
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let value = Double(newValue),
                      let size = self?.updateDrink(with: value)
                else { return }
                self?.mediumDrink = size
            }.store(in: &tasks)
        $large
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let value = Double(newValue),
                      let size = self?.updateDrink(with: value)
                else { return }
                self?.largeDrink = size
            }.store(in: &tasks)
    }

    func setupNotificationSubscription() {
        $selectedRemindersOn
            .sink { [weak self] isOn in
                if self?.isRemindersOn != isOn {
                    if self?.remindersPremitted == true {
                        self?.isRemindersOn = isOn
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
        let smallSize = Measurement(value: smallDrink, unit: UnitVolume.milliliters)
        let smallValue = smallSize.converted(to: isMetric ? .milliliters : .imperialPints).value
        small = "\(smallValue.clean)"
        let mediumSize = Measurement(value: mediumDrink, unit: UnitVolume.milliliters)
        let mediumValue = mediumSize.converted(to: isMetric ? .milliliters : .imperialPints).value
        medium = "\(mediumValue.clean)"
        let largeSize = Measurement(value: largeDrink, unit: UnitVolume.milliliters)
        let largeValue = largeSize.converted(to: isMetric ? .milliliters : .imperialPints).value
        large = "\(largeValue.clean)"
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
        remindersStart = date
        requestReminders()
    }

    func updateEndTime(with date: Date) {
        guard remindersEnd != date else { return }
        guard remindersStart < remindersEnd else { return }
        remindersEnd = date
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
        reminderFrequency = frequency
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
                let day = try await dayManager.fetchToday()
                self.today = day
                if day.goal > 0 {
                    selectedGoal = "\(day.goal.clean)"
                }
            } catch {
                print("Failed fetching day \(error)")
            }
        }
    }

    private func saveAndFetch() {
        Task {
            do {
                print(today)
                try await dayManager.saveChanges()
                fetchToday()
            } catch {
                print("Error saving \(error)")
            }
        }
    }

    private func updateGoal(_ newGoal: Double) {
        Task {
            do {
                try await dayManager.update(goal: newGoal, for: Date())
                saveAndFetch()
            } catch {
                print("Error adding drink of type: \(newGoal), Error: \(error)")
            }
        }
    }
}
