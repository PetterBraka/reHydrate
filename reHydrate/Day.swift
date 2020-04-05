//
//  Day.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class Day: NSObject {
    var date: Date
    var goalAmount: Double
    var consumedAmount: Double

    override init() {
        self.date = Date.init()
        self.goalAmount = 0
        self.consumedAmount = 0
    }
    
    init(_ date: Date, _ goalAmount: Double, _ consumedAmount: Double) {
        self.date = date
        self.goalAmount = goalAmount
        self.consumedAmount = consumedAmount
    }
    
    
}
