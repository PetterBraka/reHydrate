//
//  InfoCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 14/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    @IBOutlet weak var titleOfCard: UILabel!
    @IBOutlet weak var typeOfDrink: UILabel!
    @IBOutlet weak var amountOfDrink: UILabel!
    
    func setLabels(_ drink: Drink, _ possistion: Int){
        switch possistion {
        case 0:
            titleOfCard.text = "Goal:"
        case 1:
            titleOfCard.text = "Consumed:"
        default:
            break
        }
        typeOfDrink.text = drink.typeOfDrink
        amountOfDrink.text = String(drink.amountOfDrink)
    }
}
