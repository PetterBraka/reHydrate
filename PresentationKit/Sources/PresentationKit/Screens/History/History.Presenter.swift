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
        
        private let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "DD/MM/YY"
            return formatter
        }()
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
            let start = Calendar.current.date(byAdding: .year, value: -2, to: .now)!
            let end = Calendar.current.date(byAdding: .month, value: 1, to: .now)!
            viewModel = .init(
                isLoading: false,
                startDate: "",
                endDate: "",
                data: [], 
                chart: .bar,
                chartOption: ViewModel.ChartType.allCases,
                dateRange: start ... end,
                highlightedDates: [],
                weekdayStart: .monday, 
                highlightedMonth: .now,
                error: nil
            )
        }
        
        public func perform(action: History.Action) async {
            switch action {
            case .didTapBack:
                router.showHome()
            case .didAppear:
                updateViewModel(isLoading: true)
                if let start = formatter.date(from: viewModel.startDate),
                   let end = formatter.date(from: viewModel.endDate) {
                    let days = await fetchDays(startDate: start, endDate: end)
                    updateViewModel(isLoading: false, data: days)
                } else {
                    
                }
//            case .didSelectRange(let range):
//                updateViewModel(isLoading: true, range: range)
//                let dates = getDates(from: range)
//                let days = await fetchDays(for: dates)
//                updateViewModel(isLoading: false, days: days, dates: dates)
            case .didSelectChart(let chart):
                updateViewModel(isLoading: false, chart: chart)
            case let .didChangeHighlightedMonthTo(date):
                break
            case let .didTap(date):
                break
            }
        }
    }
}

private extension Screen.History.Presenter {
    func updateViewModel(
        isLoading: Bool,
        startDate: Date? = nil,
        endDate: Date? = nil,
        data: [ViewModel.ChartData]? = nil,
        chart: ViewModel.ChartType? = nil,
        chartOption: [ViewModel.ChartType]? = nil,
        dateRange: ClosedRange<Date>? = nil,
        highlightedDates: [Date]? = nil,
        weekdayStart: ViewModel.Weekday? = nil,
        highlightedMonth: Date? = nil,
        error: ViewModel.HistoryError? = nil
    ) {
        let startDateString: String
        if let startDate {
            startDateString = formatter.string(from: startDate)
        } else {
            startDateString = viewModel.startDate
        }
        let endDateString: String
        if let endDate{
            endDateString = formatter.string(from: endDate)
        } else {
            endDateString = viewModel.startDate
        }
        viewModel = .init(
            isLoading: isLoading,
            startDate: startDateString,
            endDate: endDateString,
            data: data ?? viewModel.data,
            chart: chart ?? viewModel.chart,
            chartOption: chartOption ?? viewModel.chartOption,
            dateRange: dateRange ?? viewModel.dateRange,
            highlightedDates: highlightedDates ?? viewModel.highlightedDates,
            weekdayStart: weekdayStart ?? viewModel.weekdayStart,
            highlightedMonth: highlightedMonth ?? viewModel.highlightedMonth,
            error: error
        )
    }
}

private extension Screen.History.Presenter {
    func fetchDays(startDate: Date, endDate: Date) async -> [ViewModel.ChartData] {
        let dates = getDates(startDate: startDate, endDate: endDate)
        let daysFound = await engine.dayService.getDays(for: dates)
        
        return dates
            .map { [weak self] date in
                guard let self else {
                    return ViewModel.ChartData(date: "", consumed: nil, goal: nil)
                }
                let dateString = self.formatter.string(from: date)
                let day = daysFound.first(where: {
                    self.formatter.string(from: $0.date) == dateString
                })
                return if let day {
                    ViewModel.ChartData(date: dateString, consumed: day.consumed, goal: day.goal)
                } else {
                    ViewModel.ChartData(date: dateString, consumed: nil, goal: nil)
                }
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
    
    func getDates(startDate: Date, endDate: Date) -> [Date] {
        var currentDate = startDate
        var dates: [Date] = []
        
        while currentDate <= endDate {
            dates.append(currentDate)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            else { break }
            currentDate = newDate
        }
        
        return dates
    }
}
