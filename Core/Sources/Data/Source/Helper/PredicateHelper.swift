//
//  PredicateHelper.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

final class PredicateHelper {
    
    /// Generates a predicate representating the start to the end of the date passed in
    static func getPredicate(for date: Date) -> NSCompoundPredicate {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let startOfNextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
        // Sets conditions for date to be within the same date
        let fromPredicate = NSPredicate(format: "date >= %@", startOfDay as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", startOfNextDay! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
            [fromPredicate, toPredicate])
        return datePredicate
    }
}
