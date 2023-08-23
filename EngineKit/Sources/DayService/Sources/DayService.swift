//
//  DayService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import DayServiceInterface
import DrinkServiceInterface
import DrinkService
import DatabaseServiceInterface
import DatabaseService
import Foundation

public final class DayService: DayServiceType {
    public typealias Engine = (
        HasDayManagerService &
        HasConsumptionManagerService
    )
    
    private let engine: Engine
    
    private var today = Day(date: .now,
                          consumed: 0,
                          goal: 3)
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func getToday() async -> Day {
        guard let foundDay = try? await engine.dayManager.fetch(with: .now),
                let day = Day(with: foundDay)
        else {
            let lastDay = try? await engine.dayManager.fetchLast()
            guard let newDay = try? await engine.dayManager.createNewDay(date: .now, goal: lastDay?.goal ?? 3),
                  let day = Day(with: newDay)
            else {
                fatalError("Unable to create a new day")
            }
            self.today = day
            return day
        }
        self.today = day
        return day
    }
    
    public func add(drink: Drink) async throws -> Double {
        let consumedAmount = UnitHelper.drinkToLiters(drink)
        let today = await getToday()
        let updatedDay = try await engine.dayManager.add(consumedAmount, toDayAt: today.date)
        try await engine.consumptionManager.createEntry(date: .now, consumed: consumedAmount)
        if let updatedDay = Day(with: updatedDay) {
            self.today = updatedDay
        }
        return updatedDay.consumed
    }
    
    public func remove(drink: Drink) async throws -> Double {
        let consumedAmount = UnitHelper.drinkToLiters(drink)
        let today = await getToday()
        let updatedDay = try await engine.dayManager.remove(consumedAmount, fromDayAt: today.date)
        try await engine.consumptionManager.createEntry(date: .now, consumed: consumedAmount)
        if let updatedDay = Day(with: updatedDay) {
            self.today = updatedDay
        }
        return updatedDay.consumed
    }
}

extension Day {
    init?(with day: DayModel) {
        guard let date = dbDateFormatter.date(from: day.date)
        else { return nil }
        self.init(id: day.id,
                 date: date,
                 consumed: day.consumed,
                 goal: day.goal)
    }
}
