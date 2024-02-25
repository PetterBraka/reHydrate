// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import DayServiceInterface
import DrinkServiceInterface

public protocol DayServiceTypeSpying {
    var variableLog: [DayServiceTypeSpy.VariableName] { get set }
    var methodLog: [DayServiceTypeSpy.MethodName] { get set }
}

public final class DayServiceTypeSpy: DayServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
            case getToday
            case getDays_between
            case add_drink
            case remove_drink
            case increase_goal
            case decrease_goal
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: DayServiceType
    public init(realObject: DayServiceType) {
        self.realObject = realObject
    }
}

extension DayServiceTypeSpy: DayServiceType {
    public func getToday() async -> Day {
        methodLog.append(.getToday)
        return await realObject.getToday()
    }
    public func getDays(between dates: ClosedRange<Date>) async throws -> [Day] {
        methodLog.append(.getDays_between)
        return try await realObject.getDays(between: dates)
    }
    public func add(drink: Drink) async throws -> Double {
        methodLog.append(.add_drink)
        return try await realObject.add(drink: drink)
    }
    public func remove(drink: Drink) async throws -> Double {
        methodLog.append(.remove_drink)
        return try await realObject.remove(drink: drink)
    }
    public func increase(goal: Double) async throws -> Double {
        methodLog.append(.increase_goal)
        return try await realObject.increase(goal: goal)
    }
    public func decrease(goal: Double) async throws -> Double {
        methodLog.append(.decrease_goal)
        return try await realObject.decrease(goal: goal)
    }
}
