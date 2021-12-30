//
//  Day+CoreDataProperties.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/09/2020.
//
//

import CoreData
import Foundation

public extension Day {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Day> {
        NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged var date: Date
    @NSManaged var goal: Double
    @NSManaged var consumed: Double

    /// Will print all data form the day
    func toPrint() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        print("""
        =========================
        Date: \(formatter.string(from: date))
        Consumed: \(consumed)
        Goal: \(goal)
        =========================
        """)
    }
}
