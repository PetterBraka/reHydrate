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
    func fetchDay(for date: Date) async throws -> Day
    func fetchAll() async throws -> [Day]
    func addDrink(of size: Double, to day: Day) async throws -> Day
    func removeDrink(of size: Double, to day: Day) async throws -> Day
    func update(consumption newConsumption: Double, forDayAt date: Date) async throws -> Day
    func update(goal newGoal: Double, forDayAt date: Date) async throws -> Day
}

final class DayRepository: DayRepositoryProtocol {
    let service: DayService

    init(service: DayService) {
        self.service = service
    }
    
    func fetchDay(for date: Date) async throws -> Day {
        if let today = try? await service.getElement(for: date) {
            return today.toDomainModel()
        } else {
            return try await createToday()
        }
    }
    
    func fetchAll() async throws -> [Day] {
        let dayModels = try await service.getAll()
        return dayModels.map { $0.toDomainModel() }
    }

    private func createToday() async throws -> Day {
        let previusGoal = try await service.getLatestElement().goal
        let today = Day(id: UUID(), consumption: 0, goal: previusGoal, date: Date())
        return try await service.create(today).toDomainModel()
    }

    func addDrink(of size: Double, to day: Day) async throws -> Day {
        let consumedTotal = size + day.consumption
        return try await set(consumption: consumedTotal, forDayAt: day.date).toDomainModel()
    }

    func removeDrink(of size: Double, to day: Day) async throws -> Day {
        var consumedTotal: Double = day.consumption - size

        if consumedTotal < 0 {
            consumedTotal = 0
        }

        return try await set(consumption: consumedTotal, forDayAt: day.date).toDomainModel()
    }

    func update(consumption newConsumption: Double, forDayAt date: Date) async throws -> Day {
        try await set(consumption: newConsumption, forDayAt: date).toDomainModel()
    }

    func update(goal newGoal: Double, forDayAt date: Date) async throws -> Day {
        try await set(goal: newGoal, forDayAt: date).toDomainModel()
    }
    
    private func set(goal newGoal: Double? = nil,
                        consumption newConsumption: Double? = nil,
                        forDayAt date: Date) async throws -> DayModel{
        let day = try await service.getElement(for: date)
        if let newGoal {
            day.goal = newGoal
        }
        if let newConsumption {
            day.consumtion = newConsumption
        }
        try await service.save()
        return day
    }
}
