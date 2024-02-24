//
//  DayService.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation
import DayServiceInterface
import DrinkServiceInterface
import UnitServiceInterface
import LoggingService
import PortsInterface
import DBKitInterface

public final class DayService: DayServiceType {
    public typealias Engine = (
        HasDayManagerService &
        HasConsumptionManagerService &
        HasUnitService &
        HasLoggingService
    )
    
    private let engine: Engine
    
    private var today = Day(date: .now,
                            consumed: 0,
                            goal: 3)
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func getToday() async -> Day {
        var day: Day
        if let foundDay = try? await engine.dayManager.fetch(with: .now),
           let oldDay = Day(with: foundDay) {
            day = oldDay
        } else {
            day = await createNewDay()
        }
        self.today = day
        return day
    }
    
    public func getDays(between dates: ClosedRange<Date>) async throws -> [Day] {
        try await engine.dayManager.fetchAll()
            .compactMap { .init(with: $0) }
    }
    
    public func add(drink: Drink) async throws -> Double {
        let consumedAmount = getConsumption(from: drink)
        let today = await getToday()
        let updatedDay = try await engine.dayManager.add(consumed: consumedAmount, toDayAt: today.date)
        try engine.consumptionManager.createEntry(date: .now, consumed: consumedAmount)
        if let day = Day(with: updatedDay) {
            self.today = day
        }
        return getConsumptionTotal(from: updatedDay)
    }
    
    public func remove(drink: Drink) async throws -> Double {
        let consumedAmount = getConsumption(from: drink)
        let today = await getToday()
        let updatedDay = try await engine.dayManager.remove(consumed: consumedAmount, fromDayAt: today.date)
        try engine.consumptionManager.createEntry(date: .now, consumed: consumedAmount)
        if let day = Day(with: updatedDay) {
            self.today = day
        }
        return getConsumptionTotal(from: updatedDay)
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
}

extension Day {
    init?(with day: DayModel?) {
        guard let id = day?.id,
              let dateString = day?.date,
              let date = DatabaseFormatter.date.date(from: dateString),
              let consumed = day?.consumed,
              let goal = day?.goal
        else { return nil }
        self.init(id: id, date: date, consumed: consumed, goal: goal)
    }
}

// MARK: - Helpers
private extension DayService {
    func createNewDay() async -> Day {
        let lastDay = try? await engine.dayManager.fetchLast()
        if let createdDay = try? engine.dayManager.createNewDay(
            date: .now, goal: lastDay?.goal ?? 3),
           let newDay = Day(with: createdDay) {
            return newDay
        } else {
            let unitSystem = engine.unitService.getUnitSystem()
            let goal = engine.unitService.convert(3, from: .litres,
                                                  to: unitSystem == .metric ? .litres : .pint
            )
            return Day(date: .now, consumed: 0, goal: goal)
        }
    }
    
    func getConsumption(from drink: Drink) -> Double {
        let unitSystem = engine.unitService.getUnitSystem()
        return engine.unitService.convert(
            drink.size,
            from: unitSystem == .metric ? .millilitres : .ounces,
            to: .litres
        )
    }
    
    func getConsumptionTotal(from day: DayModel) -> Double {
        let unitSystem = engine.unitService.getUnitSystem()
        return engine.unitService.convert(
            day.consumed,
            from: .litres,
            to: unitSystem == .metric ? .litres: .pint
        )
    }
    
    func getGoal(from goal: Double) -> Double {
        let unitSystem = engine.unitService.getUnitSystem()
        return engine.unitService.convert(
            goal,
            from: unitSystem == .metric ? .litres : .pint,
            to: .litres
        )
    }
    
    func getGoalTotal(from day: DayModel) -> Double {
        let unitSystem = engine.unitService.getUnitSystem()
        return engine.unitService.convert(
            day.goal,
            from: .litres,
            to: unitSystem == .metric ? .litres : .pint
        )
    }
}
