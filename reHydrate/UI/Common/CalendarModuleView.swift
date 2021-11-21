//
//  CalendarModuleView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import FSCalendar


struct CalendarModuleView: UIViewRepresentable {
    enum DayOfTheWeek: UInt {
        case monday = 2
        case tirsday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saterday = 7
        case sunday = 1
    }
    
    @Binding var selectedDates: [Day]
    var firsWeekday: DayOfTheWeek
    
    let gregorian = Calendar(identifier: .gregorian)
    var cellHeight = CGFloat()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.locale = .current
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "calendarCell") 
        calendar.appearance.todayColor = UIColor.systemGreen
        calendar.appearance.selectionColor = UIColor.systemBlue
        
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.swipeToChooseGesture.minimumPressDuration = 0.1
        calendar.firstWeekday = firsWeekday.rawValue
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.visibleCells().forEach { (cell) in
            let date = uiView.date(for: cell)
            let position = uiView.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let calendarCell = (cell as! CalendarCell)
        // Custom today layer
        calendarCell.todayHighlighter.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if self.selectedDates.isEmpty {
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
            
            if self.selectedDates.contains(where: { $0.date == date }) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if self.selectedDates.contains(where: { $0.date == date }) {
                    if self.selectedDates.contains(where: { $0.date == previousDate }) && self.selectedDates.contains(where: { $0.date == nextDate }) {
                        selectionType = .middle
                    }
                    else if self.selectedDates.contains(where: { $0.date == previousDate }) &&
                                self.selectedDates.contains(where: { $0.date == date}) {
                        selectionType = .rightBorder
                    }
                    else if self.selectedDates.contains(where: { $0.date == nextDate }) {
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
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
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
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        
        var parent: CalendarModuleView
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            return formatter
        } ()
        
        init(_ calender: CalendarModuleView) {
            self.parent = calender
        }
        
        func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
            let cell = calendar.dequeueReusableCell(withIdentifier: "calendarCell", for: date, at: position) as! CalendarCell
            parent.configure(cell: cell, for: date, at: position)
            return cell
        }
        
        func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//            if parent.selectedDates.contains(where:
//                                                    { formatter.string(from: $0.date) == formatter.string(from: date) }) {
//                let day = fetchDay(date)
//                let percent = (day!.consumed / day!.goal ) * 100
//                switch percent {
//                case 0...10:
//                    return UIImage.waterDrop0.renderResizedImage(newWidth: parent.cellHeight * 0.4)
//                case 10...30:
//                    return UIImage.waterDrop25.renderResizedImage(newWidth: parent.cellHeight * 0.4)
//                case 30...60:
//                    return UIImage.waterDrop50.renderResizedImage(newWidth: parent.cellHeight * 0.4)
//                case 60...80:
//                    return UIImage.waterDrop75.renderResizedImage(newWidth: parent.cellHeight * 0.4)
//                default:
//                    return UIImage.waterDrop100.renderResizedImage(newWidth: parent.cellHeight * 0.4)
//                }
//            }
            return nil
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            print("Selected \(formatter.string(from: date))")
            //                self.configureVisibleCells()
            if calendar.selectedDates.count > 1 {
                // check if starting and ending date is the same when swipe gesture is used
            }
        }
        
        func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
            //                self.configureVisibleCells()
            print("deselected \(formatter.string(from: date))")
            if parent.selectedDates.count == 1 {
                //                self.getDrinks(calendar.selectedDates[0])
            } else {
                //                self.getDrinks(date)
            }
        }
    }
}

struct CalendarModuleView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarModuleView(selectedDates: .constant([]),
                           firsWeekday: .monday)
    }
}

