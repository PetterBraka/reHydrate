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
    
    @Published var languages: [String] = [Localizable.Setting.Language.english,
                                          Localizable.Setting.Language.german,
                                          Localizable.Setting.Language.icelandic,
                                          Localizable.Setting.Language.norwegian]
    @Published var selectedLanguage = ""
    @Published var selectedUnit = Localizable.Setting.metricSystem
    @Published var selectedGoal: String = ""
    @Published var remindersOn: Bool = false
    @Published var startDate: Date = DateComponents(calendar: .current, hour: 8, minute: 0).date ?? Date()
    @Published var endDate: Date = DateComponents(calendar: .current, hour: 22, minute: 0).date ?? Date()
    @Published var frequency: String = "0"
    
    @Published var today: Day = Day(id: UUID(), consumption: 0, goal: 3, date: Date())
    
    private var presistenceController: PresistenceControllerProtocol
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
        setupSubscription()
    }
    
    func setupSubscription() {
        $today.sink { updatedDay in
            self.selectedGoal = updatedDay.goal.clean
        }.store(in: &tasks)
        $selectedLanguage
            .removeDuplicates()
            .sink { value in
                self.language = Language(rawValue: value.lowercased()) ?? .english
            }.store(in: &tasks)
    }
    
    func incrementGoal() {
        today.goal += 1
    }
    
    func decrementGoal() {
        today.goal -= 1
    }
    
    func incrementFrequency() {
        if var frequency = Int(frequency) {
            frequency += 15
            self.frequency = "\(frequency)"
        }
    }
    
    func decrementFrequency() {
        if var frequency = Int(frequency) {
            frequency -= 15
            self.frequency = "\(frequency)"
        }
    }
    
    func toggleDarkMode() {
        isDarkMode.toggle()
        print(isDarkMode ? "Dark mode on" : "Light mode on")
    }
    
    func toggleReminders() {
        remindersOn.toggle()
        print(remindersOn ? "Reminders on" : "Reminders off")
    }
    
    func navigateToHome() {
        updateGoal(today.goal)
        navigateTo(.home)
    }
}

extension SettingsViewModel {
    func fetchToday() {
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
    
    func updateGoal(_ newGoal: Double) {
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
