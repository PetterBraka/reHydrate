//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 28/11/2023.
//

import Foundation
import LoggingService
import PresentationInterface
import DayServiceInterface
import UnitServiceInterface
import DateServiceInterface

extension Screen.History {
    public final class Presenter: HistoryPresenterType {
        public typealias ViewModel = History.ViewModel
        public typealias Engine = (
            HasLoggerService &
            HasUnitService &
            HasDayService &
            HasDateService
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
        private let formatter: DateFormatter
        
        public init(engine: Engine, router: Router, formatter: DateFormatter) {
            self.engine = engine
            self.router = router
            self.formatter = formatter
            let dateNow = engine.dateService.now()
            let start = engine.dateService.getDate(byAdding: -(365 * 5), component: .day, to: dateNow)
            let past = engine.dateService.getDate(byAdding: -6, component: .day, to: dateNow)
            self.viewModel = .init(
                isLoading: false,
                details: .init(averageConsumed: "", averageGoal: "", totalConsumed: "", totalGoal: ""),
                chart: .init(title: "", points: [], selectedOption: .line),
                calendar: .init(highlightedMonth: dateNow, weekdayStart: .monday, range: start ... dateNow, days: []),
                selectedRange: past ... dateNow,
                selectedDays: 0,
                error: nil
            )
        }
        
        public func perform(action: History.Action) async {
            switch action {
            case .didTapBack:
                router.showHome()
            case .didAppear:
                guard let selectedRange = viewModel.selectedRange else { return }
                await updateViewModelWithDataBetween(start: selectedRange.lowerBound, end: selectedRange.upperBound)
            case .didTapClear:
                updateViewModel(isLoading: false, selectedRange: nil)
            case .didSelectChart(let chart):
                updateViewModel(isLoading: false, chartOption: chart, selectedRange: viewModel.selectedRange)
            case let .didTap(date):
                updateViewModel(isLoading: true, selectedRange: viewModel.selectedRange, highlightedMonth: date)
                let newRange: ClosedRange<Date>
                if let range = viewModel.selectedRange {
                    let startToDate = engine.dateService.daysBetween(range.lowerBound, end: date)
                    let endToDate = engine.dateService.daysBetween(date, end: range.upperBound)
                    if date > range.upperBound || startToDate > endToDate {
                        newRange = range.lowerBound ... date
                    } else {
                        newRange = date ... range.upperBound
                    }
                } else {
                    newRange = date ... engine.dateService.getDate(byAdding: 1, component: .day, to: date)
                }
                await updateViewModelWithDataBetween(start: newRange.lowerBound, end: newRange.upperBound)
            }
        }
    }
}

private extension Screen.History.Presenter {
    func updateViewModel(
        isLoading: Bool,
        averageConsumed: Double? = nil,
        averageGoal: Double? = nil,
        totalConsumed: Double? = nil,
        totalGoal: Double? = nil,
        chartPoints: [ViewModel.ChartData.Point]? = nil,
        chartOption: ViewModel.ChartData.Option? = nil,
        calendarRange: ClosedRange<Date>? = nil,
        calendarDays: [ViewModel.CalendarData.Day]? = nil,
        selectedRange: ClosedRange<Date>?,
        daysSelected: Int? = nil,
        weekdayStart: ViewModel.CalendarData.Weekday? = nil,
        highlightedMonth: Date? = nil,
        error: ViewModel.HistoryError? = nil
    ) {
        let title = if let startDate = selectedRange?.lowerBound ?? viewModel.selectedRange?.lowerBound,
            let endDate = selectedRange?.upperBound ?? viewModel.selectedRange?.upperBound {
            formatter.string(from: startDate) + " - " +
            formatter.string(from: endDate)
        } else {
            ""
        }
        let details = ViewModel.Details(
            averageConsumed: averageConsumed,
            averageGoal: averageGoal,
            totalConsumed: totalConsumed,
            totalGoal: totalGoal,
            unitSystem: engine.unitService.getUnitSystem()
        ) ?? viewModel.details
        let chart = ViewModel.ChartData(
            title: title,
            points: chartPoints ?? viewModel.chart.points,
            selectedOption: chartOption ?? viewModel.chart.selectedOption
        )
        let calendar = ViewModel.CalendarData(
            highlightedMonth: highlightedMonth ?? viewModel.calendar.highlightedMonth,
            weekdayStart: weekdayStart ?? viewModel.calendar.weekdayStart,
            range: calendarRange ?? viewModel.calendar.range,
            days: calendarDays ?? viewModel.calendar.days
        )
        viewModel = .init(
            isLoading: isLoading,
            details: details,
            chart: chart,
            calendar: calendar,
            selectedRange: selectedRange,
            selectedDays: daysSelected ?? viewModel.selectedDays,
            error: error
        )
    }
}

extension Array where Element == Screen.History.Presenter.ViewModel.ChartData.Point {
    init(from days: [Day], with formatter: DateFormatter) {
        self = days.map { day in
            .init(
                date: day.date,
                dateString: formatter.string(from: day.date),
                consumed: day.consumed,
                goal: day.goal
            )
        }
    }
}

private extension Screen.History.Presenter {
    func fetchDays(startDate: Date, endDate: Date) async -> [Day] {
        (try? await engine.dayService.getDays(between: startDate ... endDate)) ?? []
    }
    
