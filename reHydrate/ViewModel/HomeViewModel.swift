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
import Swinject
import HealthKit

final class HomeViewModel: ObservableObject {
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
    
    init(presistenceController: PresistenceControllerProtocol,
         navigateTo: @escaping ((AppState) -> Void)) {
        self.presistenceController = presistenceController
        self.viewContext = presistenceController.container.viewContext
        self.dayManager = DayManager(context: viewContext)
        self.navigateTo = navigateTo
        self.requestNotificationAccess()
        self.fetchToday()
        self.fetchHealthData()
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

//MARK: Save & Load
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
                } else {
                    self?.createNewDay()
                }
            }.store(in: &tasks)
    }
    
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
                print(consumed)
                self.updateTodaysConsumption(to: consumed)
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
    
    private func export(drink: Drink) {
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
