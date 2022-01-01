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
    func update(goal: Double, for day: Day) async throws
    func update(consumption: Double, for day: Day) async throws
}

final class DayRepository: DayRepositoryInterface {
    private let repo: CoreDataRepository<DayModel>
    private let repoPredicate = NSPredicate(format: "TRUEPREDICATE")
    private let repoSortDescriptors = [NSSortDescriptor(keyPath: \DayModel.date, ascending: false)]

    init(context: NSManagedObjectContext) {
        repo = CoreDataRepository<DayModel>(context: context)
    }

    func create(day: Day) async throws {
        let dayModel = try await repo.create()
        dayModel.updateCoreDataModel(day)
    }

    func delete(day: Day) async throws {
        let day = try await repo.get(id: day.id.uuidString,
                                     predicate: repoPredicate,
                                     sortDescriptors: repoSortDescriptors)
        repo.delete(day)
    }

    func getDay(for date: Date) async throws -> Day {
        let day = try await repo.get(date: date,
                                     predicate: repoPredicate,
                                     sortDescriptors: repoSortDescriptors)
        return day.toDomainModel()
    }

    func getLatestGoal() async throws -> Double? {
        let dayModel = try await repo.getLastObject(predicate: repoPredicate)
        let day = dayModel?.toDomainModel()
        return day?.goal
    }

    func getDays() async throws -> [Day] {
        let dayModels = try await repo.getAll(predicate: repoPredicate, sortDescriptors: repoSortDescriptors)
        let days = dayModels.map { daysModel -> Day in
            daysModel.toDomainModel()
        }
        return days
    }

    func update(goal: Double, for day: Day) async throws {
        let day = try await repo.get(id: day.id.uuidString,
                                     predicate: repoPredicate,
                                     sortDescriptors: repoSortDescriptors)
        day.goal = goal
    }

    func update(consumption: Double, for day: Day) async throws {
        let day = try await repo.get(id: day.id.uuidString,
                                     predicate: repoPredicate,
                                     sortDescriptors: repoSortDescriptors)
        day.consumtion = consumption
    }
}
