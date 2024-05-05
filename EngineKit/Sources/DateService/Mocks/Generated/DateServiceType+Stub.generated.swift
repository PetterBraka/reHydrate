// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
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

}
