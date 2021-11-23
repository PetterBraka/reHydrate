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
    
    @Binding var selectedDays: [Day]
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
        calendar.swipeToChooseGesture.minimumPressDuration = 0.3
        calendar.firstWeekday = firsWeekday.rawValue
        
        calendar.appearance.titleFont = .body
        calendar.appearance.weekdayFont = .body
        calendar.appearance.headerTitleFont = .title
        
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
        @Binding var selectedDays: [Day]
        @Binding var storedDays: [Day]
        
        let gregorian = Calendar(identifier: .gregorian)
        
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            return formatter
        } ()
        
        init(_ calender: CalendarModuleView) {
            self.parent = calender
            _selectedDays = calender.$selectedDays
            _storedDays = calender.$storedDays
        }
        
        func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
            let cell = calendar.dequeueReusableCell(withIdentifier: "calendarCell", for: date, at: position) as! CalendarCell
            parent.cellHeight = cell.frame.height
            configure(cell: cell, for: date)
            return cell
        }
        
        func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
            if let day = storedDays.first(where: { $0.isSameDay(as: date) }) {
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
            if let selectedDay = storedDays.first(where: { $0.isSameDay(as: date) }) {
                print("Selected \(formatter.string(from: date))")
                selectedDays.append(selectedDay)
            }
            self.updateVisibleCells(in: calendar)
        }
        
        func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
            print("deselected \(formatter.string(from: date))")
            selectedDays.removeAll(where: { $0.isSameDay(as: date) })
            self.updateVisibleCells(in: calendar)
        }
        
        private func updateVisibleCells(in calendar: FSCalendar) {
            calendar.visibleCells().forEach { (cell) in
                guard let date = calendar.date(for: cell) else { return }
                self.configure(cell: cell, for: date)
            }
        }
        
        private func configure(cell: FSCalendarCell, for date: Date) {
            guard let cell = cell as? CalendarCell else { return }
            // Custom today layer
            cell.todayHighlighter.isHidden = !gregorian.isDateInToday(date)
            // Configure selection layer
            
            if parent.selectedDays.isEmpty {
                highlightToday(with: date, for: cell)
                return
            }
            
            let selectionType = getSelection(for: date)
            if selectionType == .none {
                cell.selectionLayer.isHidden = true
                return
            } else {
                if gregorian.isDateInToday(date) {
                    cell.todayHighlighter.isHidden = true
                    cell.selectionLayer.isHidden = false
                    cell.selectionType = selectionType
                } else {
                    cell.selectionLayer.isHidden = false
                    cell.selectionType = selectionType
                }
            }
        }
        
        private func highlightToday(with date: Date, for cell: CalendarCell) {
            if gregorian.isDateInToday(date) {
                cell.todayHighlighter.isHidden = true
                cell.selectionLayer.isHidden = false
                cell.selectionType = .single
            } else {
                cell.todayHighlighter.isHidden = true
                cell.selectionLayer.isHidden = true
            }
        }
        
        private func getSelection(for date: Date) -> SelectionType {
            if selectedDays.contains(where: { $0.isSameDay(as: date) }) {
                let yesterday = gregorian.date(byAdding: .day, value: -1, to: date)!
                let tomorrow = gregorian.date(byAdding: .day, value: 1, to: date)!
                
                let includesYesterday = selectedDays.contains(where: { $0.isSameDay(as: yesterday) })
                let includesTomorrow = selectedDays.contains(where: { $0.isSameDay(as: tomorrow) })
                let includesDate = selectedDays.contains(where: { $0.isSameDay(as: date) })
                
                if includesYesterday && includesTomorrow {
                    return .middle
                }
                if includesYesterday && includesDate {
                    return .rightBorder
                }
                if includesTomorrow {
                    return .leftBorder
                }
                return .single
            }
            return .none
        }
    }
}

struct CalendarModuleView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarModuleView(selectedDays: .constant([]),
                           storedDays: .constant([]),
                           firsWeekday: .monday)
    }
}

