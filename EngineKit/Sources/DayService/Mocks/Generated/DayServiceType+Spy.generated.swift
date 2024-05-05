// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import DayServiceInterface
import DrinkServiceInterface

public protocol DayServiceTypeSpying {
    var variableLog: [DayServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: DayServiceTypeSpy.VariableName? { get }
    var methodLog: [DayServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: DayServiceTypeSpy.MethodCall? { get }
}

public final class DayServiceTypeSpy: DayServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case getToday
        case getDays(dates: ClosedRange<Date>)
        case add(drink: Drink)
        case remove(drink: Drink)
        case increase(goal: Double)
        case decrease(goal: Double)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
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
        methodLog.append(.getDays(dates: dates))
        return try await realObject.getDays(between: dates)
    }
    public func add(drink: Drink) async throws -> Double {
        methodLog.append(.add(drink: drink))
        return try await realObject.add(drink: drink)
    }
    public func remove(drink: Drink) async throws -> Double {
        methodLog.append(.remove(drink: drink))
        return try await realObject.remove(drink: drink)
    }
    public func increase(goal: Double) async throws -> Double {
        methodLog.append(.increase(goal: goal))
        return try await realObject.increase(goal: goal)
    }
    public func decrease(goal: Double) async throws -> Double {
        methodLog.append(.decrease(goal: goal))
        return try await realObject.decrease(goal: goal)
    }
}
