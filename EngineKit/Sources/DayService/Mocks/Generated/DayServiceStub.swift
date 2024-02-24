// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import DayServiceInterface
import DrinkServiceInterface

public protocol DayServiceTypeStubbing {
    var getToday_returnValue: Day { get set }
    var getDaysDates_returnValue: Result<[Day], Error> { get set }
    var addDrink_returnValue: Result<Double, Error> { get set }
    var removeDrink_returnValue: Result<Double, Error> { get set }
    var increaseGoal_returnValue: Result<Double, Error> { get set }
    var decreaseGoal_returnValue: Result<Double, Error> { get set }
}

public final class DayServiceTypeStub: DayServiceTypeStubbing {
    public var getToday_returnValue: Day = .default
    public var getDaysDates_returnValue: Result<[Day], Error> = .default
    public var addDrink_returnValue: Result<Double, Error> = .default
    public var removeDrink_returnValue: Result<Double, Error> = .default
    public var increaseGoal_returnValue: Result<Double, Error> = .default
    public var decreaseGoal_returnValue: Result<Double, Error> = .default

    public init() {}
}

extension DayServiceTypeStub: DayServiceType {
    public func getToday() -> Day {
        getToday_returnValue
    }

    public func getDays(between dates: ClosedRange<Date>) throws -> [Day] {
        switch getDaysDates_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func add(drink: Drink) throws -> Double {
        switch addDrink_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func remove(drink: Drink) throws -> Double {
        switch removeDrink_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func increase(goal: Double) throws -> Double {
        switch increaseGoal_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func decrease(goal: Double) throws -> Double {
        switch decreaseGoal_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

}

