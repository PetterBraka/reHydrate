//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 06/12/2023.
//

import Foundation

final class Presenter: PresenterType {
    public weak var scene: SceneType?
    private(set) var viewModel: ViewModel {
        didSet { scene?.perform(update: .viewModel) }
    }
    
    private var startOfWeek: Weekday
    private let calendar: Calendar = Calendar.current
    
    init(month: Int, year: Int, startOfWeek: Weekday) {
        self.viewModel = ViewModel(weekdays: [], dates: [])
        self.startOfWeek = startOfWeek
        updateViewModel(month: year, year: month)
    }
    
    func perform(action: Action) {
        switch action {
        case .didAppear:
            break
        case let .didTap(date):
            print(date)
        }
    }
}

private extension Presenter {
    func updateViewModel(month: Int, year: Int) {
        let startOfMonth = getStartOfMonth(month: month, year: year)
        let endOfMonth = getEndOfMonth(from: startOfMonth)
        
        let daysToAddBefore = getDaysToAddBefore(startOfMonth)
        let daysToAddAfter = getDaysToAddAfter(endOfMonth)
        let firstDate = calendar.date(byAdding: .day, value: -daysToAddBefore, to: startOfMonth)!
        let lastDate = calendar.date(byAdding: .day, value: daysToAddAfter, to: endOfMonth)!
        let dates = generateDates(from: firstDate, to: lastDate)
            .map { [weak self] date -> ViewModel.CalendarDate in
                ViewModel.CalendarDate(
                    date: date,
                    isWeekday: self?.isWeekday(date) ?? false ,
                    isThisMonth: self?.isDate(inMonth: month, date) ?? false,
                    isToday: Calendar.current.isDateInToday(date)
                )
            }
        
        let weekdays = getWeekdayLabels()
        
        viewModel = ViewModel(weekdays: weekdays, dates: dates)
    }
    
    func getWeekdayLabels() -> [String] {
        calendar.shortWeekdaySymbols
            .rotate(toStartAt: startOfWeek.number - 1)
    }
    
    func getStartOfMonth(month: Int, year: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: 1)
        return calendar.date(from: components) ?? Date()
    }
    
    func getEndOfMonth(from date: Date) -> Date {
        calendar.date(byAdding: .init(month: 1, day: -1), to: date)!
    }
    
    func getDaysToAddBefore(_ startOfMonth: Date) -> Int {
        let startWeekday = calendar.component(.weekday, from: startOfMonth)
        return (startWeekday - calendar.firstWeekday + 7) % 7
    }
    
    func getDaysToAddAfter(_ endOfMonth: Date) -> Int {
        let daysToAddAfter = calendar.component(.weekday, from: endOfMonth)
        return (daysToAddAfter == 7) ? 6 : (7 - daysToAddAfter)
    }
    
    func generateDates(from start: Date, to end: Date) -> [Date] {
        var currentDate = start
        var resultDates: [Date] = []
        
        while currentDate <= end {
            resultDates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return resultDates
    }
    
    func isDate(inMonth month: Int, _ date: Date) -> Bool {
        calendar.component(.month, from: date) == month
    }
    
    func isWeekday(_ date: Date) -> Bool {
        let weekday = calendar.component(.weekday, from: date)
        
        switch weekday {
        case 1, 7: // 1 is Sunday, 7 is Saturday
            return false
        default:
            return true
        }
    }
}
