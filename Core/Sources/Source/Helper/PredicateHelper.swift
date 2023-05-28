//
//  PredicateHelper.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

public struct PredicateHelper {
    private init() {}

    /// Generates a predicate representing the start to the end of the date passed in
    public static func getElement(at date: Date) -> NSCompoundPredicate {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let startOfNextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
        // Sets conditions for date to be within the same date
        let fromPredicate = NSPredicate(format: "date >= %@", startOfDay as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", startOfNextDay! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
            [fromPredicate, toPredicate])
        return datePredicate
    }

    public static func getElement(with id: String) -> NSPredicate {
        NSPredicate(format: "id == %@", id)
    }
}

public extension NSPredicate {
    static func getElement(at date: Date) -> NSCompoundPredicate {
        PredicateHelper.getElement(at: date)
    }

    static func getElement(with id: UUID) -> NSPredicate {
        PredicateHelper.getElement(with: id.uuidString)
    }
}
