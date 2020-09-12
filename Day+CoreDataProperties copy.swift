//
//  Day+CoreDataProperties.swift
//  
//
//  Created by Petter vang Brakalsvålet on 08/09/2020.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var consumed: Double
    @NSManaged public var date: Date
    @NSManaged public var goal: Double
    
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
