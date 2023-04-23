import Foundation

public protocol DrinkRepositoryProtocol {
    func fetchDrinks(for date: Date) async throws -> [Drink]
    func remove(drink: Drink) async throws
    func addDrink(_ size: Double) async throws -> Drink
    func update(sizeOf size: Double, drink: Drink) async throws -> Drink
}
