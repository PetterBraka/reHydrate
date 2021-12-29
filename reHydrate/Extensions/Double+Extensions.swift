//
//  Double+Extensions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/08/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

extension Double {

    /**
     Will clean up a **Double** so that it has a maximum of 1 desimal
     
     - returns: the number as a **String** cleand up
     
     # Example #
     ```
     let number1 = 3.122
     number1.clean // returns 3.1
     
     let number2 = 3.001
     number2.clean // returns 3
     ```
     */
    var clean: String {
        let value = (self * 100) / 100
        return value.truncatingRemainder(dividingBy: 1) == 0 ?
        String(format: "%.0f", value) : String(format: "%.2f", value)
    }

    func convert(to newUnit: UnitVolume, from oldUnit: UnitVolume) -> Double {
        Measurement(value: self, unit: oldUnit).converted(to: newUnit).value
    }
}
