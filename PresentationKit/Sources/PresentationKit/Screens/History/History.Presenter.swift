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
            let calendarRange = engine.dateService.getDate(byAddingDays: -(365 * 2), to: .now)! ... .now
            if let past = engine.dateService.getDate(byAddingDays: -6, to: .now) {
                selectedRange =  past ... .now
            }
            self.viewModel = .init(
                isLoading: false,
                details: .init(averageConsumed: "", averageGoal: "",
                               totalConsumed: "", totalGoal: ""),
                chart: .init(title: " - ",
                             data: [],
                             selectedOption: .line),
                calendar: .init(highlightedMonth: .now,
                                weekdayStart: .monday,
                                range: calendarRange),
                selectedRange: nil,
                selectedDays: 0,
                error: nil
            )
            Task(priority: .low) {
                guard let start = selectedRange?.lowerBound,
                      let end = selectedRange?.upperBound
                else { return }
                await getDataBetween(start: start, end: end)
            }
        }
        
        public func perform(action: History.Action) async {
            switch action {
            case .didTapBack:
                router.showHome()
            case .didAppear:
                break
            case .didTapClear:
                selectedRange = nil
                updateViewModel(isLoading: false)
            case .didSelectChart(let chart):
                updateViewModel(isLoading: false, chartOption: chart)
            case let .didChangeHighlightedMonthTo(date):
                updateViewModel(isLoading: false, highlightedMonth: date)
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
                    newRange = date ... engine.dateService.getDate(byAddingDays: 1, to: date)!
                }
                selectedRange = newRange
                await getDataBetween(start: newRange.lowerBound, end: newRange.upperBound)
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
        data: [ViewModel.ChartData.Point]? = nil,
        chartOption: ViewModel.ChartData.Option? = nil,
        calendarRange: ClosedRange<Date>? = nil,
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
        
        let days = if let selectedRange {
            engine.dateService.daysBetween(selectedRange.lowerBound, end: selectedRange.upperBound)
        } else {
            0
        }
        
        viewModel = .init(
            isLoading: isLoading,
            details: .init(
                averageConsumed: getCleanTitle(averageConsumed),
                averageGoal: getCleanTitle(averageGoal),
                totalConsumed: getCleanTitle(totalConsumed),
                totalGoal: getCleanTitle(totalGoal)
            ),
            chart: .init(
                title: title,
                data: data ?? viewModel.chart.data,
                selectedOption: chartOption ?? viewModel.chart.selectedOption
            ),
            calendar: .init(
                highlightedMonth: highlightedMonth ?? viewModel.calendar.highlightedMonth,
                weekdayStart: weekdayStart ?? viewModel.calendar.weekdayStart,
                range: calendarRange ?? viewModel.calendar.range
            ),
            selectedRange: selectedRange,
            selectedDays: days,
            error: error
        )
    }
}

private extension Screen.History.Presenter {
    func fetchDays(startDate: Date, endDate: Date) async -> [ViewModel.ChartData.Point] {
        let dates = getDates(startDate: startDate, endDate: endDate)
        let daysFound = await engine.dayService.getDays(for: dates)
        
        let formatter = formatter
        let dateService = engine.dateService
        
        return dates
            .map { [daysFound, formatter, dateService] date in
                let dateString = formatter.string(from: date)
                let day = daysFound.first(where: { dateService.isDate($0.date, inSameDayAs: date) })
                return if let day {
                    ViewModel.ChartData.Point(
                        date: date, dateString: dateString,
                        consumed: day.consumed, goal: day.goal
                    )
                } else {
                    ViewModel.ChartData.Point(
                        date: date, dateString: dateString,
                        consumed: 0, goal: nil
                    )
                }
            }
    }
    
    func getDataBetween(start: Date, end: Date) async {
        let days = await fetchDays(startDate: start, endDate: end)
        var totalGoal = 0.0
        var totalConsumed = 0.0
        
        days.forEach { day in
            totalGoal += day.goal ?? 0
            totalConsumed += day.consumed ?? 0
        }
        let averageGoal = totalGoal / Double(days.count)
        let averageConsumed = totalConsumed / Double(days.count)
        
        updateViewModel(
            isLoading: false,
            averageConsumed: averageConsumed, averageGoal: averageGoal,
            totalConsumed: totalConsumed, totalGoal: totalGoal,
            data: days
        )
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
