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

}

extension Array where Element == Day {
    
    /**
     Adds or updates the day in an array of days
     
     - parameter dayToInsert: -  An day to insert in an array.
     
     # Notes: #
     1. Parameters must be of type Day
     
     # Example #
     ```
     insertDay(today)
     ```
     */
    mutating func insertDay(_ dayToInsert: Day){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if self.isEmpty {
            self.append(dayToInsert)
        } else {
            if self.contains(where: {dateFormatter.string(from: $0.date) ==
                                dateFormatter.string(from: dayToInsert.date) }) {
                self[self.firstIndex(of: dayToInsert) ?? self.count - 1] = dayToInsert
            } else {
                self.append(dayToInsert)
            }
        }
    }
    
    /**
     Will find a day in the saved days that corosponds to today if any then,
     updates the goal of today to the same as day before.
     
     - parameter today: - The current day.
     - returns: the updated day
     */
    mutating func updateToday()-> Day {
        var newDay = Day()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if self.contains(where: {dateFormatter.string(from: $0.date) == dateFormatter.string(from: Date.init())}){
            newDay = self.first(where: {dateFormatter.string(from: $0.date) == dateFormatter.string(from: Date.init())})!
        } else if !self.isEmpty {
            newDay.goal = self.last!.goal
        } else {
            newDay = Day.init()
            self.insertDay(newDay)
        }
        return newDay
    }
}
