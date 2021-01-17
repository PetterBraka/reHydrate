//
//  FetchData.swift
//  reHydrate-watch Extension
//
//  Created by Petter vang Brakalsvålet on 16/01/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//
import UIKit
import WatchKit
import CoreData
import Foundation


let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/YYYY"
    return formatter
}()

// MARK: - Load and Save days

/// Loading all days saved to core data.
/// - Returns: *[Day]* an array off days loaded
public func fetchAllDays() -> [Day] {
    do {
        let days = try context.fetch(Day.fetchRequest()) as! [Day]
        #if DEBUG
        days.forEach({$0.toPrint()})
        #endif
        return days
    } catch {
        #if DEBUG
        print("can't featch days")
        print(error.localizedDescription)
        #endif
        return [Day(context: context)]
    }
}

/// Remove a specific day
/// - Parameter day: The day you want to remove
public func removeDay(day : Day){
    context.delete(day)
}

/// Will get a day representing data for the current day. It will also set the goal to be the same as the goal from the previous day.
/// - Returns: The day found to be equal to todays date.
public func fetchToday() -> Day {
    do {
        let request = Day.fetchRequest() as NSFetchRequest
        // Get today's beginning & tomorrows beginning time
        let todaysStart = Calendar.current.startOfDay(for: Date())
        let tomorrowsStart = Calendar.current.date(byAdding: .day, value: 1, to: todaysStart)
        // Sets conditions for date to be within today
        let fromPredicate = NSPredicate(format: "date >= %@", todaysStart as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", tomorrowsStart! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.fetchLimit = 1
        request.predicate = datePredicate
        // tries to get the day out of the array.
        let loadedDays = try context.fetch(request)
        #if DEBUG
        loadedDays.forEach({$0.toPrint()})
        #endif
        // If today wasn't found it will create a new day.
        guard let today = loadedDays.first else {
            #if DEBUG
            print("can't today")
            #endif
            let allDays = fetchAllDays()
            let previousDay = allDays.last
            let today = Day(context: context)
            today.date = Date()
            today.goal = previousDay?.goal ?? 3
            return today
        }
        return today
    } catch {
        #if DEBUG
        print("can't featch day")
        print(error.localizedDescription)
        #endif
        // If the loading of data fails, we create a new day
        let today = Day(context: context)
        today.date = Date()
        today.goal = 3
        return today
    }
}

/// Will featch and return a spesific day or reurn nill if day can't be found for the date.
/// - Parameter date: The date for the spesific day you wan't
/// - Returns: returns *Day* if found else nil
public func fetchDay(_ date: Date) -> Day? {
    do {
        let request = Day.fetchRequest() as NSFetchRequest
        // Get day's beginning & tomorrows beginning time
        let startTime = Calendar.current.startOfDay(for: date)
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startTime)
        // Sets conditions for date to be within day
        let fromPredicate = NSPredicate(format: "date >= %@", startTime as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", nextDay! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
        request.fetchLimit = 1
        // tries to get the day out of the array.
        let loadedDays = try context.fetch(request)
        #if DEBUG
        loadedDays.forEach({$0.toPrint()})
        #endif
        let day = loadedDays.first
        return day
    } catch {
        print("can't featch day")
        print(error.localizedDescription)
        return nil
    }
}

/// Will featch the previous day saved.
/// - Returns: returns *Day* if found else nil
public func fetchPreviousDay() -> Day? {
    do {
        let days = try context.fetch(Day.fetchRequest()) as! [Day]
        #if DEBUG
        days.forEach({$0.toPrint()})
        #endif
        return days[days.count - 1]
    } catch {
        #if DEBUG
        print("can't featch day creating new day")
        print(error.localizedDescription)
        #endif
        let prevDay = Day(context: context)
        prevDay.date = Date()
        prevDay.goal = 3
        prevDay.consumed = 0
        return prevDay
    }
}

/// Tries to save all days created in context
public func saveDays() {
    do {
        try context.save()
    } catch {
        #if DEBUG
        print("can't save days")
        print(error.localizedDescription)
        #endif
    }
}
