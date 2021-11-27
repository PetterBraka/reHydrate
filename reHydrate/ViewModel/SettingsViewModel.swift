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
    @AppStorage(DefaultsName.darkMode) var isDarkMode = false
    
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
    }
    
    func toggleDarkMode() {
        isDarkMode.toggle()
        print(isDarkMode ? "Dark mode on" : "Light mode on")
    }
    
    func navigateToHome() {
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
                }
            }.store(in: &tasks)
    }
}
