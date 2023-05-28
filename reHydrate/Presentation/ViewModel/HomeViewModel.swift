//
//  HomeViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreData
import CoreInterfaceKit
import CoreKit
import FirebaseAnalytics
import HealthKit
import SwiftUI
import WatchConnectivity

final class HomeViewModel: NSObject, ObservableObject {
    enum AccessType {
        case notification
        case health
    }

    private let notificationManager: NotificationManager = MainAssembler.resolve()
    private let healthManager: HealthManagerProtocol = MainAssembler.resolve()
    private let dayRepository: DayRepository = MainAssembler.resolve()

    private let settingsRepository: SettingsRepository = MainAssembler.resolve()
    var language: Language { settingsRepository.language }
    var isMetric: Bool { settingsRepository.isMetric }
    var smallDrink: Double { settingsRepository.smallDrink }
    var mediumDrink: Double { settingsRepository.mediumDrink }
    var largeDrink: Double { settingsRepository.largeDrink }
    var hasReachedGoal: Bool { settingsRepository.hasReachedGoal }

    @Published var today = Day(id: UUID(), consumption: 0, goal: 3, date: Date())
    @Published var drinks: [Drink] = []
    @Published var showAlert: Bool = false
    @Published var interactedDrink: Drink?
    @Published private var accessRequested: [AccessType] = []
    private var tasks = Set<AnyCancellable>()

    private var navigateTo: (AppState) -> Void

    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd MMM"
        return formatter
    }()

    private var watchFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd MMM yyyy"
        return formatter
    }()

    let session = WCSession.default

    init(navigateTo: @escaping ((AppState) -> Void)) {
        self.navigateTo = navigateTo
        super.init()
        updateDrinks()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
        requestNotificationAccess()
        setupSubscribers()
    }

    func requestNotificationAccess() {
        Task {
            do {
                try await notificationManager.requestAccess()
                requestHealthAccess()
            } catch {
                print("Failed requesting access too notification: \(error.localizedDescription)")
            }
        }
    }

    func requestHealthAccess() {
        Task {
            do {
                try await healthManager.requestAccess()
                self.fetchHealthData()
            } catch {
                print("Failed requesting access too health: \(error.localizedDescription)")
            }
        }
    }

    func setupSubscribers() {
        NotificationCenter.default.publisher(for: .addedSmallDrink)
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in
                    guard let drink = self?.drinks[0] else { return }
                    self?.addDrink(drink)
                }
            }.store(in: &tasks)
        NotificationCenter.default.publisher(for: .addedMediumDrink)
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in
                    guard let drink = self?.drinks[1] else { return }
                    self?.addDrink(drink)
                }
            }.store(in: &tasks)
        NotificationCenter.default.publisher(for: .addedLargeDrink)
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in
                    guard let drink = self?.drinks[2] else { return }
                    self?.addDrink(drink)
                }
            }.store(in: &tasks)
        NotificationCenter.default.publisher(for: .savedDrink)
            .sink { [weak self] notification in
                guard let drink = notification.object as? Drink else { return }
                switch drink.type {
                case .small:
                    self?.drinks[0] = drink
                case .medium:
                    self?.drinks[1] = drink
                case .large:
                    self?.drinks[2] = drink
                }
            }.store(in: &tasks)
        $today
            .sink { [weak self] updateDay in
                self?.notificationManager.requestReminders(for: updateDay)
                self?.exportToWatch(today: updateDay)
            }.store(in: &tasks)
    }

    func getDate() -> String {
        formatter.locale = Locale(identifier: language.rawValue)
        return formatter.string(from: today.date)
    }

    func updateDrinks() {
        drinks = [Drink(type: .small, size: smallDrink),
                  Drink(type: .medium, size: mediumDrink),
                  Drink(type: .large, size: largeDrink)]
    }

    func navigateToSettings() {
        navigateTo(.settings)
    }

    func navigateToCalendar() {
        navigateTo(.calendar)
    }
}

// MARK: Save & Load

extension HomeViewModel {
    @MainActor
    func fetchToday() {
        Task {
            do {
                let day = try await dayRepository.fetchDay(for: .now)
                today = day
            } catch {
                print("Failed to get today\(error.localizedDescription)")
            }
        }
    }

