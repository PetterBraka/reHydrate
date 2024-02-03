//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 28/01/2024.
//

import Foundation
import DateServiceInterface

public protocol DateServiceStubbing {
    var daysBetween_returnValue: Int { get set }
    var getDateByAddingDays_returnValue: Date? { get set }
    var getEnd_returnValue: Date? { get set }
    var isDateInSameDayAs_returnValue: Bool { get set }
}

public final class DateServiceStub: DateServiceStubbing {
    public var daysBetween_returnValue: Int = 0
    public var getDateByAddingDays_returnValue: Date?
    public var getEnd_returnValue: Date?
    public var isDateInSameDayAs_returnValue: Bool = false
    
    public init() {}
}

extension DateServiceStub: DateServiceType {
    public func daysBetween(_ start: Date, end: Date) -> Int {
        daysBetween_returnValue
    }
    
    public func getDate(byAddingDays days: Int, to date: Date) -> Date? {
        getDateByAddingDays_returnValue
    }
    
    public func getEnd(of date: Date) -> Date? {
        getEnd_returnValue
    }
    
    public func isDate(_ date: Date, inSameDayAs: Date) -> Bool {
        isDateInSameDayAs_returnValue
    }
}
