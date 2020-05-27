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
    var darkMode        = Bool()
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
        days                 = Day.loadDay()
        formatter.dateFormat = "EEE - dd/MM/yy"
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
        
        darkMode             = defaults.bool(forKey: "darkMode")
        metricUnits          = defaults.bool(forKey: "metricUnits")
        tableView.delegate   = self
        tableView.dataSource = self
        calendar.delegate    = self
        calendar.dataSource  = self
        calendar.locale      = .current
        tableView.register(InfoCell.self, forCellReuseIdentifier: "customCell")
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "calendarCell") 
        
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
        if days.contains(where: { formatter.string(from: $0.date) == formatter.string(from: dateOfDay) }){
            let day: Day = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: dateOfDay)})!
            drinks.append(day.goalAmount)
            drinks.append(day.consumedAmount)
        } else {
            drinks.append(Drink.init(typeOfDrink: "", amountOfDrink: 0))
            drinks.append(Drink.init(typeOfDrink: "", amountOfDrink: 0))
        }
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
            calendar.backgroundColor              = hexStringToUIColor(hex: "#212121")
            self.view.backgroundColor             = hexStringToUIColor(hex: "#212121")
            tableView.backgroundColor             = hexStringToUIColor(hex: "#212121")
            titleDate.textColor                   = .white
            calendar.appearance.headerTitleColor  = .white
            calendar.appearance.weekdayTextColor  = hexStringToUIColor(hex: "#cfcfcf")
            calendar.appearance.titleDefaultColor = .white
            exitButton.tintColor                  = .lightGray
        } else {
            calendar.backgroundColor              = .white
            calendar.appearance.headerTitleColor  = .black
            calendar.appearance.weekdayTextColor  = .black
            calendar.appearance.titleDefaultColor = .black
            self.view.backgroundColor             = .white
            tableView.backgroundColor             = .white
            titleDate.textColor                   = .black
            exitButton.tintColor                  = .black
        }
    }
    
    /**
     Will take the averag of the last days upto 7 days and return a float.
     
     - returns: **Float** The average consumtion
     
     # Example #
     ```
     let average = getAverage()
     ```
     */
    func getAverage()-> Float {
        let average = Drink()
        for day in days {
            average.amountOfDrink += day.consumedAmount.amountOfDrink
        }
        return average.amountOfDrink / Float(days.count)
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
                    cell.setLabels(NSLocalizedString("Consumed", comment: "Title of cell"), "\(String(format: "%.2f", drinks[1].amountOfDrink))/\(String(format: "%.2f",drinks[0].amountOfDrink))")
                case 1:
                    let average = Drink(typeOfDrink: "water", amountOfDrink: getAverage())
                    cell.setLabels(NSLocalizedString("Average", comment: "Title of cell"), String(format: "%.2f",average.amountOfDrink))
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
        print(date.description)
        drinks.removeAll()
        getDrinks(date)
        tableView.reloadData()
    }
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! CalendarCell)
        // Custom today layer
        diyCell.todayHighlighter.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        
        if calendar.selectedDates.isEmpty {
            if self.gregorian.isDateInToday(date) {
                diyCell.todayHighlighter.isHidden = true
                diyCell.selectionLayer.isHidden = false
                diyCell.selectionType = SelectionType.single
            } else {
                diyCell.todayHighlighter.isHidden = true
                diyCell.selectionLayer.isHidden = true
            }
        } else {
            
            var selectionType = SelectionType.none
            
            if calendar.selectedDates.contains(date) {
                if calendar.selectedDates.contains(date) {
                    selectionType = .single
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            if formatter.string(from: Date()) == formatter.string(from: date){
                diyCell.todayHighlighter.isHidden = true
                diyCell.selectionLayer.isHidden = false
                diyCell.selectionType = selectionType
            } else {
                diyCell.selectionLayer.isHidden = false
                diyCell.selectionType = selectionType
            }
            if position != .current {
                calendar.setCurrentPage(date, animated: true)
            }
        }
    }
}

extension UIImage {
    func renderResizedImage (newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        let image = renderer.image { (context) in
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
        return image
    }
}
