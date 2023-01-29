//
//  DayRepository.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreAudio
import CoreData
import Foundation

protocol DayRepositoryInterface {
    func create(day: Day) async throws
    func delete(day: Day) async throws
    func getDay(for date: Date) async throws -> Day
    func getLatestGoal() async throws -> Double?
    func getDays() async throws -> [Day]
    func update(goal: Double, for day: Date) async throws
    func update(consumption: Double, for day: Date) async throws
}

final class DayRepository: DayRepositoryInterface {
    private let repo: CoreDataManager<DayModel>
    private let defaultSort = [NSSortDescriptor(keyPath: \DayModel.date, ascending: false)]

    init(context: NSManagedObjectContext) {
        repo = CoreDataManager<DayModel>(context: context)
    }

    func create(day: Day) async throws {
        let dayModel = try await repo.create()
        dayModel.updateCoreDataModel(day)
    }

    func delete(day: Day) async throws {
        let predicate = NSPredicate(format: "id == %@", day.id.uuidString)
        let day = try await repo.get(using: predicate,
                                     sortDescriptors: defaultSort)
        repo.delete(day)
    }

    func getDay(for date: Date) async throws -> Day {
        let datePredicate = getPredicate(from: date)
        let day = try await repo.get(using: datePredicate,
                                     sortDescriptors: defaultSort)
        return day.toDomainModel()
    }

    func getLatestGoal() async throws -> Double? {
        let dayModel = try await repo.getLastObject(using: nil,
                                                    sortDescriptors: defaultSort)
        let day = dayModel?.toDomainModel()
        return day?.goal
    }

    func getDays() async throws -> [Day] {
        let dayModels = try await repo.getAll(using: nil,
                                              sortDescriptors: defaultSort)
        let days = dayModels.map { daysModel -> Day in
            daysModel.toDomainModel()
        }
        return days
    }

    func update(goal: Double, for date: Date) async throws {
        let datePredicate = getPredicate(from: date)
        let day = try await repo.get(using: datePredicate,
                                     sortDescriptors: defaultSort)
        day.goal = goal
    }

    func update(consumption: Double, for date: Date) async throws {
        let datePredicate = getPredicate(from: date)
        let day = try await repo.get(using: datePredicate,
                                     sortDescriptors: defaultSort)
        day.consumtion = consumption
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
