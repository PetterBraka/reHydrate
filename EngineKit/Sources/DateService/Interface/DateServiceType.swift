//
//  DateServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 28/01/2024.
//

import Foundation

public protocol DateServiceType {
    func daysBetween(_ start: Date, end: Date) -> Int
    func getEnd(of date: Date) -> Date?
}