    func updateViewModelWithDataBetween(start: Date, end: Date) async {
        let days = await fetchDays(startDate: start, endDate: end)
        let points: [ViewModel.ChartData.Point] = .init(from: days, with: formatter)
        var daysSelected = engine.dateService.daysBetween(start, end: end)
        if daysSelected == 0 {
            daysSelected = 1
        }
        
        let total = points.reduce(into: (goal: 0, consumed: 0)) { partial, point in
            let goal =  partial.goal + (point.goal ?? 0)
            let consumed = partial.consumed + (point.consumed ?? 0)
            partial = (goal, consumed)
        }
        
        let averageGoal = total.goal / Double(daysSelected)
        let averageConsumed = total.consumed / Double(daysSelected)
        
        updateViewModel(
            isLoading: false,
            averageConsumed: averageConsumed, averageGoal: averageGoal,
            totalConsumed: total.consumed, totalGoal: total.goal,
            chartPoints: points,
            calendarDays: days.mapToViewModel(),
            selectedRange: start ... end,
            daysSelected: daysSelected
        )
    }
    
    func getWeekRange(for date: Date) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        
        let weekday = calendar.component(.weekday, from: date)
        
        // Calculate the difference between the given date's weekday and the first day of the week (usually Sunday)
        let daysToAdd = calendar.firstWeekday - weekday
        
        let startDate = engine.dateService.getDate(byAdding: daysToAdd, component: .day, to: date)
        let endDate = engine.dateService.getDate(byAdding: 6, component: .day, to: date)
        return (start: startDate, end: endDate)
    }
    
    func getDates(startDate: Date, endDate: Date) -> [Date] {
        var currentDate = startDate
        var dates: [Date] = []
        
        while currentDate <= endDate {
            dates.append(currentDate)
            let newDate = engine.dateService.getDate(byAdding: 1, component: .day, to: currentDate)
            currentDate = newDate
        }
        
        return dates
    }
}

private extension Array where Element == Day {
    func mapToViewModel() -> [History.ViewModel.CalendarData.Day] {
        map {
            History.ViewModel.CalendarData.Day(
                date: $0.date,
                consumed: $0.consumed,
                goal: $0.goal
            )
        }
    }
}

extension History.ViewModel.Details {
    init?(averageConsumed: Double?, averageGoal: Double?,
         totalConsumed: Double?, totalGoal: Double?, unitSystem: UnitSystem) {
        let symbol = unitSystem == .metric ? UnitVolume.liters.symbol : UnitVolume.pints.symbol
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.allowsFloats = true
        
        guard let averageConsumed, let averageGoal, let totalConsumed, let totalGoal else { return nil }
        
        let averageConsumedString = formatter.string(from: averageConsumed as NSNumber) ?? "0"
        let averageGoalString = formatter.string(from: averageGoal as NSNumber) ?? "0"
        let totalConsumedString = formatter.string(from: totalConsumed as NSNumber) ?? "0"
        let totalGoalString = formatter.string(from: totalGoal as NSNumber) ?? "0"
        
        self.init(
            averageConsumed: averageConsumedString + " " + symbol,
            averageGoal: averageGoalString + " " + symbol,
            totalConsumed: totalConsumedString + " " + symbol,
            totalGoal: totalGoalString + " " + symbol
        )
    }
}
