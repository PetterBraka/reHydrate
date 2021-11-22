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

final class CalendarViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var selectedDays = [Day]()
    @Published var days = [Day]()
    
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
    }
    
    func navigateToHome() {
        navigateTo(.home)
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
                self?.days = days
            }.store(in: &tasks)
    }
}
