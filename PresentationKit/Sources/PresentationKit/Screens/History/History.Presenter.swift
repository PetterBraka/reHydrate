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
            HasLoggingService &
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
        
        private let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }()
        
        private var selectedRange: ClosedRange<Date>?
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
            let calendarRange = (
                engine.dateService.getDate(
                    byAdding: -(365 * 5),
                    component: .day,
                    to: engine.dateService.now()
                ) ... engine.dateService.now())
            let past = engine.dateService.getDate(
                byAdding: -6, component: .day, 
                to: engine.dateService.now()
            )
            selectedRange =  past ... engine.dateService.now()
            self.viewModel = .init(
                isLoading: false,
                details: .init(averageConsumed: "", averageGoal: "",
                               totalConsumed: "", totalGoal: ""),
                chart: .init(title: " - ",
                             points: [],
                             selectedOption: .line),
                calendar: .init(highlightedMonth: engine.dateService.now(),
                                weekdayStart: .monday,
                                range: calendarRange,
                                days: []),
                selectedRange: nil,
                selectedDays: 0,
                error: nil
            )
            Task(priority: .low) {
                guard let start = selectedRange?.lowerBound,
                      let end = selectedRange?.upperBound
                else { return }
                let days = await fetchDays(startDate: calendarRange.lowerBound,
                                           endDate: calendarRange.upperBound)
                updateViewModel(isLoading: true, daysFound: days.mapToViewModel())
                await updateViewModelWithDataBetween(start: start, end: end)
            }
        }
        
        public func perform(action: History.Action) async {
            switch action {
            case .didTapBack:
                router.showHome()
            case .didAppear:
                guard let selectedRange else { return }
                await updateViewModelWithDataBetween(start: selectedRange.lowerBound,
                                                     end: selectedRange.upperBound)
            case .didTapClear:
                selectedRange = nil
                updateViewModel(isLoading: false)
            case .didSelectChart(let chart):
                updateViewModel(isLoading: false, chartOption: chart)
            case let .didTap(date):
                updateViewModel(isLoading: true, highlightedMonth: date)
                let newRange: ClosedRange<Date>
                if let range = selectedRange {
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
                selectedRange = newRange
                await updateViewModelWithDataBetween(start: newRange.lowerBound,
                                                     end: newRange.upperBound)
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
        daysFound: [ViewModel.CalendarData.Day]? = nil,
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
            averageConsumed: getCleanTitle(averageConsumed),
            averageGoal: getCleanTitle(averageGoal),
            totalConsumed: getCleanTitle(totalConsumed),
            totalGoal: getCleanTitle(totalGoal)
        )
        let chart = ViewModel.ChartData(
            title: title,
            points: chartPoints ?? viewModel.chart.points,
            selectedOption: chartOption ?? viewModel.chart.selectedOption
        )
        let calendar = ViewModel.CalendarData(
            highlightedMonth: highlightedMonth ?? viewModel.calendar.highlightedMonth,
            weekdayStart: weekdayStart ?? viewModel.calendar.weekdayStart,
            range: calendarRange ?? viewModel.calendar.range,
            days: daysFound ?? viewModel.calendar.days
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

private extension Screen.History.Presenter {
    func fetchDays(startDate: Date, endDate: Date) async -> [Day] {
        (try? await engine.dayService.getDays(between: startDate ... endDate)) ?? []
    }
        
    func getChartData(from days: [Day]) async -> [ViewModel.ChartData.Point] {
        let formatter = formatter
        let dateService = engine.dateService
        
        return days
            .map { [formatter, dateService] day in
                let dateString = formatter.string(from: day.date)
                if let day = days.first(where: {
                    dateService.isDate($0.date, inSameDayAs: day.date)
                }) {
                    return ViewModel.ChartData.Point(
                        date: day.date, dateString: dateString,
                        consumed: day.consumed, goal: day.goal
                    )
                } else {
                    return ViewModel.ChartData.Point(
                        date: day.date, dateString: dateString,
                        consumed: 0, goal: nil
                    )
                }
            }
    }
    
    func updateViewModelWithDataBetween(start: Date, end: Date) async {
        let days = await fetchDays(startDate: start, endDate: end)
        let points = await getChartData(from: days)
        let daysSelected = engine.dateService.daysBetween(start, end: end) + 1
        
        var totalGoal = 0.0
        var totalConsumed = 0.0
        
        points.forEach { day in
            totalGoal += day.goal ?? 0
            totalConsumed += day.consumed ?? 0
        }
        let averageGoal = totalGoal / Double(daysSelected)
        let averageConsumed = totalConsumed / Double(daysSelected)
        
        updateViewModel(
            isLoading: false,
            averageConsumed: averageConsumed, averageGoal: averageGoal,
            totalConsumed: totalConsumed, totalGoal: totalGoal,
            chartPoints: points,
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
    
    func getCleanTitle(_ input: Double?) -> String {
        let unit = engine.unitService.getUnitSystem()
        let symbol = unit == .metric ? UnitVolume.liters.symbol : UnitVolume.pints.symbol
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.allowsFloats = true
        
        return if let input,
                  let title = formatter.string(from: input as NSNumber) {
            "\(title) \(symbol)"
        } else {
            "0 \(symbol)"
        }
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
