//
//  SettingsViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 23/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import Combine
import CoreData
import Swinject
import SwiftUI

final class SettingsViewModel: ObservableObject {
    enum SheetType: String, Identifiable {
        var id: String {
            self.rawValue
        }
        case editIcon
        case credits
    }

    @AppStorage("language") var language = LocalizationService.shared.language
    @Preference(\.isDarkMode) var isDarkMode
    @Preference(\.isUsingMetric) private var isMetric
    @Preference(\.isRemindersOn) private var isRemindersOn
    @Preference(\.remindersStart) private var remindersStart
    @Preference(\.remindersEnd) private var remindersEnd
    @Preference(\.remindersInterval) private var reminderFrequency
    @Preference(\.smallDrink) private var smallDrink
    @Preference(\.mediumDrink) private var mediumDrink
    @Preference(\.largeDrink) private var largeDrink

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

    @Published var today: Day = Day(id: UUID(), consumption: 0, goal: 3, date: Date())

    @Published var showNotificationAlert: Bool = false
    @Published var showSheet: SheetType?

    private var presistenceController: PresistenceControllerProtocol
    private var notificationManager = MainAssembler.shared.container.resolve(NotificationManager.self)!
    private var healthManager = MainAssembler.shared.container.resolve(HealthManagerProtocol.self)!
    private var viewContext: NSManagedObjectContext
    private var tasks = Set<AnyCancellable>()

    private var navigateTo: (AppState) -> Void
    private var dayManager: DayManager

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    init(presistenceController: PresistenceControllerProtocol,
         navigateTo: @escaping ((AppState) -> Void)) {
        self.presistenceController = presistenceController
        self.viewContext = presistenceController.container.viewContext
        self.dayManager = DayManager(context: viewContext)
        self.navigateTo = navigateTo
        self.fetchToday()

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
        $today
            .sink { updatedDay in
                self.selectedGoal = updatedDay.goal.convert(to: self.isMetric ? .liters : .imperialPints,
                                                            from: .liters).clean
            }.store(in: &tasks)
        $selectedLanguage
            .removeDuplicates().sink { value in
                self.language = Language(rawValue: value.lowercased()) ?? .english
                self.requestReminders()
            }.store(in: &tasks)
        $selectedUnit
            .sink { unit in
                if Localizable.metricSystem == unit {
                    self.unit = "ml"
                } else {
                    self.unit = "pt"
                }
                self.isMetric = Localizable.metricSystem == unit
                self.selectedGoal = self.today.goal.convert(to: self.isMetric ? .liters : .imperialPints,
                                                            from: .liters).clean
                self.setDrinks()
                self.requestReminders()
            }.store(in: &tasks)
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { _ in
                self.checkNotificationAccess()
            }.store(in: &tasks)
        setupEditDrinkSubscription()
        setupNotificationSubscription()
    }

    func setupEditDrinkSubscription() {
        $small
            .removeDuplicates()
            .sink { newValue in
                guard let value = Double(newValue) else { return }
                let size = Measurement(value: value, unit: self.isMetric ? UnitVolume.milliliters : .imperialPints)
                let metricSize = size.converted(to: .milliliters).value
                self.smallDrink = metricSize
            }.store(in: &tasks)
        $medium
            .removeDuplicates()
            .sink { newValue in
                guard let value = Double(newValue) else { return }
                let size = Measurement(value: value, unit: self.isMetric ? UnitVolume.milliliters : .imperialPints)
                let metricSize = size.converted(to: .milliliters).value
                self.mediumDrink = metricSize
            }.store(in: &tasks)
        $large
            .removeDuplicates()
            .sink { newValue in
                guard let value = Double(newValue) else { return }
                let size = Measurement(value: value, unit: self.isMetric ? UnitVolume.milliliters : .imperialPints)
                let metricSize = size.converted(to: .milliliters).value
                self.largeDrink = metricSize
            }.store(in: &tasks)
    }

    func setupNotificationSubscription() {
        $selectedRemindersOn
            .sink { isOn in
                if self.isRemindersOn != isOn {
                    if self.remindersPremitted {
                        self.isRemindersOn = isOn
                    }
                    self.requestReminders()
                }
            }.store(in: &tasks)
        $selectedStartDate
            .removeDuplicates()
            .sink { _ in
                self.updateStartTime()
            }.store(in: &tasks)
        $selectedEndDate
            .removeDuplicates()
            .sink { _ in
                self.updateEndTime()
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

    func toggleDarkMode() {
        isDarkMode.toggle()
    }

    func incrementGoal() {
        today.goal += 0.5
        updateGoal(today.goal)
    }

    func decrementGoal() {
        if today.goal > 0 {
            today.goal -= 0.5
        }
        updateGoal(today.goal)
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
        self.notificationManager.center.getNotificationSettings { settings in
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

    func updateStartTime() {
        guard remindersStart != selectedStartDate else { return }
        remindersStart = selectedStartDate
        requestReminders()
    }

    func updateEndTime() {
        guard remindersEnd != selectedEndDate else { return }
        remindersEnd = selectedEndDate
        requestReminders()
    }

    func getFrequency() -> String {
        "\(selectedFrequency) min"
    }

    func incrementFrequency() {
        guard var frequency = Int(selectedFrequency) else { return }
        frequency += 15
        self.selectedFrequency = "\(frequency)"
        self.reminderFrequency = frequency
        requestReminders()
    }

    func decrementFrequency() {
        guard var frequency = Int(selectedFrequency), frequency > 15 else { return }
        frequency -= 15
        self.selectedFrequency = "\(frequency)"
        self.reminderFrequency = frequency
        requestReminders()
    }

    private func requestReminders() {
        notificationManager.deleteReminders()
        notificationManager.requestReminders()
    }
}

// MARK: - Save And Load
extension SettingsViewModel {
    private func fetchToday() {
        dayManager.dayRepository.getDay(for: Date())
            .sink { completion in
                switch completion {
                case let .failure(error as CoreDataError):
                    print("Failed fetching day \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] day in
                if let day = day {
                    self?.today = day
                    if day.goal > 0 {
                        self?.selectedGoal = "\(day.goal.clean)"
                    }
                }
            }.store(in: &tasks)
    }

    private func updateGoal(_ newGoal: Double) {
        dayManager.dayRepository.update(goal: newGoal, for: today)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Error adding drink of type: \(newGoal), Error: \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.saveAndFetch()
            }.store(in: &tasks)
    }

    private func saveAndFetch() {
        dayManager.saveChanges()
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Error saving \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.fetchToday()
            }.store(in: &tasks)
    }
}
