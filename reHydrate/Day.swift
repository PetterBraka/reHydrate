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
    
    required override init() {
        self.date = Date.init()
        self.goalAmount = Drink.init()
        self.consumedAmount = Drink.init()
    }
    
    init(date: Date, goalAmount: Drink,consumedAmount: Drink ) {
        self.date = date
        self.goalAmount = goalAmount
        self.consumedAmount = consumedAmount
        
    }
    
    
    static func saveDay(_ day : [Day]) {
        do {
            let object = try JSONEncoder().encode(day)
            UserDefaults.standard.set(object, forKey: "days")
        } catch {
            print(error)
        }
        
        
    }
    
    static func loadDay()-> [Day] {
        let decoder = JSONDecoder()
        if  let object = UserDefaults.standard.value(forKey: "days") as? Data {
            do {
                let days = try decoder.decode([Day].self, from: object)
                
                for day in days {
                    if days.firstIndex(of: day) == 0 {
                        print("---------------------------------------------")
                    }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEE - dd/MM/yy"
                    print("|Date - ", formatter.string(from: day.date), "\t\t\t\t\t|")
                    print("|Goal:", "\t\t\t\t\t\t\t\t\t\t|")
                    print("|    Drink type - ", day.goalAmount.typeOfDrink, "\t\t\t\t\t|")
                    print("|    Drink amount - ", day.goalAmount.amountOfDrink, "\t\t\t\t\t|")
                    print("|Consumed Drink: \t\t\t\t\t\t\t|")
                    print("|    Drink type - ", day.consumedAmount.typeOfDrink, "\t\t\t\t\t|")
                    print("|    Drink amount - ", String(format: "%.1f",day.consumedAmount.amountOfDrink), "\t\t\t\t\t|")
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
