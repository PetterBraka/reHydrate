import Foundation

public protocol DayRepositoryProtocol {
    associatedtype DayProtocol
    func fetchDay(for date: Date) async throws -> DayProtocol
    func fetchAll() async throws -> [DayProtocol]
    func addDrink(of size: Double, to day: DayProtocol) async throws -> DayProtocol
    func removeDrink(of size: Double, to day: DayProtocol) async throws -> DayProtocol
    func update(consumption newConsumption: Double, forDayAt date: Date) async throws -> DayProtocol
    func update(goal newGoal: Double, forDayAt date: Date) async throws -> DayProtocol
}
