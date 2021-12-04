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
    @Published var selectedStartDate: Date = DateComponents(calendar: .current, hour: 8, minute: 0).date ?? Date()
    @Published var selectedEndDate: Date = DateComponents(calendar: .current, hour: 22, minute: 0).date ?? Date()
    @Published var selectedFrequency: String = "60"
    
    @Published var today: Day = Day(id: UUID(), consumption: 0, goal: 3, date: Date())
    
    private var presistenceController: PresistenceControllerProtocol
    private var notificationService = NotificationService()
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
        setupSubscription()
    }
    
    func setupSubscription() {
        $today
            .sink { updatedDay in
                self.selectedGoal = updatedDay.goal.clean
            }.store(in: &tasks)
        $selectedLanguage
            .removeDuplicates()
            .sink { value in
                self.language = Language(rawValue: value.lowercased()) ?? .english
            }.store(in: &tasks)
        $selectedRemindersOn
            .sink { isOn in
                self.isRemindersOn = isOn
                if isOn {
                    self.notificationService.setReminders()
                }
            }.store(in: &tasks)
    }
    
    func toggleDarkMode() {
        isDarkMode.toggle()
        print(isDarkMode ? "Dark mode on" : "Light mode on")
    }
    
    func incrementGoal() {
        today.goal += 1
    }
    
    func decrementGoal() {
        today.goal -= 1
    }
    
    func toggleReminders() {
        selectedRemindersOn.toggle()
        print(selectedRemindersOn ? "Reminders on" : "Reminders off")
    }
    
    func updateStartTime() {
            remindersStart = selectedStartDate
            notificationService.setReminders()
    }
    
    func updateEndTime() {
        remindersEnd = selectedEndDate
        notificationService.setReminders()
    }
    
    func incrementFrequency() {
        if var frequency = Int(selectedFrequency) {
            frequency += 15
            self.selectedFrequency = "\(frequency)"
            self.reminderFrequency = frequency
        }
        notificationService.setReminders()
    }
    
    func decrementFrequency() {
        if var frequency = Int(selectedFrequency), frequency > 15 {
            frequency -= 15
            self.selectedFrequency = "\(frequency)"
            self.reminderFrequency = frequency
        }
        notificationService.setReminders()
    }
    
    func navigateToHome() {
        updateGoal(today.goal)
        navigateTo(.home)
    }
}

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
