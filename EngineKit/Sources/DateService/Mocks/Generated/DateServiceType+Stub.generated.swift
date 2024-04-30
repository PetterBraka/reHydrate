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
            if now_returnValues.count > 0 {
                let value = now_returnValues.removeFirst()
                if now_returnValues.isEmpty {
                    now_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return now_returnValues.first ?? .default
            }
        }
        set {
            now_returnValues.append(newValue)
        }
    }
    private var now_returnValues: [Date] = []
    public var daysBetweenStartEnd_returnValue: Int {
        get {
            if daysBetweenStartEnd_returnValues.count > 0 {
                let value = daysBetweenStartEnd_returnValues.removeFirst()
                if daysBetweenStartEnd_returnValues.isEmpty {
                    daysBetweenStartEnd_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return daysBetweenStartEnd_returnValues.first ?? .default
            }
        }
        set {
            daysBetweenStartEnd_returnValues.append(newValue)
        }
    }
    private var daysBetweenStartEnd_returnValues: [Int] = []
    public var getComponentDate_returnValue: Int {
        get {
            if getComponentDate_returnValues.count > 0 {
                let value = getComponentDate_returnValues.removeFirst()
                if getComponentDate_returnValues.isEmpty {
                    getComponentDate_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return getComponentDate_returnValues.first ?? .default
            }
        }
        set {
            getComponentDate_returnValues.append(newValue)
        }
    }
    private var getComponentDate_returnValues: [Int] = []
    public var getDateValueComponentDate_returnValue: Date {
        get {
            if getDateValueComponentDate_returnValues.count > 0 {
                let value = getDateValueComponentDate_returnValues.removeFirst()
                if getDateValueComponentDate_returnValues.isEmpty {
                    getDateValueComponentDate_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return getDateValueComponentDate_returnValues.first ?? .default
            }
        }
        set {
            getDateValueComponentDate_returnValues.append(newValue)
        }
    }
    private var getDateValueComponentDate_returnValues: [Date] = []
    public var getStartDate_returnValue: Date {
        get {
            if getStartDate_returnValues.count > 0 {
                let value = getStartDate_returnValues.removeFirst()
                if getStartDate_returnValues.isEmpty {
                    getStartDate_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return getStartDate_returnValues.first ?? .default
            }
        }
        set {
            getStartDate_returnValues.append(newValue)
        }
    }
    private var getStartDate_returnValues: [Date] = []
    public var getEndDate_returnValue: Date {
        get {
            if getEndDate_returnValues.count > 0 {
                let value = getEndDate_returnValues.removeFirst()
                if getEndDate_returnValues.isEmpty {
                    getEndDate_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return getEndDate_returnValues.first ?? .default
            }
        }
        set {
            getEndDate_returnValues.append(newValue)
        }
    }
    private var getEndDate_returnValues: [Date] = []
    public var isDateDateInSameDayAs_returnValue: Bool {
        get {
            if isDateDateInSameDayAs_returnValues.count > 0 {
                let value = isDateDateInSameDayAs_returnValues.removeFirst()
                if isDateDateInSameDayAs_returnValues.isEmpty {
                    isDateDateInSameDayAs_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return isDateDateInSameDayAs_returnValues.first ?? .default
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
