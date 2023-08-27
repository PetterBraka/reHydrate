//
//  DayService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation
import DayServiceInterface
import DrinkServiceInterface
import DatabaseServiceInterface
import UnitServiceInterface

public final class DayService: DayServiceType {
    public typealias Engine = (
        HasDayManagerService &
        HasConsumptionManagerService &
        HasUnitService
    )
    
    private let engine: Engine
    
    private var today = Day(date: .now,
                          consumed: 0,
                          goal: 3)
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func getToday() async throws -> Day {
        if let foundDay = try? await engine.dayManager.fetch(with: .now) {
            let day = Day(with: foundDay)
            self.today = day
            return day
        } else {
            let lastDay = try? await engine.dayManager.fetchLast()
            let newDay = try await engine.dayManager.createNewDay(date: .now, goal: lastDay?.goal ?? 3)
            let day = Day(with: newDay)
            self.today = day
            return day
        }
    }
    
    public func add(drink: Drink) async throws -> Double {
        let consumedAmount = getConsumption(from: drink)
        let today = try await getToday()
        let updatedDay = try await engine.dayManager.add(consumed: consumedAmount, toDayAt: today.date)
        try await engine.consumptionManager.createEntry(date: .now, consumed: consumedAmount)
        let day = Day(with: updatedDay)
        self.today = day
        return getConsumptionTotal(from: day)
    }
    
    public func remove(drink: Drink) async throws -> Double {
        let consumedAmount = getConsumption(from: drink)
        let today = try await getToday()
        let updatedDay = try await engine.dayManager.remove(consumed: consumedAmount, fromDayAt: today.date)
        try await engine.consumptionManager.createEntry(date: .now, consumed: consumedAmount)
        let day = Day(with: updatedDay)
        self.today = day
        return getConsumptionTotal(from: day)
    }
    
    private func getConsumption(from drink: Drink) -> Double {
        let unitSystem = engine.unitService.getUnitSystem()
        return engine.unitService.convert(
            drink.size,
            from: unitSystem == .metric ? .millilitres : .ounces,
            to: .litres
        )
    }
    
    private func getConsumptionTotal(from day: Day) -> Double {
        let unitSystem = engine.unitService.getUnitSystem()
        return engine.unitService.convert(
            day.consumed,
            from: .litres,
            to: unitSystem == .metric ? .millilitres : .ounces
        )
    }
    }
}

extension Day {
    init(with day: DayModel) {
        guard let date = dbDateFormatter.date(from: day.date)
        else {
            fatalError("Invalid date format")
        }
        self.init(id: day.id,
                 date: date,
                 consumed: day.consumed,
                 goal: day.goal)
    }
}
