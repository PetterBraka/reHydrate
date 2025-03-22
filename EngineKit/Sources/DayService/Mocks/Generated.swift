// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import DayServiceInterface
import DrinkServiceInterface

public protocol DayServiceTypeSpying {
    var variableLog: [DayServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: DayServiceTypeSpy.VariableName? { get }
    var methodLog: [DayServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: DayServiceTypeSpy.MethodCall? { get }
    var methodNameLog: [DayServiceTypeSpy.MethodName] { get set }
}

public final class DayServiceTypeSpy: DayServiceTypeSpying {
    public enum VariableName: Equatable {
    }

    public enum MethodCall {
        case getToday
        case getDaysDates(dates: ClosedRange<Date>)
        case addDrink(drink: Drink)
        case removeDrink(drink: Drink)
        case increaseGoal(goal: Double)
        case decreaseGoal(goal: Double)
    }

    public enum MethodName {
        case getToday
        case getDaysDates
        case addDrink
        case removeDrink
        case increaseGoal
        case decreaseGoal
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: DayServiceType
    public init(realObject: DayServiceType) {
        self.realObject = realObject
    }
}

extension DayServiceTypeSpy: DayServiceType {
    public func getToday() async -> Day {
        methodNameLog.append(.getToday)
        methodLog.append(.getToday)
        return await realObject.getToday()
    }
    public func getDays(between dates: ClosedRange<Date>) async throws -> [Day] {
        methodNameLog.append(.getDaysDates)
        methodLog.append(.getDaysDates(dates: dates))
        return try await realObject.getDays(between: dates)
    }
    public func add(drink: Drink) async throws -> Double {
        methodNameLog.append(.addDrink)
        methodLog.append(.addDrink(drink: drink))
        return try await realObject.add(drink: drink)
    }
    public func remove(drink: Drink) async throws -> Double {
        methodNameLog.append(.removeDrink)
        methodLog.append(.removeDrink(drink: drink))
        return try await realObject.remove(drink: drink)
    }
    public func increase(goal: Double) async throws -> Double {
        methodNameLog.append(.increaseGoal)
        methodLog.append(.increaseGoal(goal: goal))
        return try await realObject.increase(goal: goal)
    }
    public func decrease(goal: Double) async throws -> Double {
        methodNameLog.append(.decreaseGoal)
        methodLog.append(.decreaseGoal(goal: goal))
        return try await realObject.decrease(goal: goal)
    }
}

extension DayServiceTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension DayServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .getToday: "getToday"
        case .getDaysDates(let dates): "getDays(dates: \(String(describing: dates)))"
        case .addDrink(let drink): "add(drink: \(String(describing: drink)))"
        case .removeDrink(let drink): "remove(drink: \(String(describing: drink)))"
        case .increaseGoal(let goal): "increase(goal: \(String(describing: goal)))"
        case .decreaseGoal(let goal): "decrease(goal: \(String(describing: goal)))"
        }
    }
}

extension DayServiceTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .getToday: "getToday"
        case .getDaysDates: "getDaysDates"
        case .addDrink: "addDrink"
        case .removeDrink: "removeDrink"
        case .increaseGoal: "increaseGoal"
        case .decreaseGoal: "decreaseGoal"
        }
    }
}

// MARK: - AutoString
// swiftlint:disable all

import DayServiceInterface
import DrinkServiceInterface

extension Day: CustomStringConvertible {
    public var description: String {
        "Day(id: \(String(describing: id)) date: \(String(describing: date)) consumed: \(String(describing: consumed)) goal: \(String(describing: goal)) )"
    }
}


// MARK: - AutoStub
// swiftlint:disable all  
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
            if getToday_returnValues.isEmpty {
                .default
            } else {
                getToday_returnValues.removeFirst()
            }
        }
        set {
            getToday_returnValues.append(newValue)
        }
    }
    private var getToday_returnValues: [Day] = []
    public var getDaysDates_returnValue: Result<[Day], Error> {
        get {
            if getDaysDates_returnValues.isEmpty {
                .default
            } else {
                getDaysDates_returnValues.removeFirst()
            }
        }
        set {
            getDaysDates_returnValues.append(newValue)
        }
    }
    private var getDaysDates_returnValues: [Result<[Day], Error>] = []
    public var addDrink_returnValue: Result<Double, Error> {
        get {
            if addDrink_returnValues.isEmpty {
                .default
            } else {
                addDrink_returnValues.removeFirst()
            }
        }
        set {
            addDrink_returnValues.append(newValue)
        }
    }
    private var addDrink_returnValues: [Result<Double, Error>] = []
    public var removeDrink_returnValue: Result<Double, Error> {
        get {
            if removeDrink_returnValues.isEmpty {
                .default
            } else {
                removeDrink_returnValues.removeFirst()
            }
        }
        set {
            removeDrink_returnValues.append(newValue)
        }
    }
    private var removeDrink_returnValues: [Result<Double, Error>] = []
    public var increaseGoal_returnValue: Result<Double, Error> {
        get {
            if increaseGoal_returnValues.isEmpty {
                .default
            } else {
                increaseGoal_returnValues.removeFirst()
            }
        }
        set {
            increaseGoal_returnValues.append(newValue)
        }
    }
    private var increaseGoal_returnValues: [Result<Double, Error>] = []
    public var decreaseGoal_returnValue: Result<Double, Error> {
        get {
            if decreaseGoal_returnValues.isEmpty {
                .default
            } else {
                decreaseGoal_returnValues.removeFirst()
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
