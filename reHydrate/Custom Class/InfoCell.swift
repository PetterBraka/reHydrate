//
//  InfoCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 14/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    @IBOutlet weak var titleOfCard: 	UILabel!
    @IBOutlet weak var typeOfDrink: 	UILabel!
    @IBOutlet weak var amountOfDrink: 	UILabel!
    @IBOutlet var lables: 				[UILabel]!
    var darkMode						= Bool()
    var metricUnits						= Bool()
    
    /**
     Will sett the valuse for a **UITableViewCell**.
     
     - parameter drinks: - The drink you want to use the data form.
     - parameter possistion: -The possition of the cell beeing made.
     
     # Example #
     ```
     cell.setLabels(drinks[indexPath.row], indexPath.row)
     ```
     */
    func setLabels(_ drink: Drink, _ possistion: Int){
        switch possistion {
        case 0:
            titleOfCard.text = "Goal:"
        case 1:
            titleOfCard.text = "Consumed:"
        default:
            break
        }
        typeOfDrink.text 	= drink.typeOfDrink
        amountOfDrink.text	= String(format: "%.2f", drink.amountOfDrink)
        amountOfDrink.text?.append("L")
    }
    
    /**
     Changing the appearance of the **InfoCell** deppending on if the users prefrence for dark mode or light mode.
     
     # Example #
     ```
     changeAppearance()
     ```
     */
    func changeAppearance(_ darkMode: Bool){
        self.darkMode = darkMode
        self.backgroundColor = .clear
        if darkMode {
            titleOfCard.textColor 	= .white
            typeOfDrink.textColor 	= .white
            amountOfDrink.textColor = .white
            for lable in lables {
                lable.textColor 	= .white
            }
        } else {
            titleOfCard.textColor 	= .black
            typeOfDrink.textColor 	= .black
            amountOfDrink.textColor = .black
            for lable in lables {
                lable.textColor     = .black
            }
        }
    }
    
    func changeToImperial(_ drink: Drink){
        let volume = Measurement(value: Double(drink.amountOfDrink), unit: UnitVolume.liters)
        let convertedValue = volume.converted(to: UnitVolume.imperialPints).value
        amountOfDrink.text = String(format: "%.2f", convertedValue)
        amountOfDrink.text?.append("pt")
    }
}
