//
//  HomeViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import Combine
import CoreData
import Swinject

final class HomeViewModel: ObservableObject {
    @Published var today: Day = Day(id: UUID(), consumption: 0, goal: 3, date: Date())
    @Published var drinks = [Drink(type: .small, size: 250),
                             Drink(type: .medium, size: 500),
                             Drink(type: .large, size: 750)]
    @Published var showAlert: Bool = false
    @Published var interactedDrink: Drink?
    
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
        self.fetchToday()
    }
    
    func getCurrentDrink() -> String {
        if let drink = interactedDrink {
            return "\(drink.size)"
        } else {
            return ""
        }
    }
    
    func getConsumed() -> String {
        let consumed = today.consumption
        return consumed.clean
    }
    
    func getGoal() -> String {
        let goal = today.goal
        return goal.clean
    }
    
    func getDate() -> String {
        if let date = today.date {
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
        let newDay = Day(id: UUID(), consumption: 0, goal: 3, date: Date())
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
    
    private func fetchToday() {
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
                self?.saveAndFetch()
            }.store(in: &tasks)
    }
    
    func removeDrink(_ drink: Drink) {
        let consumed = Measurement(value: drink.size, unit: UnitVolume.milliliters)
        var consumedTotal: Double = today.consumption - consumed.converted(to: .liters).value
        
        if consumedTotal < 0 {
            consumedTotal = 0
        }
        dayManager.dayRepository.update(consumption: consumedTotal, for: today)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Error adding drink of type: \(drink), Error: \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.saveAndFetch()
            }.store(in: &tasks)
    }
}
