//
//  CalenderScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 06/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import Hero
import UIKit
import CoreData
import FSCalendar

class CalendarVC: UIViewController {
    
    let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var metricUnits = Bool()
    let formatter   = DateFormatter()
    let defaults    = UserDefaults.standard
    var cellHeight  = CGFloat()
    var drinks: [Double] = []
    var darkMode = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return darkMode ? .lightContent : .darkContent
        } else {
            return .default
        }
    }
    var exitButton: UIButton    = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        if #available(iOS 13.0, *) {
            button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        } else {
            button.setBackgroundImage(UIImage(named: "xmark.circle")?.colored(.darkGray), for: .normal)
        }
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
    var days: [Day] = []
    
    /**
     Will dismiss the page and go back to the main page.
     
     - parameter sender: - **view** that called the function.
     
     */
    @objc func tap(_ sender: UIGestureRecognizer){
        switch sender.view {
        case exitButton:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .right {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHeroEnabled = true
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
    
    ///Will set up the UI and must be called at the launche of the view.
    fileprivate func setUpUI(){
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
        tableView.register(InfoCell.self, forCellReuseIdentifier: "customCell")
        
        calendar.delegate    = self
        calendar.dataSource  = self
        calendar.locale      = .current
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "calendarCell") 
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.swipeToChooseGesture.minimumPressDuration = 0.1
        
        setUpGestrues()
        setConstraints()
    }
    
    /// Setting gesture recognizers for swiping and tapping.
    fileprivate func setUpGestrues(){
        let exitTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        
        rightGesture.direction = .right
        
        exitButton.addGestureRecognizer(exitTapRecognizer)
        self.view.addGestureRecognizer(rightGesture)
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
        
        calendar.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30).isActive = true
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
            calendar.appearance.headerTitleColor    = .white
            calendar.appearance.weekdayTextColor    = .white
            calendar.appearance.titleTodayColor     = .white
            calendar.appearance.titleDefaultColor   = .white
            calendar.appearance.titleSelectionColor = .white
            if #available(iOS 13, *) {
                exitButton.tintColor                = .lightGray
            } else {
                exitButton.setBackgroundImage(UIImage(named: "xmark.circle")?.colored(.lightGray), for: .normal)
            }
        } else {
            self.view.backgroundColor               = .white
            calendar.backgroundColor                = .white
            tableView.backgroundColor               = .white
            titleDate.textColor                     = .black
            calendar.appearance.headerTitleColor    = .black
            calendar.appearance.weekdayTextColor    = .black
            calendar.appearance.titleTodayColor     = .black
            calendar.appearance.titleDefaultColor   = .black
            calendar.appearance.titleSelectionColor = .black
            if #available(iOS 13, *) {
                exitButton.tintColor                = .black
            } else {
                exitButton.setBackgroundImage(UIImage(named: "xmark.circle")?.colored(.black), for: .normal)
            }
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
        titleDate.text = formatter.string(from: dateOfDay).localizedCapitalized
        
        let day = fetchDay(dateOfDay)
        if day != nil {
            drinks.append(day!.goal)
            drinks.append(day!.consumed)
        }
    }
    
    /**
     Will take the averag of the last days upto 7 days and return a **Double**.
     
     - returns: a **Double** with the average consumtion
     
     # Example #
     ```
     let average = getAverageFor()
     ```
     */
    func getAverageFor()-> Double {
        var average = Double()
        if days.isEmpty {
            for day in days {
                average  += day.consumed
            }
            return average  / Double(days.count)
        }
        return 0
    }
    
    func getAverageFor(_ startDate: Date,_ endDate: Date)-> Double {
        var average = Double()
        var x = Int(0)
        if days.isEmpty {
            for day in calendar.selectedDates {
                if days.contains(where: {formatter.string(from: $0.date) == formatter.string(from: day)}){
                    let selectedDay = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: day)})
                    average += selectedDay?.consumed  ?? 0
                }
                x += 1
            }
            return average / Double(x)
        } else {
            return 0
        }
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
                           "\(drinks[1].clean)/\(drinks[0].clean)")
        case 1:
            let average = getAverageFor()
            cell.setLabels(NSLocalizedString("Average", comment: "Title of cell"), String(average.clean))
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
        cellHeight = cell.frame.height
        self.configure(cell: cell, for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        self.days = fetchDays()
        if days.contains(where: {formatter.string(from: $0.date) == formatter.string(from: date)}){
            let day = fetchDay(date)
            let percent = (day!.consumed / day!.goal ) * 100
            switch percent {
            case 0...10:
                if darkMode {
                    let newImage = UIImage(named: "water.drop.0.full.dark")?.renderResizedImage(newWidth: cellHeight * 0.4)
                    return newImage
                }else {
                    let newImage = UIImage(named: "water.drop.0.full.light")?.renderResizedImage(newWidth: cellHeight * 0.4)
                    return newImage
                }
            case 10...30:
                if darkMode {
                    let newImage = UIImage(named: "water.drop.25.full.dark")?.renderResizedImage(newWidth: cellHeight * 0.4)
                    return newImage
                }else {
                    let newImage = UIImage(named: "water.drop.25.full.light")?.renderResizedImage(newWidth: cellHeight * 0.4)
                    return newImage
                }
            case 30...60:
                if darkMode {
                    let newImage = UIImage(named: "water.drop.50.full.dark")?.renderResizedImage(newWidth: cellHeight * 0.4)
                    return newImage
                }else {
                    let newImage = UIImage(named: "water.drop.50.full.light")?.renderResizedImage(newWidth: cellHeight * 0.4)
                    return newImage
                }
            case 60...80:
                if darkMode {
                    let newImage = UIImage(named: "water.drop.75.full.dark")?.renderResizedImage(newWidth: cellHeight * 0.4)
                    return newImage
                }else {
                    let newImage = UIImage(named: "water.drop.75.full.light")?.renderResizedImage(newWidth: cellHeight * 0.4)
                    return newImage
                }
            default:
                if darkMode {
                    let newImage = UIImage(named: "water.drop.full.dark")?.renderResizedImage(newWidth: cellHeight * 0.4)
                    return newImage
                }else {
                    let newImage = UIImage(named: "water.drop.full.light")?.renderResizedImage(newWidth: cellHeight * 0.4)
                    return newImage
                }
            }
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Selected \(formatter.string(from: date))")
        checkSelections(calendar, date)
        self.configureVisibleCells()
        tableView.reloadData()
        self.drinks.removeAll()
        self.getDrinks(date)
        if calendar.selectedDates.count > 1 {
            let dates = calendar.selectedDates.sorted(by: {$0 < $1})
            let average = getAverageFor(dates.first!, dates.last!.addingTimeInterval(86400))
            titleDate.text = "\(formatter.string(from: dates.first!)) \n\(formatter.string(from: dates.last!))"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d/M"
            let consumedCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InfoCell
            consumedCell.setLabels("\(NSLocalizedString("Consumed", comment: "Title of cell")) - \(dateFormatter.string(from: date))", "\(drinks[1] .clean)/\(drinks[0] .clean)")
            let averageCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! InfoCell
            averageCell.setLabels("\(NSLocalizedString("Average", comment: "Title of cell"))",
                                  "\(average.clean)")
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
        print("deselected \(formatter.string(from: date))")
        checkSelections(calendar, date)
        tableView.reloadData()
        self.drinks.removeAll()
        if calendar.selectedDates.count == 1 {
            self.getDrinks(calendar.selectedDates[0])
        } else {
            self.getDrinks(date)
        }
        if calendar.selectedDates.count > 1 {
            let dates = calendar.selectedDates.sorted(by: {$0 < $1})
            let average = getAverageFor(dates.first!, dates.last!.addingTimeInterval(86400))
            titleDate.text = "\(formatter.string(from: dates.first!)) \n\(formatter.string(from: dates.last!))"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d/M"
            let consumedCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InfoCell
            consumedCell.setLabels("\(NSLocalizedString("Consumed", comment: "Title of cell")) - \(dateFormatter.string(from: date))",
                                   "\(drinks[1] )/\(drinks[0] )")
            let averageCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! InfoCell
            averageCell.setLabels("\(NSLocalizedString("Average", comment: "Title of cell"))",
                                  "\(average.clean)")
        } else if calendar.selectedDates.count == 0 {
            titleDate.text = "\(formatter.string(from: Date()))"
            self.getDrinks(Date())
            let consumedCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InfoCell
            consumedCell.setLabels("\(NSLocalizedString("Consumed", comment: "Title of cell"))",
                                   "\(drinks[3] )/\(drinks[2] )")
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
        
        let calendarCell = (cell as! CalendarCell)
        // Custom today layer
        calendarCell.todayHighlighter.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if calendar.selectedDates.isEmpty {
            if self.gregorian.isDateInToday(date) {
                calendarCell.todayHighlighter.isHidden = true
                calendarCell.selectionLayer.isHidden = false
                calendarCell.selectionType = SelectionType.single
            } else {
                calendarCell.todayHighlighter.isHidden = true
                calendarCell.selectionLayer.isHidden = true
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
                calendarCell.selectionLayer.isHidden = true
                return
            }
            if formatter.string(from: Date()) == formatter.string(from: date){
                calendarCell.todayHighlighter.isHidden = true
                calendarCell.selectionLayer.isHidden = false
                calendarCell.selectionType = selectionType
            } else {
                calendarCell.selectionLayer.isHidden = false
                calendarCell.selectionType = selectionType
            }
        }
    }
    
    func checkSelections(_ calendar: FSCalendar, _ date: Date) {
        var tempDates = calendar.selectedDates
        tempDates.sort(by: {$0 < $1})
        var i = 0
        while i < tempDates.count - 1 && tempDates.count > 1{
            if Calendar.current.date(byAdding: .day, value: 1, to: tempDates[i])! != tempDates[i + 1] {
                switch calendar.swipeToChooseGesture.state {
                case .changed:
                    if #available(iOS 13.0, *) {
                        let differece = tempDates[i].distance(to: tempDates[i + 1])
                        let days = differece / 60 / 60 / 24
                        for x in 1...Int(days - 1){
                            calendar.select(Calendar.current.date(byAdding: .day, value: x, to: tempDates[i]))
                        }
                        calendar.reloadData()
                    } else {
                        // Fallback on earlier versions
                    }
                default:
                    calendar.selectedDates.forEach { (selectedDate) in
                        calendar.deselect(selectedDate)
                    }
                    calendar.select(date)
                    calendar.reloadData()
                    return
                }
            }
            i += 1
        }
    }
}
