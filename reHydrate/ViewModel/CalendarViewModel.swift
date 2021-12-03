//
//  CalendarViewModel.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 22/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import Combine
import CoreData
import Swinject
import SwiftUI
import SwiftyUserDefaults

final class CalendarViewModel: ObservableObject {
    @Preference(\.languages) private var local
    
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
        self.viewContext = presistenceController.container.viewContext
        self.dayManager = DayManager(context: viewContext)
        self.navigateTo = navigateTo
        self.fetchDays()
        formatter.locale = .init(identifier: local)
        setUpSubscriptions()
    }
    
    func setUpSubscriptions() {
        $selectedDays
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
        let day = days.last
        let consumed = day?.consumption.clean
        let goal = day?.goal.clean
        self.consumtion = "\(consumed ?? "0")/\(goal ?? "0")L"
        self.header = formatter.string(from: day?.date ?? Date())
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
        self.fetchDays()
    }
}

//MARK: Save & Load
extension CalendarViewModel {
    private func fetchDays() {
        dayManager.dayRepository.getDays()
            .sink { completion in
                switch completion {
                case let .failure(error as CoreDataError):
                    print("Failed fetching days \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] days in
                self?.storedDays = days
                self?.getConsumed(for: days)
                self?.getAverage(for: days)
            }.store(in: &tasks)
    }
}
