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
        tableView.isScrollEnabled 		= false
        tableView.delegate 				= self
        tableView.dataSource 			= self
        calendar.delegate 				= self
        calendar.dataSource 			= self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
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
