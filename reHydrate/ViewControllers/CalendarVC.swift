//
//  CalenderScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 06/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController {
    
    var drinks: [Drink] 		= []
    var days: [Day] 			= []
    var darkMode				= Bool()
    var metricUnits				= Bool()
    let formatter 				= DateFormatter()
    
    @IBOutlet weak var titleDate: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    /**
     Will dismiss the page and go back to the main page.
     
     - parameter sender: - **view** that called the function.
    
     */
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        days                            = Day.loadDay()
        formatter.dateFormat 			= "EEE - dd/MM/yy"
        getDrinks(Date.init())
        darkMode 						= UserDefaults.standard.bool(forKey: "darkMode")
        metricUnits 					= UserDefaults.standard.bool(forKey: "metricUnits")
        tableView.isScrollEnabled 		= false
        tableView.delegate 				= self
        tableView.dataSource 			= self
        calendar.delegate 				= self
        calendar.dataSource 			= self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
        changeAppearance()
    }
    
    /**
     Changing the appearance of the app deppending on if the users prefrence for dark mode or light mode.
     
     # Notes: #
     1. This will change all the colors off this screen.
     
     # Example #
     ```
     changeAppearance()
     ```
     */
    func changeAppearance(){
        calendar.appearance.titleFont = UIFont(name: "American typewriter", size: 15)
        calendar.appearance.weekdayFont = UIFont(name: "American typewriter", size: 18)
        calendar.appearance.headerTitleFont = UIFont(name: "American typewriter", size: 20)
        if darkMode {
            calendar.backgroundColor 				= hexStringToUIColor(hex: "#212121")
            self.view.backgroundColor 				= hexStringToUIColor(hex: "#212121")
            tableView.backgroundColor 				= hexStringToUIColor(hex: "#212121")
            titleDate.textColor 					= .white
            calendar.appearance.headerTitleColor 	= .white
            calendar.appearance.weekdayTextColor	= .systemBlue
        } else {
            calendar.backgroundColor				= .white
            calendar.appearance.headerTitleColor 	= .black
            calendar.appearance.titleDefaultColor 	= .black
            self.view.backgroundColor 				= .white
            tableView.backgroundColor 				= .white
            titleDate.textColor 					= .black
        }
    }
    
    
    /**
     Will convert an string of a hex color code to **UIColor**
     
     - parameter hex: - A **String** whit the hex color code.
     
     # Notes: #
     1. This will need an **String** in a hex coded style.
     
     # Example #
     ```
     let color: UIColor = hexStringToUIColor ("#212121")
     ```
     */
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /**
     Will find the drinks, depending on the date past in and update UI
     
     - parameter dateOfDay: - The date of you want the drinks from.
     
     # Example #
     ```
     getDrinks(Date.init())
     ```
     */
    func getDrinks(_ dateOfDay: Date){
        titleDate.text = formatter.string(from: dateOfDay)
        if days.contains(where: { formatter.string(from: $0.date) == formatter.string(from: dateOfDay) }){
            let day: Day = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: dateOfDay)})!
            drinks.append(day.goalAmount)
            drinks.append(day.consumedAmount)
        } else {
            drinks.append(Drink.init(typeOfDrink: "", amountOfDrink: 0))
            drinks.append(Drink.init(typeOfDrink: "", amountOfDrink: 0))
        }
    }
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! InfoCell
        cell.setLabels(drinks[indexPath.row], indexPath.row)
        cell.selectionStyle = .none
        cell.changeAppearance(darkMode)
        return cell
    }
}

extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource{
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date.description)
        drinks.removeAll()
        getDrinks(date)
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let stringDate = formatter.string(from: date)
        
        //Checks if the date has data stored.
        if days.contains(where: { formatter.string(from: $0.date) == stringDate }){
            print(stringDate)
            return 1
        }
        
        return 0
    }
    
    
    
}
