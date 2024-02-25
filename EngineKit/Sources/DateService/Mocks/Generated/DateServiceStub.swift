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
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import DateServiceInterface

public protocol DateServiceTypeStubbing {
    var daysBetweenStartEnd_returnValue: Int { get set }
    var getComponentDate_returnValue: Int { get set }
    var getDateValueComponentDate_returnValue: Date { get set }
    var getStartDate_returnValue: Date { get set }
    var getEndDate_returnValue: Date { get set }
    var isDateDateInSameDayAs_returnValue: Bool { get set }
}

public final class DateServiceTypeStub: DateServiceTypeStubbing {
    public var daysBetweenStartEnd_returnValue: Int = .default
    public var getComponentDate_returnValue: Int = .default
    public var getDateValueComponentDate_returnValue: Date = .default
    public var getStartDate_returnValue: Date = .default
    public var getEndDate_returnValue: Date = .default
    public var isDateDateInSameDayAs_returnValue: Bool = .default

    public init() {}
}

extension DateServiceTypeStub: DateServiceType {
    public func daysBetween(_ start: Date, end: Date) -> Int {
        daysBetweenStartEnd_returnValue
    }

    public func get(component: Component, from date: Date) -> Int {
        getComponentDate_returnValue
    }

    public func getDate(byAdding value: Int, component: Component, to date: Date) -> Date {
        getDateValueComponentDate_returnValue
    }

    public func getStart(of date: Date) -> Date {
        getStartDate_returnValue
    }

    public func getEnd(of date: Date) -> Date {
        getEndDate_returnValue
    }

    public func isDate(_ date: Date, inSameDayAs: Date) -> Bool {
        isDateDateInSameDayAs_returnValue
    }

}

