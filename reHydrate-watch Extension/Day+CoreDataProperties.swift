//
//  Day+CoreDataProperties.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/09/2020.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: Date
    @NSManaged public var goal: Double
    @NSManaged public var consumed: Double
    
    /// Will print all data form the day
    public func toPrint() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        print("""
            =========================
            Date: \(formatter.string(from: self.date))
            Consumed: \(self.consumed)
            Goal: \(self.goal)
            =========================
            """)
    }
}
