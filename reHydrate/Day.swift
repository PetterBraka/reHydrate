//
//  Day.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import FSCalendar

public class Day: NSObject {
    var date: Date
    var goalAmount: Drink
    var consumedAmount: Drink

    override init() {
        self.date = Date.init()
        self.goalAmount = Drink.init()
        self.consumedAmount = Drink.init()
    }
    
    init(_ date: Date, _ goalAmount: Drink, _ consumedAmount: Drink) {
        self.date = date
        self.goalAmount = goalAmount
        self.consumedAmount = consumedAmount
    }
    
    
}
