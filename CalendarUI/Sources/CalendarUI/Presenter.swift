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
    
    init(month: Int, year: Int) {
        self.viewModel = ViewModel(dates: [])
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
        let calendar = Calendar.current
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
        viewModel = ViewModel(dates: dates)
    }
    
    // Helper function to get the start of the month
    func getStartOfMonth(month: Int, year: Int) -> Date {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: 1)
        return calendar.date(from: components) ?? Date()
    }
    
    // Helper function to get the end of the month
    func getEndOfMonth(from date: Date) -> Date {
        Calendar.current.date(byAdding: .init(month: 1, day: -1), to: date)!
    }
    
    // Helper function to get the number of days to add before the first day of the month
    func getDaysToAddBefore(_ startOfMonth: Date) -> Int {
        let calendar = Calendar.current
        let startWeekday = calendar.component(.weekday, from: startOfMonth)
        return (startWeekday - calendar.firstWeekday + 7) % 7
    }
    
    // Helper function to get the number of days to add after the last day of the month
    func getDaysToAddAfter(_ endOfMonth: Date) -> Int {
        let calendar = Calendar.current
        let daysToAddAfter = calendar.component(.weekday, from: endOfMonth)
        return (daysToAddAfter == 7) ? 6 : (7 - daysToAddAfter)
    }
    
    // Helper function to generate an array of dates within the current month
    func generateDates(from start: Date, to end: Date) -> [Date] {
        var currentDate = start
        var resultDates: [Date] = []
        
        while currentDate <= end {
            resultDates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return resultDates
    }
    
    // Helper function to check if a date is in the same month as the displayed month
    func isDate(inMonth month: Int, _ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.component(.month, from: date) == month
    }
    
    func isWeekday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        switch weekday {
        case 1, 7: // 1 is Sunday, 7 is Saturday
            return false
        default:
            return true
        }
    }
}