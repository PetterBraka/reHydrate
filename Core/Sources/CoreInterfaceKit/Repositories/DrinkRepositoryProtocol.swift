import Foundation

public protocol DrinkRepositoryProtocol {
    associatedtype DrinkProtocol
    func fetchDrinks(for date: Date) async throws -> [DrinkProtocol]
    func remove(drink: DrinkProtocol) async throws
    func addDrink(_ size: Double, _ type: DrinkType) async throws -> DrinkProtocol
    func update(sizeOf size: Double, drink: DrinkProtocol) async throws -> DrinkProtocol
}
