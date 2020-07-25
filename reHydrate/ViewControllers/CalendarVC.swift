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
    
    var drinks: [Drink] = []
    var days: [Day]     = []
    var darkMode        = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkMode ? .lightContent : .darkContent
    }
    var metricUnits     = Bool()
    let formatter       = DateFormatter()
    let defaults        = UserDefaults.standard
    var exitButton: UIButton    = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var titleDate:  UILabel     = {
        var lable  = UILabel()
        lable.text = "Mon - 11/05/20"
        lable.font = UIFont(name: "AmericanTypewriter", size: 25)
        lable.numberOfLines = 0
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var tableView:  UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var calendar:   FSCalendar  = {
        var calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    /**
     Will dismiss the page and go back to the main page.
     
     - parameter sender: - **view** that called the function.
     
     */
    @objc func tap(_ sender: UIGestureRecognizer){
        switch sender.view {
        case exitButton:
            let transition      = CATransition()
            transition.duration = 0.4
            transition.type     = .push
            transition.subtype  = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false, completion: nil)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        days                 = Day.loadDays()
        formatter.dateFormat = "EEE - dd/MM/yy"
        let local = defaults.array(forKey: appleLanguagesString)
        formatter.locale = Locale(identifier: local?.first as! String)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDrinks(Date.init())
        setUpUI()
        changeAppearance()
    }
    //MARK: - Set up of UI
    
    /**
     Will set up the UI and must be called at the launche of the view.
     
     # Example #
     ```
     setUpUI()
     ```
     */
    func setUpUI(){
        self.view.addSubview(exitButton)
        self.view.addSubview(titleDate)
        self.view.addSubview(tableView)
        self.view.addSubview(calendar)
        
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight  < 700 {
            tableView.isScrollEnabled = true
        } else {
            tableView.isScrollEnabled = false
        }
        
        darkMode             = defaults.bool(forKey: darkModeString)
        metricUnits          = defaults.bool(forKey: metricUnitsString)
        tableView.delegate   = self
        tableView.dataSource = self
        calendar.delegate    = self
        calendar.dataSource  = self
        calendar.locale      = .current
        tableView.register(InfoCell.self, forCellReuseIdentifier: "customCell")
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "calendarCell") 
        calendar.allowsMultipleSelection = true
        let exitTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        exitButton.addGestureRecognizer(exitTapRecognizer)
        
        setConstraints()
    }
    
    /**
     Will sett the constraints for all the views in the view.
     
     # Notes: #
     1. The setUPUI must be called first and add all of the views.
     
     # Example #
     ```
     func setUpUI(){
     //Add the views
     setConstraints()
     }
     ```
     */
    func setConstraints(){
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        titleDate.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleDate.leftAnchor.constraint(equalTo: exitButton.rightAnchor, constant: 10).isActive = true
        titleDate.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        tableView.topAnchor.constraint(equalTo: titleDate.bottomAnchor,constant: 30).isActive = true
        tableView.bottomAnchor.constraint(equalTo: calendar.topAnchor, constant: -20).isActive = true
        
        calendar.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 10).isActive = true
        calendar.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        calendar.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        calendar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    //MARK: - Change appearence
    
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
        calendar.appearance.borderRadius = 1
        if darkMode {
            self.view.backgroundColor             = UIColor().hexStringToUIColor("#212121")
            calendar.backgroundColor              = UIColor().hexStringToUIColor("#212121")
            tableView.backgroundColor             = UIColor().hexStringToUIColor("#212121")
            titleDate.textColor                     = .white
            exitButton.tintColor                    = .lightGray
            calendar.appearance.headerTitleColor    = .white
            calendar.appearance.weekdayTextColor    = .white
            calendar.appearance.titleTodayColor     = .white
            calendar.appearance.titleDefaultColor   = .white
            calendar.appearance.titleSelectionColor = .white
        } else {
            self.view.backgroundColor               = .white
            calendar.backgroundColor                = .white
            tableView.backgroundColor               = .white
            titleDate.textColor                     = .darkGray
            exitButton.tintColor                    = .darkGray
            calendar.appearance.headerTitleColor    = .darkGray
            calendar.appearance.weekdayTextColor    = .darkGray
            calendar.appearance.titleTodayColor     = .darkGray
            calendar.appearance.titleDefaultColor   = .darkGray
            calendar.appearance.titleSelectionColor = .darkGray
        }
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
        print(formatter.string(from: dateOfDay))
        titleDate.text = formatter.string(from: dateOfDay).localizedCapitalized
        if days.contains(where: { formatter.string(from: $0.date) == formatter.string(from: dateOfDay) }){
            let day: Day = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: dateOfDay)})!
            drinks.append(day.goal)
            drinks.append(day.consumed)
        } else {
            drinks.append(Drink.init(typeOfDrink: "", amountOfDrink: 0))
            drinks.append(Drink.init(typeOfDrink: "", amountOfDrink: 0))
        }
    }
    
    /**
     Will take the averag of the last days upto 7 days and return a float.
     
     - returns: **Float** The average consumtion
     
     # Example #
     ```
     let average = getAverageFor()
     ```
     */
    func getAverageFor()-> Float {
        let average = Drink()
        for day in days {
            average.amount += day.consumed.amount
        }
        return average.amount / Float(days.count)
    }
    
    func getAverageFor(_ startDate: Date,_ endDate: Date)-> Float {
        var average = Float()
        var x = Float(0)
        for day in calendar.selectedDates {
            if days.contains(where: {formatter.string(from: $0.date) == formatter.string(from: day)}){
                let selectedDay = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: day)})
                average += selectedDay?.consumed.amount ?? 0
            }
            x += 1
        }
        return average / x
    }
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - Set up tableVeiw
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! InfoCell
        switch indexPath.row {
        case 0:
            cell.setLabels(NSLocalizedString("Consumed", comment: "Title of cell"),
                           "\(drinks[1].amount.clean)/\(drinks[0].amount.clean)")
        case 1:
            let average = Drink(typeOfDrink: "water", amountOfDrink: getAverageFor())
            cell.setLabels(NSLocalizedString("Average", comment: "Title of cell"), average.amount.clean)
        default:
            break
        }
        cell.metricUnits = true
        cell.selectionStyle = .none
        cell.changeAppearance(darkMode)
        if !metricUnits {
            cell.changeToImperial(drinks[indexPath.row])
        }
        return cell
    }
}

extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource{
    
    //MARK: - Set up calander
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "calendarCell", for: date, at: position) as! CalendarCell
        self.configure(cell: cell, for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        if days.contains(where: { formatter.string(from: $0.date) == formatter.string(from: date)}){
            return UIImage(named: "Water-drop")?.renderResizedImage(newWidth: 19)
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
        print("selected \(formatter.string(from: date))")
        tableView.reloadData()
        self.drinks.removeAll()
        self.getDrinks(date)
        calendar.selectedDates.forEach { (date) in
            print(formatter.string(from: date))
        }
        if calendar.selectedDates.count > 1 {
            let dates = calendar.selectedDates.sorted(by: {$0 < $1})
            let average = getAverageFor(dates.first!, dates.last!.addingTimeInterval(86400))
            print("Average amount consumed was \(average) \nFrom \(formatter.string(from: dates.first!)) and \(formatter.string(from: dates.last!))")
            titleDate.text = "\(formatter.string(from: dates.first!)) \n\(formatter.string(from: dates.last!))"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d/M"
            let consumedCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InfoCell
            consumedCell.setLabels("\(NSLocalizedString("Consumed", comment: "Title of cell")) - \(dateFormatter.string(from: date))",
                                   "\(String(format: "%.2f", drinks[1].amount))/\(String(format: "%.2f",drinks[0].amount))")
            let averageCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! InfoCell
            averageCell.setLabels("\(NSLocalizedString("Average", comment: "Title of cell"))",
                                  "\(String(format: "%.2f", average))")
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
        print("deselected \(formatter.string(from: date))")
        tableView.reloadData()
        self.drinks.removeAll()
        if calendar.selectedDates.count == 1 {
            self.getDrinks(calendar.selectedDates[0])
        } else {
            self.getDrinks(date)
        }
        calendar.selectedDates.forEach { (date) in
            print(formatter.string(from: date))
        }
        if calendar.selectedDates.count > 1 {
            let dates = calendar.selectedDates.sorted(by: {$0 < $1})
            let average = getAverageFor(dates.first!, dates.last!.addingTimeInterval(86400))
            print("Average amount consumed was \(average) \nFrom \(formatter.string(from: dates.first!)) and \(formatter.string(from: dates.last!))")
            titleDate.text = "\(formatter.string(from: dates.first!)) \n\(formatter.string(from: dates.last!))"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d/M"
            let consumedCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InfoCell
            consumedCell.setLabels("\(NSLocalizedString("Consumed", comment: "Title of cell")) - \(dateFormatter.string(from: date))",
                                   "\(drinks[1].amount.clean)/\(drinks[0].amount.clean)")
        } else if calendar.selectedDates.count == 0 {
            titleDate.text = "\(formatter.string(from: Date()))"
            self.getDrinks(Date())
            let consumedCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InfoCell
            consumedCell.setLabels("\(NSLocalizedString("Consumed", comment: "Title of cell"))",
                                   "\(drinks[3].amount.clean)/\(drinks[2].amount.clean)")
        }
    }
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let customCell = (cell as! CalendarCell)
        // Custom today layer
        customCell.todayHighlighter.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if calendar.selectedDates.isEmpty {
            if self.gregorian.isDateInToday(date) {
                customCell.todayHighlighter.isHidden = true
                customCell.selectionLayer.isHidden = false
                customCell.selectionType = SelectionType.single
            } else {
                customCell.todayHighlighter.isHidden = true
                customCell.selectionLayer.isHidden = true
            }
        } else {
            var selectionType = SelectionType.none
            
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                } else {
                    selectionType = .none
                }
            }
            if selectionType == .none {
                customCell.selectionLayer.isHidden = true
                return
            }
            if formatter.string(from: Date()) == formatter.string(from: date){
                customCell.todayHighlighter.isHidden = true
                customCell.selectionLayer.isHidden = false
                customCell.selectionType = selectionType
            } else {
                customCell.selectionLayer.isHidden = false
                customCell.selectionType = selectionType
            }
        }
    }
}
