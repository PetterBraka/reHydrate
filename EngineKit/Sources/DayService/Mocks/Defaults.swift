//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 24/02/2024.
//

import Foundation
import DayServiceInterface

extension Day {
    static let `default` = Day(id: "----", date: .distantPast, consumed: .default, goal: .default)
}

extension Array where Element == Day {
    static let `default` = [Day.default]
}

extension Result where Success == [Day], Failure == Error {
    static let `default`: Result<Success, Failure> = .success(.default)
}

extension Double {
    static let `default`: Double = -999
}

extension Result where Success == Double, Failure == Error {
    static let `default`: Result<Success, Failure> = .success(.default)
}
