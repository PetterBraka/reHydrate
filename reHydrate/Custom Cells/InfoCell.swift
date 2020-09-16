//
//  InfoCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 14/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    var titleOfCard: UILabel      = {
        let lable  = UILabel()
        lable.text = "Title"
        lable.font = UIFont(name: "AmericanTypewriter", size: 23)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var amountOfDrink: UILabel    = {
        let lable  = UILabel()
        lable.text = "0.0 L"
        lable.font = UIFont(name: "AmericanTypewriter", size: 20)
        lable.textAlignment = .right
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var darkMode    = Bool()
    var metricUnits = Bool()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleOfCard)
        self.contentView.addSubview(amountOfDrink)
        setConstraints()
        changeAppearance(darkMode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints(){
        titleOfCard.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive                = true
        titleOfCard.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5).isActive               = true
        titleOfCard.rightAnchor.constraint(lessThanOrEqualTo: self.contentView.rightAnchor, constant: 300).isActive = true
        
        amountOfDrink.centerYAnchor.constraint(equalTo: titleOfCard.centerYAnchor).isActive                   = true
        amountOfDrink.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive   = true
        amountOfDrink.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    /**
     Will sett the valuse for a **UITableViewCell**.
     
     - parameter drinks: - The drink you want to use the data form.
     - parameter possistion: -The possition of the cell beeing made.
     
     # Example #
     ```
     cell.setLabels(drinks[indexPath.row], indexPath.row)
     ```
     */
    func setLabels(_ title: String, _ drink: String){
        titleOfCard.text    = title
        amountOfDrink.text  = drink
        amountOfDrink.text?.append(" L")
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
            titleOfCard.textColor      = .white
            amountOfDrink.textColor    = .white
        } else {
            titleOfCard.textColor      = .black
            amountOfDrink.textColor    = .black
        }
    }
    
    func changeToImperial(_ drink: Double){
        let volume = Measurement(value: Double(drink), unit: UnitVolume.liters)
        let convertedValue = volume.converted(to: UnitVolume.imperialPints).value
        amountOfDrink.text = String(format: "%.2f", convertedValue)
        amountOfDrink.text?.append("pt")
    }
}
