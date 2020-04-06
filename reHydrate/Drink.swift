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
    var amountOfDrink: Int
    var dateOfIntake: Date
    
    override init() {
        self.typeOfDrink = String()
        self.amountOfDrink = 0
        self.dateOfIntake = Date()
    }
    
    init(_ drinkType:String, _ drinkAmount: Int, _ intakeDate: Date ) {
        self.typeOfDrink = drinkType
        self.amountOfDrink = drinkAmount
        self.dateOfIntake = intakeDate
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
