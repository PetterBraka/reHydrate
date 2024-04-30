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
            if getToday_returnValues.count > 0 {
                let value = getToday_returnValues.removeFirst()
                if getToday_returnValues.isEmpty {
                    getToday_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return getToday_returnValues.first ?? .default
            }
        }
        set {
            getToday_returnValues.append(newValue)
        }
    }
    private var getToday_returnValues: [Day] = []
    public var getDaysDates_returnValue: Result<[Day], Error> {
        get {
            if getDaysDates_returnValues.count > 0 {
                let value = getDaysDates_returnValues.removeFirst()
                if getDaysDates_returnValues.isEmpty {
                    getDaysDates_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return getDaysDates_returnValues.first ?? .default
            }
        }
        set {
            getDaysDates_returnValues.append(newValue)
        }
    }
    private var getDaysDates_returnValues: [Result<[Day], Error>] = []
    public var addDrink_returnValue: Result<Double, Error> {
        get {
            if addDrink_returnValues.count > 0 {
                let value = addDrink_returnValues.removeFirst()
                if addDrink_returnValues.isEmpty {
                    addDrink_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return addDrink_returnValues.first ?? .default
            }
        }
        set {
            addDrink_returnValues.append(newValue)
        }
    }
    private var addDrink_returnValues: [Result<Double, Error>] = []
    public var removeDrink_returnValue: Result<Double, Error> {
        get {
            if removeDrink_returnValues.count > 0 {
                let value = removeDrink_returnValues.removeFirst()
                if removeDrink_returnValues.isEmpty {
                    removeDrink_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return removeDrink_returnValues.first ?? .default
            }
        }
        set {
            removeDrink_returnValues.append(newValue)
        }
    }
    private var removeDrink_returnValues: [Result<Double, Error>] = []
    public var increaseGoal_returnValue: Result<Double, Error> {
        get {
            if increaseGoal_returnValues.count > 0 {
                let value = increaseGoal_returnValues.removeFirst()
                if increaseGoal_returnValues.isEmpty {
                    increaseGoal_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return increaseGoal_returnValues.first ?? .default
            }
        }
        set {
            increaseGoal_returnValues.append(newValue)
        }
    }
    private var increaseGoal_returnValues: [Result<Double, Error>] = []
    public var decreaseGoal_returnValue: Result<Double, Error> {
        get {
            if decreaseGoal_returnValues.count > 0 {
                let value = decreaseGoal_returnValues.removeFirst()
                if decreaseGoal_returnValues.isEmpty {
                    decreaseGoal_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return decreaseGoal_returnValues.first ?? .default
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
