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
    @Binding var storedDays: [Day]
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
        
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.swipeToChooseGesture.minimumPressDuration = 0.1
        calendar.firstWeekday = firsWeekday.rawValue
        
        calendar.appearance.titleFont = .body
        calendar.appearance.weekdayFont = .body
        calendar.appearance.headerTitleFont = .title
        calendar.appearance.borderRadius = 1
        
        calendar.appearance.headerTitleColor = .label
        calendar.appearance.weekdayTextColor = .label
        calendar.appearance.titleTodayColor = .label
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.titleSelectionColor = .label
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {}
    
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
            parent.cellHeight = cell.frame.height
            configure(cell: cell, for: date)
            return cell
        }
        
        func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
                if let day = parent.storedDays.first(where: { formatter.string(from: $0.date) == formatter.string(from: date) }) {
                    let percent = (day.consumption / day.goal ) * 100
                    switch percent {
                    case 0...10:
                        return UIImage.waterDrop0
                            .renderResizedImage(newWidth: parent.cellHeight * 0.4)
                    case 10...30:
                        return UIImage.waterDrop25
                            .renderResizedImage(newWidth: parent.cellHeight * 0.4)
                    case 30...60:
                        return UIImage.waterDrop50
                            .renderResizedImage(newWidth: parent.cellHeight * 0.4)
                    case 60...80:
                        return UIImage.waterDrop75
                            .renderResizedImage(newWidth: parent.cellHeight * 0.4)
                    default:
                        return UIImage.waterDrop100
                            .renderResizedImage(newWidth: parent.cellHeight * 0.4)
                    }
                }
            return nil
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            print("Selected \(formatter.string(from: date))")
            parent.selectedDates.append(Day(id: UUID(), consumption: 0, goal: 0, date: date))
            self.updateVisibleCells(in: calendar, for: date)
            if calendar.selectedDates.count > 1 {
                // check if starting and ending date is the same when swipe gesture is used
            }
        }
        
        func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
            print("deselected \(formatter.string(from: date))")
            parent.selectedDates.removeAll(where: { $0.date == date })
            self.updateVisibleCells(in: calendar, for: date)
        }
        
        private func updateVisibleCells(in calendar: FSCalendar, for date: Date) {
            calendar.visibleCells().forEach { (cell) in
                self.configure(cell: cell, for: date)
            }
        }
        
        private func configure(cell: FSCalendarCell, for date: Date) {
            let calendarCell = (cell as! CalendarCell)
            // Custom today layer
            calendarCell.todayHighlighter.isHidden = !parent.gregorian.isDateInToday(date)
            // Configure selection layer
            
            if parent.selectedDates.isEmpty {
                highlightToday(with: date, for: calendarCell)
                return
            }
            
            let selectionType = getSelection(with: date)
            
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
        
        func highlightToday(with date: Date, for cell: CalendarCell) {
            if parent.gregorian.isDateInToday(date) {
                cell.todayHighlighter.isHidden = true
                cell.selectionLayer.isHidden = false
                cell.selectionType = SelectionType.single
            } else {
                cell.todayHighlighter.isHidden = true
                cell.selectionLayer.isHidden = true
            }
        }
        
        func getSelection(with date: Date) -> SelectionType {
            var selectionType = SelectionType.none
            if parent.selectedDates.contains(where: { $0.date == date }) {
                let previousDate = parent.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = parent.gregorian.date(byAdding: .day, value: 1, to: date)!
                if parent.selectedDates.contains(where: { $0.date == date }) {
                    if parent.selectedDates.contains(where: { $0.date == previousDate }) && parent.selectedDates.contains(where: { $0.date == nextDate }) {
                        selectionType = .middle
                    }
                    else if parent.selectedDates.contains(where: { $0.date == previousDate }) &&
                                parent.selectedDates.contains(where: { $0.date == date}) {
                        selectionType = .rightBorder
                    }
                    else if parent.selectedDates.contains(where: { $0.date == nextDate }) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                } else {
                    selectionType = .none
                }
            }
            return selectionType
        }
    }
}

struct CalendarModuleView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarModuleView(selectedDates: .constant([]),
                           storedDays: .constant([]),
                           firsWeekday: .monday)
    }
}

