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
    
    private var month: Int
    private var year: Int
    
    init(month: Int, year: Int, startOfWeek: Weekday) {
        self.month = month
        self.year = year
        self.viewModel = ViewModel(month: month, weekdays: [], dates: [], swipeDirection: nil)
        self.startOfWeek = startOfWeek
        
        updateViewModel(month: month, year: year, direction: nil)
    }
    
    func perform(action: Action) {
        switch action {
        case .didAppear:
            break
        case let .didTap(date):
            print(date)
        case .didSwipeLeft:
            let components = DateComponents(year: year, month: month, day: 1)
            guard let dateFromComponents = calendar.date(from: components),
                  let date = calendar.date(byAdding: .init(month: -1),
                                           to: dateFromComponents)
            else { return }
            year = calendar.component(.year, from: date)
            month = calendar.component(.month, from: date)
            updateViewModel(month: month, year: year, direction: .left)
        case .didSwipeRight:
            let components = DateComponents(year: year, month: month, day: 1)
            guard let dateFromComponents = calendar.date(from: components),
                  let date = calendar.date(byAdding: .init(month: 1),
                                           to: dateFromComponents)
            else { return }
            year = calendar.component(.year, from: date)
            month = calendar.component(.month, from: date)
            updateViewModel(month: month, year: year, direction: .right)
        }
    }
}

private extension Presenter {
    func updateViewModel(month: Int, year: Int, direction: SwipeDirection?) {
        let startOfMonth = getStartOfMonth(month: month, year: year)
        guard let endOfMonth = getEndOfMonth(from: startOfMonth)
        else { return }
        
        let daysToAddBefore = getDaysToAddBefore(startOfMonth)
        let daysToAddAfter = getDaysToAddAfter(endOfMonth)
        guard let firstDate = calendar.date(byAdding: .day, value: -daysToAddBefore, to: startOfMonth),
        let lastDate = calendar.date(byAdding: .day, value: daysToAddAfter, to: endOfMonth)
        else { return }
        
        viewModel = ViewModel(
            month: month,
            weekdays: getWeekdayLabels(),
            dates: generateDates(from: firstDate, to: lastDate)
                .map { [weak self] date -> ViewModel.CalendarDate in
                    ViewModel.CalendarDate(
                        date: date,
                        isWeekday: self?.isWeekday(date) ?? false ,
                        isThisMonth: self?.isDate(inMonth: month, date) ?? false,
                        isToday: Calendar.current.isDateInToday(date)
                    )
                },
            swipeDirection: direction
        )
    }
    
    func getWeekdayLabels() -> [String] {
        calendar.shortWeekdaySymbols
            .rotate(toStartAt: startOfWeek.number - 1)
    }
    
    func getStartOfMonth(month: Int, year: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: 1)
        return calendar.date(from: components) ?? Date()
    }
    
    func getEndOfMonth(from date: Date) -> Date? {
        calendar.date(byAdding: .init(month: 1, day: -1), to: date)
    }
    
    func getDaysToAddBefore(_ startOfMonth: Date) -> Int {
        let startWeekday = calendar.component(.weekday, from: startOfMonth)
        
        return (startWeekday - startOfWeek.number + 7) % 7
    }
    
    func getDaysToAddAfter(_ endOfMonth: Date) -> Int {
        let daysToAddAfter = calendar.component(.weekday, from: endOfMonth)
        let weekdayIndex = startOfWeek.number - 1
        if daysToAddAfter == 7 {
            return (6 + weekdayIndex) % 7
        } else {
            return (7 - daysToAddAfter + weekdayIndex) % 7
        }
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
        case Weekday.saturday.number,
             Weekday.sunday.number:
            return false
        default:
            return true
        }
    }
}
