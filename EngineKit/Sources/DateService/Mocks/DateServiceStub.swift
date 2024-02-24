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
    var getComponent_returnValue: Int { get set }
    var getDateByAdding_returnValue: Date { get set }
    var getStart_returnValue: Date { get set }
    var getEnd_returnValue: Date { get set }
    var isDateInSameDayAs_returnValue: Bool { get set }
}

public final class DateServiceStub: DateServiceStubbing {
    public var daysBetween_returnValue: Int = 0
    public var getComponent_returnValue: Int = 0
    public var getDateByAdding_returnValue: Date = .distantPast
    public var getStart_returnValue: Date = .distantPast
    public var getEnd_returnValue: Date = .distantFuture
    public var isDateInSameDayAs_returnValue: Bool = false
    
    public init() {}
}

extension DateServiceStub: DateServiceType {
    public func daysBetween(_ start: Date, end: Date) -> Int {
        daysBetween_returnValue
    }
    
    public func get(component: Component, from date: Date) -> Int {
        getComponent_returnValue
    }
    
    public func getDate(byAdding value: Int, component: Component, to date: Date) -> Date {
        getDateByAdding_returnValue
    }
    
    public func getStart(of date: Date) -> Date {
        getStart_returnValue
    }
    
    public func getEnd(of date: Date) -> Date {
        getEnd_returnValue
    }
    
    public func isDate(_ date: Date, inSameDayAs: Date) -> Bool {
        isDateInSameDayAs_returnValue
    }
}
