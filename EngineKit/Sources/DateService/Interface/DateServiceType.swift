//
//  DateServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 28/01/2024.
//

import Foundation

public protocol DateServiceType {
    func now() -> Date
    
    func daysBetween(_ start: Date, end: Date) -> Int
    
    func get(component: Component, from date: Date) -> Int
    func getDate(byAdding value: Int, component: Component, to date: Date) -> Date
    
    func getStart(of date: Date) -> Date
    func getEnd(of date: Date) -> Date
    
    func isDate(_ date: Date, inSameDayAs: Date) -> Bool
    
    func date(hours: Int, minutes: Int, seconds: Int, from date: Date) -> Date?
}
