//
//  DayManager.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreData
import Foundation

final class DayManager {
    private let context: NSManagedObjectContext
    let dayRepository: DayService

    init(context: NSManagedObjectContext) {
        self.context = context
        dayRepository = DayService(context: context)
    }

    func saveChanges() async throws {
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }

    func createToday() async throws -> Day {
        let previusGoal = try await dayRepository.getLatestGoal()
        let today = Day(id: UUID(), consumption: 0, goal: previusGoal ?? 3, date: Date())
        try await dayRepository.create(day: today)
        try await saveChanges()
        return today
    }

    func fetchToday() async throws -> Day {
        try await dayRepository.getDay(for: Date())
    }

    func addDrink(of size: Double, to day: Day) async throws {
        let consumedTotal = size + day.consumption
        try await dayRepository.update(consumption: consumedTotal, for: day.date)
        try await saveChanges()
    }

    func removeDrink(of size: Double, to day: Day) async throws {
        var consumedTotal: Double = day.consumption - size

        if consumedTotal < 0 {
            consumedTotal = 0
        }

        try await dayRepository.update(consumption: consumedTotal, for: day.date)
        try await saveChanges()
    }

    func update(consumption value: Double, for date: Date) async throws {
        try await dayRepository.update(consumption: value, for: date)
        try await saveChanges()
    }

    func update(goal newGoal: Double, for date: Date) async throws {
        try await dayRepository.update(goal: newGoal, for: date)
        try await saveChanges()
    }
}
