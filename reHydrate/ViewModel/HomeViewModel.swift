//
//  HomeViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import Combine
import CoreData
import HealthKit
import WatchConnectivity

final class HomeViewModel: NSObject, ObservableObject {
    enum AccessType {
        case notification
        case health
    }

    @AppStorage("language") private var language = LocalizationService.shared.language
    @Preference(\.isUsingMetric) private var isMetric

    @Published var today: Day = Day(id: UUID(), consumption: 0, goal: 3, date: Date())
    @Published var drinks = [Drink(type: .small, size: 250),
                             Drink(type: .medium, size: 500),
                             Drink(type: .large, size: 750)]
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
        formatter.dateFormat = "EEEE - dd MMM"
        return formatter
    }()

    let session = WCSession.default

    init(presistenceController: PresistenceControllerProtocol,
         navigateTo: @escaping ((AppState) -> Void)) {
        self.presistenceController = presistenceController
        self.viewContext = presistenceController.container.viewContext
        self.dayManager = DayManager(context: viewContext)
        self.navigateTo = navigateTo
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
        requestNotificationAccess()
        fetchToday()
        fetchHealthData()

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
            .sink {completion in
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
                self?.saveAndFetch()
            }.store(in: &tasks)

    }

    private func fetchLastGoal() -> Double {
        var goal = 0.0
        dayManager.dayRepository.getLatestGoal()
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Failed creating new day: \(error)")
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
        dayManager.dayRepository.getDay(for: Date())
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error as CoreDataError):
                    print("Failed fetching day \(error)")
                    if error == .elementNotFound {
                        self?.createNewDay()
                    }
                default:
                    break
                }
            } receiveValue: { [weak self] day in
                if let day = day {
                    self?.today = day
                    self?.exportToWatch(today: day)
                } else {
                    self?.createNewDay()
                }
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
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print(error)
                default:
                    break
                }
            } receiveValue: { consumed in
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

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if activationState == .activated {
            print("connected to watch")
        } else {
            print("Can't connect")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Disconnected")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("Disconnected")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("Recived message from watch")
        handleWatch(message)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        print("Recived userInfo from watch")
        handleWatch(userInfo)
    }

    private func handleWatch(_ data: [String: Any]) {
        print(data)
        guard formatter.string(from: today.date) == data["date"] as? String else { return }
        guard let watchConsumed = Double(data["consumed"] as? String ?? "0") else { return }
        if today.consumption < watchConsumed {
            let consumed = Measurement(value: watchConsumed, unit: UnitVolume.liters)
            let differences = consumed.converted(to: .milliliters).value - today.consumption
            updateTodaysConsumption(to: watchConsumed)
            export(drink: Drink(size: differences))
            print("Udated with data from watch")
        } else if today.consumption != watchConsumed {
            exportToWatch(today: today)
        }
    }
}
