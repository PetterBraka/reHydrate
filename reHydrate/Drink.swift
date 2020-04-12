//
//  Drink.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import FSCalendar

class Drink: NSObject {
    var typeOfDrink: String
    var amountOfDrink: Float
    
    override init() {
        self.typeOfDrink = ""
        self.amountOfDrink = 0
    }
    
    init(_ drinkType:String, _ drinkAmount: Float) {
        self.typeOfDrink = drinkType
        self.amountOfDrink = drinkAmount
    }
    
    public func saveDrink() {
        UserDefaults.standard.set(typeOfDrink, forKey: "drinkType")
        UserDefaults.standard.set(amountOfDrink, forKey: "drinkVolume")
    }
    
    public func loadDrink() {
        typeOfDrink = UserDefaults.standard.value(forKey: "drinkType") as? String ?? ""
        amountOfDrink = UserDefaults.standard.value(forKey: "drinkVolume") as? Float ?? 0
    }
    
    /**
     Compair the the trype of drink based.
     
     - parameter compairTo: The **Drink** the user want to compair too..
     - returns: **true** if equal or **false** if not
     
     # Example #
     ```
      if drinkOne.isTypeSame(drinkTwo){
        // do something
     }
     ```
     */
    func isTypeSame(_ compairTo: Drink) -> Bool {
        if typeOfDrink.lowercased() == compairTo.typeOfDrink.lowercased(){
            return true
        } else{
            return false
        }
    }
    
    
}
