//
//  HomeViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreData
import HealthKit
import SwiftUI
import WatchConnectivity

final class HomeViewModel: NSObject, ObservableObject {
    enum AccessType {
        case notification
        case health
    }

    @AppStorage("language") private var language = LocalizationService.shared.language
    @Preference(\.smallDrink) private var smallDrink
    @Preference(\.mediumDrink) private var mediumDrink
    @Preference(\.largeDrink) private var largeDrink
    @Preference(\.isUsingMetric) private var isMetric

    @Published var today = Day(id: UUID(), consumption: 0, goal: 3, date: Date())
    @Published var drinks: [Drink] = []
    @Published var showAlert: Bool = false
    @Published var interactedDrink: Drink?
    @Published private var accessRequested: [AccessType] = []

    private var notificationManager = MainAssembler.shared.container.resolve(NotificationManager.self)!
    private var healthManager = MainAssembler.shared.container.resolve(HealthManagerProtocol.self)!

    private var presistenceController: PresistenceControllerProtocol
    private var viewContext: NSManagedObjectContext
    private var tasks = Set<AnyCancellable>()

    private var navigateTo: (AppState) -> Void
    private var dayManager: DayManager

    private var formatter: DateFormatter = {
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
        notificationManager.requestAccess()
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Failed requesting access too notification: \(error.localizedDescription)")
                default:
                    break
                }
            } receiveValue: { _ in
                print("Notification requested")
                self.requestHealthAccess()
            }.store(in: &tasks)
    }

    func requestHealthAccess() {
        healthManager.requestAccess()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Failed requesting access too health: \(error.localizedDescription)")
                default:
                    break
                }
            } receiveValue: { _ in
                print("Health requested")
                self.fetchHealthData()
            }.store(in: &tasks)
    }

    func setupSubscribers() {
        $today
            .removeDuplicates(by: { $0.consumption == $1.consumption })
            .sink { day in
                if day.consumption >= day.goal {
                    print("Reached todays goal")
                    self.notificationManager.reachedGoal = true
                    self.notificationManager.createCongratulation()
                } else {
                    self.notificationManager.setReminders()
                }
            }.store(in: &tasks)
        NotificationCenter.default.publisher(for: .addedSmallDrink)
            .sink { _ in
                self.addDrink(self.drinks[0])
            }.store(in: &tasks)
        NotificationCenter.default.publisher(for: .addedMediumDrink)
            .sink { _ in
                self.addDrink(self.drinks[1])
            }.store(in: &tasks)
        NotificationCenter.default.publisher(for: .addedLargeDrink)
            .sink { _ in
                self.addDrink(self.drinks[2])
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
        var latestGoal = fetchLastGoal()
        latestGoal = (latestGoal > 0) ? latestGoal : 3
        let newDay = Day(id: UUID(), consumption: 0, goal: latestGoal, date: Date())
        dayManager.dayRepository.create(day: newDay)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Failed creating new day: \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                print("succeeded with creating new day")
                self?.saveAndFetch()
            }.store(in: &tasks)
    }

    private func fetchLastGoal() -> Double {
        var goal = 0.0
        dayManager.dayRepository.getLatestGoal()
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Failed getting last goal: \(error)")
                default:
                    break
                }
            } receiveValue: { result in
                goal = result
            }
            .store(in: &tasks)
        return goal
    }

    func fetchToday() {
        Task {
            do {
                let day = try await dayManager.fetchToday()
                self.today = day
                exportToWatch(today: day)
            } catch {
                createNewDay()
            }
        }
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

    func addDrink(_ drink: Drink) {
        let consumed = Measurement(value: drink.size, unit: UnitVolume.milliliters)
        let consumedTotal = consumed.converted(to: .liters).value + today.consumption
        dayManager.dayRepository.update(consumption: consumedTotal, for: today)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Error adding drink of type: \(drink), Error: \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.export(drink: drink)
                self?.saveAndFetch()
            }.store(in: &tasks)
    }

    func removeDrink(_ drink: Drink) {
        let consumed = Measurement(value: drink.size, unit: UnitVolume.milliliters)
        var consumedTotal: Double = today.consumption - consumed.converted(to: .liters).value

        if consumedTotal < 0 {
            consumedTotal = 0
        }
        let drink = Drink(type: drink.type, size: -drink.size)
        dayManager.dayRepository.update(consumption: consumedTotal, for: today)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Error adding drink of type: \(drink), Error: \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.export(drink: drink)
                self?.saveAndFetch()
            }.store(in: &tasks)
    }

    private func updateTodaysConsumption(to value: Double) {
        guard value != today.consumption else { return }
        dayManager.dayRepository.update(consumption: value, for: today)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Error updating todays consumption: \(value), Error: \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.saveAndFetch()
            }.store(in: &tasks)
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
                self.updateTodaysConsumption(to: consumed)
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
    private func exportToWatch(today: Day) {
        if WCSession.isSupported() {
            let message = ["phoneDate": formatter.string(from: today.date),
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

    private func handleWatch(_ data: [String: Any]) {
        fetchToday()
        guard formatter.string(from: today.date) == data["date"] as? String else { return }
        guard let watchConsumed = Double(data["consumed"] as? String ?? "0") else { return }
        guard today.consumption < watchConsumed else {
            print("Sending data to watch")
            exportToWatch(today: today)
            return
        }
        print(data)
        updateTodaysConsumption(to: watchConsumed)
        let consumed = Measurement(value: watchConsumed - today.consumption, unit: UnitVolume.liters)
        let differences = consumed.converted(to: .milliliters).value
        export(drink: Drink(size: differences))
        print("Udated with data from watch")
    }
}
