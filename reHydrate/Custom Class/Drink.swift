//
//  Drink.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import FSCalendar

class Drink: NSObject, Codable {
    var typeOfDrink: 	String
    var amountOfDrink: 	Float
    
    /**
     Default initializer for **Drink**
     
     # Example #
     ```
     var drink = Drink.init()
     ```
     */
    required override init() {
        self.typeOfDrink 	= "water"
        self.amountOfDrink 	= 0
    }

    /**
     Initializer for Drink
     
     - parameter typeOfDrink: - The type of drink.
     - parameter amountOfDrink: - The amount of drink.
    
     # Example #
     ```
     var drink = Drink.inti("water", 1.2)
     ```
     */
    init(typeOfDrink: String, amountOfDrink: Float ) {
        self.typeOfDrink 	= typeOfDrink
        self.amountOfDrink 	= amountOfDrink
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
