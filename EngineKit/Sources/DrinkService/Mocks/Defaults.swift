import Foundation
import DrinkServiceInterface

extension Drink {
    static let `default` = Drink(id: UUID().uuidString, size: -999, container: .small)
}

extension Array where Element == Drink {
    static let `default` = [Drink.default]
}

extension Result where Success == Drink, Failure == Error {
    static let `default` = Result<Drink, Error>.success(.default)
}

extension Result where Success == [Drink], Failure == Error {
    static let `default` = Result<[Drink], Error>.success(.default)
}

extension Result where Success == Void, Failure == Error {
    static let `default` = Result<Void, Error>.success(Void())
}