    @MainActor
    func addDrink(_ drink: Drink) {
        let consumed = drink.size.convert(to: .liters, from: .milliliters)
        Analytics.track(event: .addDrink)
        Task {
            do {
                let updatedDay = try await dayRepository.addDrink(of: consumed, to: today)
                export(drink: drink)
                today = updatedDay
            } catch {
                print("Error adding drink of type: \(drink), Error: \(error)")
            }
        }
    }

    @MainActor
    func removeDrink(_ drink: Drink) {
        let rawConsumed = Measurement(value: drink.size, unit: isMetric ? UnitVolume.milliliters : .imperialPints)
        let consumed: Double = rawConsumed.converted(to: .liters).value
        Analytics.track(event: .removeDrink)
        Task {
            let drink = Drink(type: drink.type, size: -drink.size)
            do {
                let updatedDay = try await dayRepository.removeDrink(of: consumed < 0 ? 0 : consumed, to: today)
                export(drink: drink)
                today = updatedDay
            } catch {
                print("Error adding drink of type: \(drink), Error: \(error)")
            }
        }
    }

    @MainActor
    private func update(consumption value: Double, for date: Date) {
        Task {
            do {
                let updatedDay = try await dayRepository.update(consumption: value,
                                                                forDayAt: date)
                today = updatedDay
            } catch {
                print("Error updating todays consumption: \(value), Error: \(error)")
            }
        }
    }
}

// MARK: HealthKit export & import

extension HomeViewModel {
    func fetchHealthData() {
        healthManager.getWater(for: .now) { [weak self] result in
            Task { @MainActor [weak self] in
                switch result {
                case let .success(consumed):
                    self?.update(consumption: consumed, for: .now)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }

    private func export(drink: Drink) {
        guard drink.size != 0 else { return }
        healthManager.export(drinkOfSize: drink.size, .now) { _ in }
    }
}

// MARK: - Watch communications

extension HomeViewModel: WCSessionDelegate {
    enum WatchError: Error {
        case extractionError
        case watchNotUpdated
    }

    private func exportToWatch(today: Day) {
        if WCSession.isSupported() {
            let message = ["phoneDate": watchFormatter.string(from: today.date),
                           "phoneGoal": String(today.goal),
                           "phoneConsumed": String(today.consumption),
                           "phoneDrinks": "\(drinks[0].size),\(drinks[1].size),\(drinks[2].size)"]
            if session.activationState == .activated {
                session.transferCurrentComplicationUserInfo(message)
            } else {
                session.transferUserInfo(message)
            }
        }
    }

    func session(_: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error _: Error?) {
        if activationState == .activated {
            print("connected to watch")
        } else {
            print("Can't connect")
        }
    }

    func sessionDidBecomeInactive(_: WCSession) {
        print("Disconnected")
    }

    func sessionDidDeactivate(_: WCSession) {
        print("Disconnected")
    }

    func session(_: WCSession, didReceiveMessage message: [String: Any]) {
        print("Recived message from watched")
        handleWatch(message)
    }

    func session(_: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        print("Recived userInfo from watch")
        handleWatch(userInfo)
    }

    @MainActor
    func updateWatchWith(_ consumed: Double, _ date: Date, for day: Day) throws {
        guard day.consumption < consumed else { throw WatchError.watchNotUpdated }
        update(consumption: consumed, for: date)
        let consumed = Measurement(value: consumed - day.consumption, unit: UnitVolume.liters)
        let differences = consumed.converted(to: .milliliters).value
        export(drink: Drink(type: .medium, size: differences))
        print("Udated with data from watch")
    }

    private func handleWatch(_ data: [String: Any]) {
        if let rawDate = data["date"] as? String,
           let watchDate = watchFormatter.date(from: rawDate),
           let rawConsumed = data["consumed"] as? String,
           let watchConsumed = Double(rawConsumed) {
            Task {
                do {
                    print(data)
                    let day = try await dayRepository.fetchDay(for: watchDate)
                    try await updateWatchWith(watchConsumed, watchDate, for: day)
                } catch {
                    if let error = error as? CoreDataError, error == .elementNotFound {
                        let day = try await dayRepository.fetchDay(for: .now)
                        try await updateWatchWith(watchConsumed, watchDate, for: day)
                    }
                    if let error = error as? WatchError {
                        switch error {
                        case .extractionError:
                            print("Couldn't extract data from watch")
                        case .watchNotUpdated:
                            print("Sending data to watch")
                            exportToWatch(today: today)
                        }
                    }
                }
            }
        } else {
            print("Couldn't extract data from watch")
        }
    }
}
