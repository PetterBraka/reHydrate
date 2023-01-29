//
//  DayRepository.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import Foundation

protocol DayRepositoryProtocol {
    
}

final class DayRepository {
    let service: DayServiceProtocol = MainAssembler.resolve()

    init() {}
    
    func fetchDay(for date: Date = .now) async throws -> Day {
        if let today = try? await service.getDay(for: date) {
            return today
        } else {
            return try await createToday()
        }
    }

    private func createToday() async throws -> Day {
        let previusGoal = try await service.getLatestGoal()
        let today = Day(id: UUID(), consumption: 0, goal: previusGoal ?? 3, date: Date())
        try await service.create(day: today)
        return today
    }

    func addDrink(of size: Double, to day: Day) async throws {
        let consumedTotal = size + day.consumption
        try await service.update(consumption: consumedTotal, for: day.date)
    }

    func removeDrink(of size: Double, to day: Day) async throws {
        var consumedTotal: Double = day.consumption - size

        if consumedTotal < 0 {
            consumedTotal = 0
        }

        try await service.update(consumption: consumedTotal, for: day.date)
    }

    func update(consumption value: Double, for date: Date) async throws {
        try await service.update(consumption: value, for: date)
    }

    func update(goal newGoal: Double, for date: Date) async throws {
        try await service.update(goal: newGoal, for: date)
    }
}
