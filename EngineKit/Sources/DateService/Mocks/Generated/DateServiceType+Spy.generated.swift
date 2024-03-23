// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import DateServiceInterface

public protocol DateServiceTypeSpying {
    var variableLog: [DateServiceTypeSpy.VariableName] { get set }
    var methodLog: [DateServiceTypeSpy.MethodName] { get set }
}

public final class DateServiceTypeSpy: DateServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
        case now
        case daysBetween_end
        case get_component_from
        case getDate_byAdding_component_to
        case getStart_of
        case getEnd_of
        case isDate_inSameDayAs
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
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
        methodLog.append(.daysBetween_end)
        return realObject.daysBetween(start, end: end)
    }
    public func get(component: Component, from date: Date) -> Int {
        methodLog.append(.get_component_from)
        return realObject.get(component: component, from: date)
    }
    public func getDate(byAdding value: Int, component: Component, to date: Date) -> Date {
        methodLog.append(.getDate_byAdding_component_to)
        return realObject.getDate(byAdding: value, component: component, to: date)
    }
    public func getStart(of date: Date) -> Date {
        methodLog.append(.getStart_of)
        return realObject.getStart(of: date)
    }
    public func getEnd(of date: Date) -> Date {
        methodLog.append(.getEnd_of)
        return realObject.getEnd(of: date)
    }
    public func isDate(_ date: Date, inSameDayAs: Date) -> Bool {
        methodLog.append(.isDate_inSameDayAs)
        return realObject.isDate(date, inSameDayAs: inSameDayAs)
    }
}
