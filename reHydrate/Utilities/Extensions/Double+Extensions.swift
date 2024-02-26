//
//  Double+Extensions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/08/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

extension NSNumber {
}

extension Double {
    var clean: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.allowsFloats = true
        
        return formatter.string(from: self as NSNumber) ?? "0"
    }
    
    func convert(to newUnit: UnitVolume, from oldUnit: UnitVolume) -> Double {
        Measurement(value: self, unit: oldUnit).converted(to: newUnit).value
    }
}
