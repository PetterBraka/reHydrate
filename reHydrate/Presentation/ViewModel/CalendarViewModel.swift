//
//  CalendarViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 22/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreData
import CoreInterfaceKit
import SwiftUI
import Swinject

final class CalendarViewModel: ObservableObject {
    private let settingsRepository: SettingsRepository = MainAssembler.resolve()
    private let dayRepository: DayRepository = MainAssembler.resolve()
    var language: Language { settingsRepository.language }
    var isMetric: Bool { settingsRepository.isMetric }

    @Published var showAlert: Bool = false
    @Published var selectedDays = [Day]()
    @Published var storedDays = [Day]()

    @Published var header = ""
    @Published var consumtion = ""
    @Published var average = ""

    private var tasks = Set<AnyCancellable>()

    private var navigateTo: (AppState) -> Void

    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd MMM"
        return formatter
    }()

    init(navigateTo: @escaping ((AppState) -> Void)) {
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
            let consumedGoal = day.toLocal()
            consumtion = "\(consumedGoal.consumption)/\(consumedGoal.goal)"
            formatter.locale = Locale(identifier: language.rawValue)
            header = formatter.string(from: day.date)
        }
    }

    func getAverage(for days: [Day]) {
        var totalConsumed = 0.0
        days.forEach { totalConsumed = $0.consumption + totalConsumed }
        let average = totalConsumed / Double(days.count)
        self.average = "\(getLocalized(value: average))\(getUnit())"
    }

    func getLocalized(value: Double) -> String {
        let drinkValue = value.convert(to: isMetric ? .liters : .imperialPints, from: .liters)
        return drinkValue.clean
    }

    func getUnit() -> String {
        isMetric ? "ml" : "pt"
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
                let days = try await dayRepository.fetchAll()
                storedDays = days
                getConsumed(for: days)
                getAverage(for: days)
            } catch {
                print("Failed fetching days \(error)")
            }
        }
    }
}
