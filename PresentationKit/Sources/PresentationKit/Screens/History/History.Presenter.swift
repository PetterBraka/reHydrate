//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 28/11/2023.
//

import Foundation
import LoggingService
import HistoryPresentationInterface
import DayServiceInterface
import UnitServiceInterface

extension Screen.History {
    public final class Presenter: HistoryPresenterType {
        public typealias ViewModel = History.ViewModel
        
        public typealias Engine = (
            HasLoggingService &
            HasUnitService &
            HasDayService
        )
        public typealias Router = (
            HistoryRoutable
        )
        
        private let engine: Engine
        private let router: Router
        
        public weak var scene: HistorySceneType?
        public private(set) var viewModel: ViewModel {
            didSet { scene?.perform(update: .viewModel) }
        }
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
            viewModel = .init(isLoading: true, days: [], dates: [], chart: .bar, chartOption: ViewModel.ChartType.allCases,
                              range: .week, rangeOptions: ViewModel.ChartRange.allCases)
            Task {
                let dates = getDates(from: viewModel.range)
                let days = await fetchDays(for: dates)
                updateViewModel(isLoading: false, days: days, dates: dates)
            }
        }
        
        public func perform(action: History.Action) async {
            switch action {
            case .didTapBack:
                router.showHome()
            case .didAppear:
                updateViewModel(isLoading: true)
                let dates = getDates(from: viewModel.range)
                let days = await fetchDays(for: dates)
                updateViewModel(isLoading: false, days: days, dates: dates)
            case .didSelectRange(let range):
                updateViewModel(isLoading: true, range: range)
                let dates = getDates(from: range)
                let days = await fetchDays(for: dates)
                updateViewModel(isLoading: false, days: days, dates: dates)
            case .didSelectChart(let chart):
                updateViewModel(isLoading: false, chart: chart)
            }
        }
    }
}

private extension Screen.History.Presenter {
    func updateViewModel(isLoading: Bool,
                         days: [History.ViewModel.Day]? = nil,
                         dates: [Date]? = nil,
                         chart: History.ViewModel.ChartType? = nil,
                         chartOption: [History.ViewModel.ChartType]? = nil,
                         range: History.ViewModel.ChartRange? = nil,
                         rangeOptions: [History.ViewModel.ChartRange]? = nil) {
        viewModel = .init(
            isLoading: isLoading,
            days: days ?? viewModel.days,
            dates: dates ?? viewModel.dates,
            chart: chart ?? viewModel.chart,
            chartOption: chartOption ?? viewModel.chartOption,
            range: range ?? viewModel.range,
            rangeOptions: rangeOptions ?? viewModel.rangeOptions
        )
    }
}

private extension Screen.History.Presenter {
    func fetchDays(for dates: [Date]) async -> [ViewModel.Day] {
        let daysFound = await engine.dayService.getDays(for: dates)
            .map { ViewModel.Day(from: $0) }
        return daysFound
    }
    
    func getDates(from range: ViewModel.ChartRange) -> [Date] {
        guard let startEnd = getRange(for: .now, selectedRange: range)
        else { return [] }
        var currentDate = startEnd.start
        var dates: [Date] = []
        
        while currentDate <= startEnd.end {
            dates.append(currentDate)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            else { break }
            currentDate = newDate
        }
        
        return dates
    }
    
    func getRange(for date: Date, selectedRange: ViewModel.ChartRange) -> (start: Date, end: Date)? {
        switch selectedRange {
        case .week:
            return getWeekRange(for: date)
        case .month:
            return getMonthRange(for: date)
        case .quarter:
            return getQuarterRange(for: date)
        case .year:
            return getYearRange(for: date)
        }
    }
    
    func getWeekRange(for date: Date) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        
        let weekday = calendar.component(.weekday, from: date)
        
        // Calculate the difference between the given date's weekday and the first day of the week (usually Sunday)
        let daysToAdd = calendar.firstWeekday - weekday
        
        guard let startDate = calendar.date(byAdding: .day, value: daysToAdd, to: date),
              let endDate = calendar.date(byAdding: .day, value: 6, to: startDate)
        else {
            return nil
        }
        return (start: startDate, end: endDate)
    }
    
    func getMonthRange(for date: Date) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.day, .month, .year], from: date)
        components.day = 1
        
        guard let startDate = calendar.date(from: components),
              let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)
        else {
            return nil
        }
        return (start: startDate, end: endDate)
    }
    
    func getQuarterRange(for date: Date) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.day, .month, .year], from: date)
        components.day = 1
        
        guard let startDate = calendar.date(from: components),
              let endDate = calendar.date(byAdding: DateComponents(month: 3, day: -1), to: startDate)
        else {
            return nil
        }
        return (start: startDate, end: endDate)
    }
    
    func getYearRange(for date: Date) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.day, .month, .year], from: date)
        components.day = 1
        components.month = 1
        
        guard let startDate = calendar.date(from: components),
              let endDate = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startDate)
        else {
            return nil
        }
        return (start: startDate, end: endDate)
    }
}

fileprivate extension History.ViewModel.Day {
    init(from day: Day) {
        self.init(date: day.date,
                  consumed: day.consumed,
                  goal: day.goal)
    }
}
