//
//  Day.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

public class Day: NSObject, Codable {
    var date:     Date
    var goal:     Drink
    var consumed: Drink
    
    /**
     Default initializer for **Day**
    
     # Example #
     ```
     let day = Day.init()
     ```
     */
    required override init() {
        self.date     = Date.init()
        self.goal     = Drink.init(typeOfDrink: "water", amountOfDrink: 3)
        self.consumed = Drink.init()
    }
    
    /**
     Initializer for **Day**
     
     - parameter date: - The date.
     - parameter goalAmount: - The drink with the users goal
     - parameter consumedAmount: - The drinks consumed
     
     # Example #
     ```
     let day = Day.init(Date.init(), 3, 1.2)
     ```
     */
    init(date: Date, goalAmount: Drink, consumedAmount: Drink ) {
        self.date 			= date
        self.goal 	= goalAmount
        self.consumed = consumedAmount
        
    }
    
    /**
     Saves an array of **Day**s
     
     - parameter days: - The days you want to save.
     - warning: will print a waring if the days can't be encoded and saved.
     
     # Example #
     ```
     Day.saveDays(days)
     ```
     */
    static func saveDays(_ days : [Day]) {
        do {
            let object = try JSONEncoder().encode(days)
            UserDefaults.standard.set(object, forKey: "days")
        } catch {
            print(error)
        }
        for day in days {
            if days.firstIndex(of: day) == 0 {
                print("-------------------Saving--------------------")
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE - dd/MM/yy"
            print("|Date", formatter.string(from: day.date))
            print("|Goal:")
            print("| - Drink type - ", day.goal.type)
            print("| - Drink amount - ", day.goal.amount)
            print("|Consumed Drink:")
            print("| - Drink type - ", day.consumed.type)
            print("| - Drink amount - ",String(format: "%.2f", day.consumed.amount))
            print("---------------------------------------------")
        }
        
        
    }
    
    /**
     Loads and prints an array of **Day**s saved. If there is no thing saved it will print an error code.
     
     - warning: Will return an error if the array saved is not of type **Day**
     - warning: If there are no save it will print an error saying: "Can't retrive data from key used (day) in user defaults"
     
     # Example #
     ```
     days = Day.loadDays()
     ```
     */
    static func loadDays()-> [Day] {
        let decoder 	= JSONDecoder()
        if  let object 	= UserDefaults.standard.value(forKey: "days") as? Data {
            do {
                var days = try decoder.decode([Day].self, from: object)
                if !days.isEmpty {
                    days.sort(by: {$0.date < $1.date})
                }
                for day in days {
                    if days.firstIndex(of: day) == 0 {
                        print("------------------Loading--------------------")
                    }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE - dd/MM/yy"
                    print("|Date", formatter.string(from: day.date))
                    print("|Goal:")
                    print("| - Drink type - ", day.goal.type)
                    print("| - Drink amount - ", day.goal.amount)
                    print("|Consumed Drink:")
                    print("| - Drink type - ", day.consumed.type)
                    print("| - Drink amount - ",String(format: "%.2f", day.consumed.amount))
                    print("---------------------------------------------")
                }
                return days
                
            } catch {
                print(error)
            }
            
            
        } else {
            print("Can't retrive data from key used (day) in user defaults")
        }
        return []
    }
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
