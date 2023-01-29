//
//  DayService.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreData
import Foundation

protocol DayServiceProtocol {
    func create(day: Day) async throws
    func delete(day: Day) async throws
    func getDay(for date: Date) async throws -> Day
    func getLatestGoal() async throws -> Double?
    func getDays() async throws -> [Day]
    func update(goal: Double, for day: Date) async throws
    func update(consumption: Double, for day: Date) async throws
}

final class DayService: DayServiceProtocol {
    private let manager: CoreDataManager<DayModel>
    private let defaultSort = [NSSortDescriptor(keyPath: \DayModel.date, ascending: false)]
    
    init(context: NSManagedObjectContext) {
        manager = CoreDataManager<DayModel>(context: context)
    }
    
    func create(day: Day) async throws {
        let dayModel = try await manager.create()
        dayModel.updateCoreDataModel(day)
        try await manager.saveChanges()
    }
    
    func save() async throws {
        try await manager.saveChanges()
    }
    
    func delete(day: Day) async throws {
        let predicate = NSPredicate(format: "id == %@", day.id.uuidString)
        let day = try await manager.get(using: predicate,
                                        sortDescriptors: defaultSort)
        manager.delete(day)
        try await manager.saveChanges()
    }
    
    func getDay(for date: Date) async throws -> Day {
        let datePredicate = getPredicate(from: date)
        let day = try await manager.get(using: datePredicate,
                                        sortDescriptors: defaultSort)
        return day.toDomainModel()
    }
    
    func getLatestGoal() async throws -> Double? {
        let dayModel = try await manager.getLastObject(using: nil,
                                                       sortDescriptors: defaultSort)
        let day = dayModel?.toDomainModel()
        return day?.goal
    }
    
    func getDays() async throws -> [Day] {
        let dayModels = try await manager.getAll(using: nil,
                                                 sortDescriptors: defaultSort)
        let days = dayModels.map { $0.toDomainModel() }
        return days
    }
    
    func update(goal: Double, for date: Date) async throws {
        let datePredicate = getPredicate(from: date)
        let day = try await manager.get(using: datePredicate,
                                        sortDescriptors: defaultSort)
        day.goal = goal
        try await manager.saveChanges()
    }
    
    func update(consumption: Double, for date: Date) async throws {
        let datePredicate = getPredicate(from: date)
        let day = try await manager.get(using: datePredicate,
                                        sortDescriptors: defaultSort)
        day.consumtion = consumption
        try await manager.saveChanges()
    }
    
    private func getPredicate(from date: Date) -> NSCompoundPredicate {
        // Get day's beginning & tomorrows beginning time
        let startOfDay = Calendar.current.startOfDay(for: date)
        let startOfNextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
        // Sets conditions for date to be within day
        let fromPredicate = NSPredicate(format: "date >= %@", startOfDay as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", startOfNextDay! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                                                    [fromPredicate, toPredicate])
        return datePredicate
    }
}
