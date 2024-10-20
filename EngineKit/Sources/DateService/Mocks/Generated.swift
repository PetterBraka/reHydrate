// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import DateServiceInterface

public protocol DateServiceTypeSpying {
    var variableLog: [DateServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: DateServiceTypeSpy.VariableName? { get }
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
        case date(hours: Int, minutes: Int, seconds: Int, date: Date)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: DateServiceType
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
    public func date(hours: Int, minutes: Int, seconds: Int, from date: Date) -> Date? {
        methodLog.append(.date(hours: hours, minutes: minutes, seconds: seconds, date: date))
        return realObject.date(hours: hours, minutes: minutes, seconds: seconds, from: date)
    }
}

// MARK: - AutoString
// swiftlint:disable all



// MARK: - AutoStub
// swiftlint:disable all  
import Foundation
import DateServiceInterface

public protocol DateServiceTypeStubbing {
    var now_returnValue: Date { get set }
    var daysBetweenStartEnd_returnValue: Int { get set }
    var getComponentDate_returnValue: Int { get set }
    var getDateValueComponentDate_returnValue: Date { get set }
    var getStartDate_returnValue: Date { get set }
    var getEndDate_returnValue: Date { get set }
    var isDateDateInSameDayAs_returnValue: Bool { get set }
    var dateHoursMinutesSecondsDate_returnValue: Date? { get set }
}

public final class DateServiceTypeStub: DateServiceTypeStubbing {
    public var now_returnValue: Date {
        get {
            if now_returnValues.isEmpty {
                .default
            } else {
                now_returnValues.removeFirst()
            }
        }
        set {
            now_returnValues.append(newValue)
        }
    }
    private var now_returnValues: [Date] = []
    public var daysBetweenStartEnd_returnValue: Int {
        get {
            if daysBetweenStartEnd_returnValues.isEmpty {
                .default
            } else {
                daysBetweenStartEnd_returnValues.removeFirst()
            }
        }
        set {
            daysBetweenStartEnd_returnValues.append(newValue)
        }
    }
    private var daysBetweenStartEnd_returnValues: [Int] = []
    public var getComponentDate_returnValue: Int {
        get {
            if getComponentDate_returnValues.isEmpty {
                .default
            } else {
                getComponentDate_returnValues.removeFirst()
            }
        }
        set {
            getComponentDate_returnValues.append(newValue)
        }
    }
    private var getComponentDate_returnValues: [Int] = []
    public var getDateValueComponentDate_returnValue: Date {
        get {
            if getDateValueComponentDate_returnValues.isEmpty {
                .default
            } else {
                getDateValueComponentDate_returnValues.removeFirst()
            }
        }
        set {
            getDateValueComponentDate_returnValues.append(newValue)
        }
    }
    private var getDateValueComponentDate_returnValues: [Date] = []
    public var getStartDate_returnValue: Date {
        get {
            if getStartDate_returnValues.isEmpty {
                .default
            } else {
                getStartDate_returnValues.removeFirst()
            }
        }
        set {
            getStartDate_returnValues.append(newValue)
        }
    }
    private var getStartDate_returnValues: [Date] = []
    public var getEndDate_returnValue: Date {
        get {
            if getEndDate_returnValues.isEmpty {
                .default
            } else {
                getEndDate_returnValues.removeFirst()
            }
        }
        set {
            getEndDate_returnValues.append(newValue)
        }
    }
    private var getEndDate_returnValues: [Date] = []
    public var isDateDateInSameDayAs_returnValue: Bool {
        get {
            if isDateDateInSameDayAs_returnValues.isEmpty {
                .default
            } else {
                isDateDateInSameDayAs_returnValues.removeFirst()
            }
        }
        set {
            isDateDateInSameDayAs_returnValues.append(newValue)
        }
    }
    private var isDateDateInSameDayAs_returnValues: [Bool] = []
    public var dateHoursMinutesSecondsDate_returnValue: Date? {
        get {
            if dateHoursMinutesSecondsDate_returnValues.isEmpty {
                .default
            } else {
                dateHoursMinutesSecondsDate_returnValues.removeFirst()
            }
        }
        set {
            dateHoursMinutesSecondsDate_returnValues.append(newValue)
        }
    }
    private var dateHoursMinutesSecondsDate_returnValues: [Date?] = []

    public init() {}
}

extension DateServiceTypeStub: DateServiceType {
    public func now() -> Date {
        now_returnValue
    }

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

    public func date(hours: Int, minutes: Int, seconds: Int, from date: Date) -> Date? {
        dateHoursMinutesSecondsDate_returnValue
    }

}
