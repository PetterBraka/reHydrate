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
    
    public func getToday() async -> Day {
        if let foundDay = try? await engine.dayManager.fetch(with: .now),
           let day = Day(with: foundDay) {
            self.today = day
            return day
        } else {
            let lastDay = try? await engine.dayManager.fetchLast()
            if let newDay = try? await engine.dayManager.createNewDay(date: .now, goal: lastDay?.goal ?? 3),
               let day = Day(with: newDay) {
                self.today = day
                return day
            } else {
                let unitSystem = engine.unitService.getUnitSystem()
                let goal = engine.unitService.convert(
                    3, from: .litres,
                    to: unitSystem == .metric ? .litres : .pint
                )
                let day = Day(date: .now, consumed: 0, goal: goal)
                self.today = day
                return day
            }
        }
    }
    
    public func add(drink: Drink) async throws -> Double {
        let consumedAmount = getConsumption(from: drink)
        let today = await getToday()
        let updatedDay = try await engine.dayManager.add(consumed: consumedAmount, toDayAt: today.date)
        try await engine.consumptionManager.createEntry(date: .now, consumed: consumedAmount)
        if let day = Day(with: updatedDay) {
            self.today = day
        }
        return getConsumptionTotal(from: updatedDay)
    }
    
    public func remove(drink: Drink) async throws -> Double {
        let consumedAmount = getConsumption(from: drink)
        let today = await getToday()
        let updatedDay = try await engine.dayManager.remove(consumed: consumedAmount, fromDayAt: today.date)
        try await engine.consumptionManager.createEntry(date: .now, consumed: consumedAmount)
        if let day = Day(with: updatedDay) {
            self.today = day
        }
        return getConsumptionTotal(from: updatedDay)
    }
    
    private func getConsumption(from drink: Drink) -> Double {
        let unitSystem = engine.unitService.getUnitSystem()
        return engine.unitService.convert(
            drink.size,
            from: unitSystem == .metric ? .millilitres : .ounces,
            to: .litres
        )
    }
    
    private func getConsumptionTotal(from day: DayModel) -> Double {
        let unitSystem = engine.unitService.getUnitSystem()
        return engine.unitService.convert(
            day.consumed,
            from: .litres,
            to: unitSystem == .metric ? .litres: .pint
        )
    }
    
    public func increase(goal: Double) async throws -> Double {
        let goal = getGoal(from: goal)
        let today = await getToday()
        let updatedDay = try await engine.dayManager.add(goal: goal, toDayAt: today.date)
        if let day = Day(with: updatedDay) {
            self.today = day
        }
        return getGoalTotal(from: updatedDay)
    }
    
    public func decrease(goal: Double) async throws -> Double {
        let goal = getGoal(from: goal)
        let today = await getToday()
        let updatedDay = try await engine.dayManager.remove(goal: goal, fromDayAt: today.date)
        if let day = Day(with: updatedDay) {
            self.today = day
        }
        return getGoalTotal(from: updatedDay)
    }
    
    private func getGoal(from goal: Double) -> Double {
        let unitSystem = engine.unitService.getUnitSystem()
        return engine.unitService.convert(
            goal,
            from: unitSystem == .metric ? .litres : .pint,
            to: .litres
        )
    }
    
    private func getGoalTotal(from day: DayModel) -> Double {
        let unitSystem = engine.unitService.getUnitSystem()
        return engine.unitService.convert(
            day.goal,
            from: .litres,
            to: unitSystem == .metric ? .litres : .pint
        )
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
