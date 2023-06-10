//
//  Double+Clean.swift
//
//
//  Created by Petter vang Brakalsvålet on 23/04/2023.
//

import Foundation

public extension Double {
    func convert(to newUnit: UnitVolume, from oldUnit: UnitVolume) -> Double {
        Measurement(value: self, unit: oldUnit).converted(to: newUnit).value
    }
}
