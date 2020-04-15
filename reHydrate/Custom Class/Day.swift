//
//  Day.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import FSCalendar

public class Day: NSObject, Codable {
    var date: Date
    var goalAmount: Drink
    var consumedAmount: Drink
    
    /**
     Default initializer for **Day**
    
     # Example #
     ```
     let day = Day.init()
     ```
     */
    required override init() {
        self.date = Date.init()
        self.goalAmount = Drink.init()
        self.consumedAmount = Drink.init()
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
        self.date = date
        self.goalAmount = goalAmount
        self.consumedAmount = consumedAmount
        
    }
    
    /**
     Saves an array of **Day**s
     
     - parameter days: - The days you want to save.
     - warning: will print a waring if the days can't be encoded and saved.
     
     # Example #
     ```
     Day.saveDay(days)
     ```
     */
    static func saveDay(_ days : [Day]) {
        do {
            let object = try JSONEncoder().encode(days)
            UserDefaults.standard.set(object, forKey: "days")
        } catch {
            print(error)
        }
        
        
    }
    
    /**
     Loads and prints an array of **Day**s saved. If there is no thing saved it will print an error code.
     
     - warning: Will return an error if the array saved is not of type **Day**
     - warning: If there are no save it will print an error saying: "Can't retrive data from key used (day) in user defaults"
     
     # Example #
     ```
     days = Day.loadDay()
     ```
     */
    static func loadDay()-> [Day] {
        let decoder = JSONDecoder()
        if  let object = UserDefaults.standard.value(forKey: "days") as? Data {
            do {
                var days = try decoder.decode([Day].self, from: object)
                if !days.isEmpty {
                    days.sort(by: {$0.date < $1.date})
                }
                for day in days {
                    if days.firstIndex(of: day) == 0 {
                        print("---------------------------------------------")
                    }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE - dd/MM/yy"
                    print("|Date", formatter.string(from: day.date), "\t\t\t\t\t\t|")
                    print("|Goal:", "\t\t\t\t\t\t\t\t\t\t|")
                    print("| - Drink type - ", day.goalAmount.typeOfDrink, "\t\t\t\t\t|")
                    print("| - Drink amount - ", day.goalAmount.amountOfDrink, "\t\t\t\t\t|")
                    print("|Consumed Drink: \t\t\t\t\t\t\t|")
                    print("| - Drink type - ", day.consumedAmount.typeOfDrink, "\t\t\t\t\t|")
                    print("| - Drink amount - ", String(format: "%.1f",day.consumedAmount.amountOfDrink), "\t\t\t\t\t|")
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
