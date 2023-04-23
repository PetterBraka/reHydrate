import Foundation

public protocol DayRepositoryProtocol {
    func fetchDay(for date: Date) async throws -> Day
    func fetchAll() async throws -> [Day]
    func addDrink(of size: Double, to day: Day) async throws -> Day
    func removeDrink(of size: Double, to day: Day) async throws -> Day
    func update(consumption newConsumption: Double, forDayAt date: Date) async throws -> Day
    func update(goal newGoal: Double, forDayAt date: Date) async throws -> Day
}
