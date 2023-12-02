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
import LoggingService
import PortsInterface

public final class DayService: DayServiceType {
    public typealias Engine = (
        HasDayManagerService &
        HasConsumptionManagerService &
        HasUnitService &
        HasHealthService &
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
        await requestHealthAccessIfNeeded()
        let healthTotal = await getHealthTotal()
        if let foundDay = try? await engine.dayManager.fetch(with: .now),
           let oldDay = Day(with: foundDay) {
            day = oldDay
        } else {
            day = await createNewDay()
        }
        let diff = healthTotal - day.consumed
        if diff > 0,
           let updatedDay = try? await engine.dayManager.add(consumed: diff, toDayAt: day.date),
           let updatedDay = Day(with: updatedDay) {
            day = updatedDay
        }
        self.today = day
        return day
    }
    
    public func getDays(for dates: [Date]) async -> [Day] {
        var days: [Day] = []
        for date in dates {
            let foundDay = try? await engine.dayManager.fetch(with: date)
            if let day = Day(with: foundDay) {
                days.append(day)
            }
        }
        return days
    }
    
    public func add(drink: Drink) async throws -> Double {
        let consumedAmount = getConsumption(from: drink)
        let today = await getToday()
        let updatedDay = try await engine.dayManager.add(consumed: consumedAmount, toDayAt: today.date)
        try await engine.consumptionManager.createEntry(date: .now, consumed: consumedAmount)
        await export(litres: consumedAmount)
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
        await export(litres: -consumedAmount)
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
              let date = dbDateFormatter.date(from: dateString),
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
        if let createdDay = try? await engine.dayManager.createNewDay(
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

// MARK: Health
private extension DayService {
    func requestHealthAccessIfNeeded() async {
        let healthData = [HealthDataType.water(.litre)]
        guard engine.healthService.isSupported,
              await engine.healthService.shouldRequestAccess(for: healthData)
        else { return }
        do {
            try await engine.healthService.requestAuth(toReadAndWrite: Set(healthData))
        } catch {
            engine.logger.error("Could get access to health", error: error)
        }
    }
    
    func export(litres: Double) async {
        do {
            try await engine.healthService.export(quantity: .init(unit: .litre, value: litres),
                                                  id: .dietaryWater, date: .now)
        } catch {
            engine.logger.error("Could not export to health \(litres)", error: error)
        }
    }
    
    func getHealthTotal() async -> Double {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                let query = HealthQuery.sum(
                    start: .now.startOfDay,
                    end: .now.endOfDay ?? .now,
                    intervalComponents: .init(day: 1)
                ) { result in
                    continuation.resume(with: result)
                }
                engine.healthService.read(.water(.litre), queryType: query)
            }
        } catch {
            engine.logger.error("Couldn't get health data", error: error)
            return 0
        }
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)
    }
}
