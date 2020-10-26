//
//  featchData.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/10/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import UIKit
import CoreData


let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/YYYY"
    return formatter
}()

//MARK: - Load and Save days

/// Loading all days saved to core data.
/// - Returns: *[Day]* an array off days loaded
public func fetchDays() -> [Day] {
    do {
        let days = try context.fetch(Day.fetchRequest()) as! [Day]
        #if DEBUG
        days.forEach({$0.toPrint()})
        #endif
        return days
    } catch {
        print("can't featch days")
        print(error.localizedDescription)
        return [Day()]
    }
}

/// Remove a specific day
/// - Parameter day: The day you want to remove
public func removeDay(day : Day){
    context.delete(day)
}

/// Tries to save all days created in context
public func saveDays() {
    do {
        try context.save()
    } catch {
        print("can't save days")
        print(error.localizedDescription)
    }
}

/// Will get a day representing data for the current day. It will also set the goal to be the same as the goal from the previous day.
/// - Returns: The day found to be equal to todays date.
public func fetchToday() -> Day {
    do {
        let request = Day.fetchRequest() as NSFetchRequest
        // Get today's beginning & tomorrows beginning time
        let dateFrom = Calendar.current.startOfDay(for: Date())
        let dateTo = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)
        // Sets conditions for date to be within today
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
        // tries to get the day out of the array.
        let loadedDays = try context.fetch(request)
        #if DEBUG
        loadedDays.forEach({$0.toPrint()})
        #endif
        // If today wasn't found it will create a new day.
        guard let today = loadedDays.first else {
            // create new day
            let today = Day(context: context)
            today.date = Date()
            // tries to get yesterday data
            let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: today.date)
            let yesterday = fetchDay(yesterdayDate!)
            today.goal = yesterday?.goal ?? 3
            
            return today
        }
        return today
    } catch {
        print("can't featch day")
        print(error.localizedDescription)
        // If the loading of data fails, we create a new day
        let today = Day(context: context)
        today.date = Date()
        // tries to get yesterday data
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: today.date)
        let yesterday = fetchDay(yesterdayDate!)
        today.goal = yesterday?.goal ?? 3
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
        let dateFrom = Calendar.current.startOfDay(for: date)
        let dateTo = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)
        // Sets conditions for date to be within day
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
        // tries to get the day out of the array.
        let loadedDays = try context.fetch(request)
        #if DEBUG
        loadedDays.forEach({$0.toPrint()})
        #endif
        // If the day wasn't found it will create a new day.
        let day = loadedDays.first
        return day
    } catch {
        print("can't featch day")
        print(error.localizedDescription)
        return nil
    }
}