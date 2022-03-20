//
//  HomeViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreData
import FirebaseAnalytics
import HealthKit
import SwiftUI
import WatchConnectivity

final class HomeViewModel: NSObject, ObservableObject {
    enum AccessType {
        case notification
        case health
    }

    @AppStorage("language") var language = LocalizationService.shared.language
    @Preference(\.smallDrink) private var smallDrink
    @Preference(\.mediumDrink) private var mediumDrink
    @Preference(\.largeDrink) private var largeDrink
    @Preference(\.isUsingMetric) private var isMetric
    @Preference(\.hasReachedGoal) private var hasReachedGoal

    @Published var today = Day(id: UUID(), consumption: 0, goal: 3, date: Date())
    @Published var drinks: [Drink] = []
    @Published var showAlert: Bool = false
    @Published var interactedDrink: Drink?
    @Published private var accessRequested: [AccessType] = []

    private var notificationManager = NotificationManager.shared
    private var healthManager = MainAssembler.shared.container.resolve(HealthManagerProtocol.self)!

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

    private var watchFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd MMM yyyy"
        return formatter
    }()

    let session = WCSession.default

    init(presistenceController: PresistenceControllerProtocol,
         navigateTo: @escaping ((AppState) -> Void)) {
        self.presistenceController = presistenceController
        viewContext = presistenceController.container.viewContext
        dayManager = DayManager(context: viewContext)
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
                guard let drink = self?.drinks[0] else { return }
                self?.addDrink(drink)
            }.store(in: &tasks)
        NotificationCenter.default.publisher(for: .addedMediumDrink)
            .sink { [weak self] _ in
                guard let drink = self?.drinks[1] else { return }
                self?.addDrink(drink)
            }.store(in: &tasks)
        NotificationCenter.default.publisher(for: .addedLargeDrink)
            .sink { [weak self] _ in
                guard let drink = self?.drinks[2] else { return }
                self?.addDrink(drink)
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
                default:
                    break
                }
            }.store(in: &tasks)
    }

    func getValue(for drink: Drink?) -> String {
        if let drink = drink {
            let drinkValue = drink.size.convert(to: isMetric ? .milliliters : .imperialPints, from: .milliliters)
            return drinkValue.clean + (isMetric ? "ml" : "pt")
        } else {
            return ""
        }
    }

    func getConsumed() -> String {
        let consumed = today.consumption.convert(to: isMetric ? .liters : .imperialPints, from: .liters)
        return consumed.clean
    }

    func getGoal() -> String {
        let goal = today.goal.convert(to: isMetric ? .liters : .imperialPints, from: .liters)
        return goal.clean + (isMetric ? "L" : "pt")
    }

    func getDate() -> String {
        if let date = today.date {
            formatter.locale = Locale(identifier: language.rawValue)
            return formatter.string(from: date)
        } else {
            return ""
        }
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
    private func createNewDay() {
        Task {
            do {
                let day = try await dayManager.createToday()
                today = day
            } catch {
                print("Couldn't create new day for today. \(error.localizedDescription)")
            }
        }
    }

    func fetchToday() {
        Task {
            do {
                let day = try await dayManager.fetchToday()
                self.today = day
                notificationManager.requestReminders(for: day)
                exportToWatch(today: day)
            } catch {
                createNewDay()
            }
        }
    }

    private func saveAndFetch() async {
        do {
            try await dayManager.saveChanges()
            fetchToday()
        } catch {
            print("Error saving \(error)")
        }
    }

    func addDrink(_ drink: Drink) {
        let rawConsumed = Measurement(value: drink.size, unit: isMetric ? UnitVolume.milliliters : .imperialPints)
        let consumed = rawConsumed.converted(to: .liters).value
        Analytics.track(event: .addDrink)
        Task {
            do {
                try await dayManager.addDrink(of: consumed, to: today)
                export(drink: drink)
                fetchToday()
            } catch {
                print("Error adding drink of type: \(drink), Error: \(error)")
            }
        }
    }

    func removeDrink(_ drink: Drink) {
        let rawConsumed = Measurement(value: drink.size, unit: isMetric ? UnitVolume.milliliters : .imperialPints)
        let consumed: Double = rawConsumed.converted(to: .liters).value
        Analytics.track(event: .removeDrink)
        Task {
            let drink = Drink(type: drink.type, size: -drink.size)
            do {
                try await dayManager.removeDrink(of: consumed < 0 ? 0 : consumed, to: today)
                export(drink: drink)
                fetchToday()
            } catch {
                print("Error adding drink of type: \(drink), Error: \(error)")
            }
        }
    }

    private func update(consumption value: Double, for date: Date) {
        Task {
            do {
                try await dayManager.update(consumption: value, for: date)
                fetchToday()
            } catch {
                print("Error updating todays consumption: \(value), Error: \(error)")
            }
        }
    }
}

// MARK: HealthKit export & import

extension HomeViewModel {
    func fetchHealthData() {
        healthManager.getWater(for: Date())
            .removeDuplicates()
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print(error)
                default:
                    break
                }
            } receiveValue: { consumed in
                print("Got data from health")
                self.update(consumption: consumed, for: Date())
            }.store(in: &tasks)
    }

    private func export(drink: Drink) {
        guard drink.size != 0 else { return }
        healthManager.export(drink: drink, Date())
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print(error)
                default:
                    break
                }
            } receiveValue: { _ in }
            .store(in: &tasks)
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

    func updateWatchWith(_ consumed: Double, _ date: Date, for day: Day) throws {
        guard day.consumption < consumed else { throw WatchError.watchNotUpdated }
        update(consumption: consumed, for: date)
        let consumed = Measurement(value: consumed - day.consumption, unit: UnitVolume.liters)
        let differences = consumed.converted(to: .milliliters).value
        export(drink: Drink(size: differences))
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
                    let day = try await dayManager.dayRepository.getDay(for: watchDate)
                    try updateWatchWith(watchConsumed, watchDate, for: day)
                } catch {
                    if let error = error as? CoreDataError, error == .elementNotFound {
                        Task {
                            let day = try await dayManager.createToday()
                            try updateWatchWith(watchConsumed, watchDate, for: day)
                        }
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
