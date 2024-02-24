// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

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

