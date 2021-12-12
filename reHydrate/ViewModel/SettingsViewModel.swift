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
    @AppStorage("language") var language = LocalizationService.shared.language
    @Preference(\.isDarkMode) var isDarkMode
    @Preference(\.isUsingMetric) private var isMetric
    @Preference(\.isRemindersOn) private var isRemindersOn
    @Preference(\.remindersStart) private var remindersStart
    @Preference(\.remindersEnd) private var remindersEnd
    @Preference(\.remindersInterval) private var reminderFrequency

    @Published var languageOptions: [String] = [Localizable.Setting.Language.english,
                                          Localizable.Setting.Language.german,
                                          Localizable.Setting.Language.icelandic,
                                          Localizable.Setting.Language.norwegian]
    @Published var selectedLanguage: String = ""
    @Published var selectedUnit = Localizable.Setting.metricSystem
    @Published var selectedGoal: String = ""
    @Published var selectedRemindersOn: Bool = false
    @Published var remindersPremitted: Bool = false
    @Published var selectedStartDate: Date = DateComponents(calendar: .current, hour: 8, minute: 0).date ?? Date()
    @Published var selectedEndDate: Date = DateComponents(calendar: .current, hour: 22, minute: 0).date ?? Date()
    @Published var selectedFrequency: String = "60"

    @Published var today: Day = Day(id: UUID(), consumption: 0, goal: 3, date: Date())

    @Published var showNotificationAlert: Bool = false

    private var presistenceController: PresistenceControllerProtocol
    private var notificationManager = MainAssembler.shared.container.resolve(NotificationManager.self)!
    private var healthManager = MainAssembler.shared.container.resolve(HealthManagerProtocol.self)!
    private var viewContext: NSManagedObjectContext
    private var tasks = Set<AnyCancellable>()

    private var navigateTo: (AppState) -> Void
    private var dayManager: DayManager

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
        selectedFrequency = "\(reminderFrequency)"
        checkNotificationAccess()
        setupSubscription()
    }

    func setupSubscription() {
        $today.sink { updatedDay in
                self.selectedGoal = updatedDay.goal.convert(to: self.isMetric ? .liters : .imperialPints,
                                                            from: .liters).clean
            }.store(in: &tasks)
        $selectedLanguage
            .removeDuplicates().sink { value in
                self.language = Language(rawValue: value.lowercased()) ?? .english
            }.store(in: &tasks)
        $selectedUnit.sink { unit in
                if unit != Localizable.Setting.metricSystem {
                    self.isMetric = Localizable.Setting.metricSystem == unit
                    self.selectedGoal = self.today.goal.convert(to: self.isMetric ? .liters : .imperialPints,
                                                                from: .liters).clean
                    if self.isRemindersOn {
                        self.notificationManager.setReminders()
                    }
                }
            }.store(in: &tasks)
        $selectedRemindersOn.sink { isOn in
                if self.isRemindersOn != isOn {
                    if self.remindersPremitted {
                        self.isRemindersOn = isOn
                    }
                    if self.isRemindersOn {
                        self.notificationManager.setReminders()
                    } else {
                        self.notificationManager.deleteReminders()
                    }
                }
            }.store(in: &tasks)
        $selectedStartDate
            .removeDuplicates().sink { _ in
                self.updateStartTime()
            }.store(in: &tasks)
        $selectedEndDate
            .removeDuplicates().sink { _ in
                self.updateEndTime()
            }.store(in: &tasks)

        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { _ in
                self.checkNotificationAccess()
            }.store(in: &tasks)
    }

    func toggleDarkMode() {
        isDarkMode.toggle()
    }

    func incrementGoal() {
        today.goal += 0.5
    }

    func decrementGoal() {
        if today.goal > 0 {
            today.goal -= 0.5
        }
    }

    func navigateToHome() {
        updateGoal(today.goal)
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
        if remindersStart != selectedStartDate {
            remindersStart = selectedStartDate
            notificationManager.setReminders()
        }
    }

    func updateEndTime() {
        if remindersEnd != selectedEndDate {
            remindersEnd = selectedEndDate
            notificationManager.setReminders()
        }
    }

    func incrementFrequency() {
        if var frequency = Int(selectedFrequency) {
            frequency += 15
            self.selectedFrequency = "\(frequency)"
            self.reminderFrequency = frequency
        }
        notificationManager.setReminders()
    }

    func decrementFrequency() {
        if var frequency = Int(selectedFrequency), frequency > 15 {
            frequency -= 15
            self.selectedFrequency = "\(frequency)"
            self.reminderFrequency = frequency
        }
        notificationManager.setReminders()
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
