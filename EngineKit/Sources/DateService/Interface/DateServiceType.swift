//
//  DateServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 28/01/2024.
//

import Foundation

public protocol DateServiceType {
    func daysBetween(_ start: Date, end: Date) -> Int
    func getDate(byAddingDays days: Int, to date: Date) -> Date
    func getEnd(of date: Date) -> Date?
    func isDate(_ date: Date, inSameDayAs: Date) -> Bool
}
