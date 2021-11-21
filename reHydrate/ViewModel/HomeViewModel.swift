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
    @Published var showAlert: Bool = false
    @Published var interactedDrink: Drink?
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd MMM"
        return formatter
    }()
    var navigateTo: (AppState) -> Void
    
    private var presistenceController: PresistenceControllerProtocol
    private var viewContext: NSManagedObjectContext
    private var tasks = Set<AnyCancellable>()
    
    var dayManager: DayManager
    
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
            } receiveValue: { [weak self] success in
                print("Success saving: \(success)")
                self?.fetchToday()
            }.store(in: &tasks)

    }
    
    func addDrink(of type: Drink) {
        let consumed = today.consumption + Double(type.size)
        dayManager.dayRepository.update(consumption: consumed, for: today)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Error adding drink of type: \(type), Error: \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] success in
                print("Added drink: \(success)")
                self?.saveAndFetch()
            }.store(in: &tasks)
    }
    
    func removeDrink(of type: Drink) {
        var consumed = today.consumption - Double(type.size)
        if consumed < 0 {
            consumed = 0
        }
        dayManager.dayRepository.update(consumption: consumed, for: today)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Error adding drink of type: \(type), Error: \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] success in
                print("Added drink: \(success)")
                self?.saveAndFetch()
            }.store(in: &tasks)
    }
}
