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
    @IBOutlet var lables: [UILabel]!
    var darkMode						= Bool()
    
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
        amountOfDrink.text 	= String(drink.amountOfDrink)
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
}
