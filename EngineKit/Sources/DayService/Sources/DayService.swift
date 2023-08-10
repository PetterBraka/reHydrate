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
    
    private var day = Day(date: .now,
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
            self.day = day
            return day
        }
        self.day = day
        return day
    }
    
    public func add(drink: Drink) -> Double {
        let consumedAmount = UnitHelper.drinkToLiters(drink)
        day.consumed += consumedAmount
        Task {
            try await engine.dayManager.update(consumed: day.consumed, forDayAt: day.date)
            try await engine.consumptionManager.createEntry(date: .now, consumed: consumedAmount)
        }
        return day.consumed
    }
    
    public func remove(drink: Drink) -> Double {
        let consumedAmount = -UnitHelper.drinkToLiters(drink)
        day.consumed += UnitHelper.drinkToLiters(drink)
        if day.consumed < 0 {
            day.consumed = 0
        }
        Task {
            try await engine.dayManager.update(consumed: day.consumed, forDayAt: day.date)
            try await engine.consumptionManager.createEntry(date: .now, consumed: consumedAmount)
        }
        return day.consumed
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
