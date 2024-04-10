// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import DateServiceInterface

public protocol DateServiceTypeSpying {
    var variableLog: [DateServiceTypeSpy.VariableName] { get set }
    var lastvariabelCall: DateServiceTypeSpy.VariableName? { get }
    var methodLog: [DateServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: DateServiceTypeSpy.MethodCall? { get }
}

public final class DateServiceTypeSpy: DateServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case now
        case daysBetween(start: Date, end: Date)
        case get(component: Component, date: Date)
        case getDate(value: Int, component: Component, date: Date)
        case getStart(date: Date)
        case getEnd(date: Date)
        case isDate(date: Date, inSameDayAs: Date)
    }

    public var variableLog: [VariableName] = []
    public var lastvariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private let realObject: DateServiceType
    public init(realObject: DateServiceType) {
        self.realObject = realObject
    }
}

extension DateServiceTypeSpy: DateServiceType {
    public func now() -> Date {
        methodLog.append(.now)
        return realObject.now()
    }
    public func daysBetween(_ start: Date, end: Date) -> Int {
        methodLog.append(.daysBetween(start: start, end: end))
        return realObject.daysBetween(start, end: end)
    }
    public func get(component: Component, from date: Date) -> Int {
        methodLog.append(.get(component: component, date: date))
        return realObject.get(component: component, from: date)
    }
    public func getDate(byAdding value: Int, component: Component, to date: Date) -> Date {
        methodLog.append(.getDate(value: value, component: component, date: date))
        return realObject.getDate(byAdding: value, component: component, to: date)
    }
    public func getStart(of date: Date) -> Date {
        methodLog.append(.getStart(date: date))
        return realObject.getStart(of: date)
    }
    public func getEnd(of date: Date) -> Date {
        methodLog.append(.getEnd(date: date))
        return realObject.getEnd(of: date)
    }
    public func isDate(_ date: Date, inSameDayAs: Date) -> Bool {
        methodLog.append(.isDate(date: date, inSameDayAs: inSameDayAs))
        return realObject.isDate(date, inSameDayAs: inSameDayAs)
    }
}
