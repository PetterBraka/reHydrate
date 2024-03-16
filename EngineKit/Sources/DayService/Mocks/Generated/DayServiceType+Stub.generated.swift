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
    public var getToday_returnValue: Day {
        get {
            if getToday_returnValues.first != nil {
                getToday_returnValues.removeFirst()
            } else {
                .default
            }
        }
        set {
            getToday_returnValues.append(newValue)
        }
    }
    private var getToday_returnValues: [Day] = []
    public var getDaysDates_returnValue: Result<[Day], Error> {
        get {
            if getDaysDates_returnValues.first != nil {
                getDaysDates_returnValues.removeFirst()
            } else {
                .default
            }
        }
        set {
            getDaysDates_returnValues.append(newValue)
        }
    }
    private var getDaysDates_returnValues: [Result<[Day], Error>] = []
    public var addDrink_returnValue: Result<Double, Error> {
        get {
            if addDrink_returnValues.first != nil {
                addDrink_returnValues.removeFirst()
            } else {
                .default
            }
        }
        set {
            addDrink_returnValues.append(newValue)
        }
    }
    private var addDrink_returnValues: [Result<Double, Error>] = []
    public var removeDrink_returnValue: Result<Double, Error> {
        get {
            if removeDrink_returnValues.first != nil {
                removeDrink_returnValues.removeFirst()
            } else {
                .default
            }
        }
        set {
            removeDrink_returnValues.append(newValue)
        }
    }
    private var removeDrink_returnValues: [Result<Double, Error>] = []
    public var increaseGoal_returnValue: Result<Double, Error> {
        get {
            if increaseGoal_returnValues.first != nil {
                increaseGoal_returnValues.removeFirst()
            } else {
                .default
            }
        }
        set {
            increaseGoal_returnValues.append(newValue)
        }
    }
    private var increaseGoal_returnValues: [Result<Double, Error>] = []
    public var decreaseGoal_returnValue: Result<Double, Error> {
        get {
            if decreaseGoal_returnValues.first != nil {
                decreaseGoal_returnValues.removeFirst()
            } else {
                .default
            }
        }
        set {
            decreaseGoal_returnValues.append(newValue)
        }
    }
    private var decreaseGoal_returnValues: [Result<Double, Error>] = []

    public init() {}
}

extension DayServiceTypeStub: DayServiceType {
    public func getToday() async -> Day {
        getToday_returnValue
    }

    public func getDays(between dates: ClosedRange<Date>) async throws -> [Day] {
        switch getDaysDates_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func add(drink: Drink) async throws -> Double {
        switch addDrink_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func remove(drink: Drink) async throws -> Double {
        switch removeDrink_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func increase(goal: Double) async throws -> Double {
        switch increaseGoal_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func decrease(goal: Double) async throws -> Double {
        switch decreaseGoal_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

}
