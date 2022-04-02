//
//  CalendarViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 22/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreData
import SwiftUI
import Swinject

final class CalendarViewModel: ObservableObject {
    @AppStorage("language") private var language = LocalizationService.shared.language

    @Published var showAlert: Bool = false
    @Published var selectedDays = [Day]()
    @Published var storedDays = [Day]()

    @Published var header = ""
    @Published var consumtion = ""
    @Published var average = ""

    private var presistenceController: PresistenceControllerProtocol
    private var viewContext: NSManagedObjectContext
    private var tasks = Set<AnyCancellable>()

    private var navigateTo: (AppState) -> Void
    private var dayManager: DayManager

    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd MMM"
        return formatter
    }()

    init(presistenceController: PresistenceControllerProtocol,
         navigateTo: @escaping ((AppState) -> Void)) {
        self.presistenceController = presistenceController
        viewContext = presistenceController.container.viewContext
        dayManager = DayManager(context: viewContext)
        self.navigateTo = navigateTo
        fetchDays()
        setUpSubscriptions()
    }

    func setUpSubscriptions() {
        $selectedDays
            .receive(on: RunLoop.main)
            .sink { [weak self] days in
                if days.isEmpty {
                    if let today = self?.storedDays.first(where: { $0.isSameDay(as: Date()) }) {
                        self?.getConsumed(for: [today])
                        self?.getAverage(for: self?.storedDays ?? [])
                    }
                } else {
                    self?.getConsumed(for: days)
                    if days.count > 1 {
                        self?.getAverage(for: days)
                    } else {
                        self?.getAverage(for: self?.storedDays ?? [])
                    }
                }
            }.store(in: &tasks)
    }

    func getConsumed(for days: [Day]) {
        if let day = days.first {
            let consumed = day.consumption.clean
            let goal = day.goal.clean
            consumtion = "\(consumed)/\(goal)L"
            formatter.locale = Locale(identifier: language.rawValue)
            header = formatter.string(from: day.date)
        }
    }

    func getAverage(for days: [Day]) {
        var totalConsumed = 0.0
        days.forEach { totalConsumed = $0.consumption + totalConsumed }
        let average = totalConsumed / Double(days.count)
        self.average = "\(average.clean)L"
    }

    func navigateToHome() {
        navigateTo(.home)
    }

    func fetchSavedDays() {
        fetchDays()
    }
}

// MARK: Save & Load

extension CalendarViewModel {
    private func fetchDays() {
        Task { @MainActor in
            do {
                let days = try await dayManager.dayRepository.getDays()
                storedDays = days
                getConsumed(for: days)
                getAverage(for: days)
            } catch {
                print("Failed fetching days \(error)")
            }
        }
    }
}
