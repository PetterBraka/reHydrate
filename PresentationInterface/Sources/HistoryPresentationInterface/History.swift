//
//  History.swift
//  
//
//  Created by Petter vang Brakalsvålet on 28/11/2023.
//

import Foundation

public enum History {
    public enum Update {
        case viewModel
    }
    
    public enum Action {
        case didTapBack
        case didAppear
        case didSelectChart(ViewModel.ChartData.Option)
        case didChangeHighlightedMonthTo(Date)
        case didTapClear
        case didTap(Date)
    }
    
    public struct ViewModel {
        public let isLoading: Bool
        public let details: Details
        public let chart: ChartData
        public let calendar: CalendarData
        
        public let error: HistoryError?
        
        public init(isLoading: Bool, details: Details, chart: ChartData, calendar: CalendarData, error: HistoryError?) {
            self.isLoading = isLoading
            self.details = details
            self.chart = chart
            self.calendar = calendar
            self.error = error
        }
    }
}

extension History.ViewModel {
    public struct ChartData {
        public enum Option: CaseIterable {
            case bar
            case line
            case plot
        }
        
        public struct Point {
            public let date: Date
            public let dateString: String
            public let consumed: Double?
            public let goal: Double?
            
            public init(date: Date, dateString: String, consumed: Double?, goal: Double?) {
                self.date = date
                self.dateString = dateString
                self.consumed = consumed
                self.goal = goal
            }
        }
        
        public let title: String
        public let data: [Point]
        public let range: ClosedRange<Date>?
        public let selectedOption: Option
        public let options = Option.allCases
        
        public init(title: String, data: [Point], range: ClosedRange<Date>?, selectedOption: Option) {
            self.title = title
            self.data = data
            self.range = range
            self.selectedOption = selectedOption
        }
    }
}

extension History.ViewModel {
    public struct CalendarData {
        public enum Weekday {
            case monday
            case tuesday
            case wednesday
            case thursday
            case friday
            case saturday
            case sunday
        }
        
        public let highlightedMonth: Date
        public let weekdayStart: Weekday
        public let range: ClosedRange<Date>
        public let selectedRange: ClosedRange<Date>?
        public let highlightedDates: [Date]
        
        public init(highlightedMonth: Date, weekdayStart: Weekday, range: ClosedRange<Date>, selectedRange: ClosedRange<Date>?, highlightedDates: [Date]) {
            self.highlightedMonth = highlightedMonth
            self.weekdayStart = weekdayStart
            self.range = range
            self.selectedRange = selectedRange
            self.highlightedDates = highlightedDates
        }
    }
}

extension History.ViewModel {
    public struct Details {
        public let averageConsumed: String
        public let averageGoal: String
        public let totalConsumed: String
        public let totalGoal: String
        
        public init(averageConsumed: String, averageGoal: String, totalConsumed: String, totalGoal: String) {
            self.averageConsumed = averageConsumed
            self.averageGoal = averageGoal
            self.totalConsumed = totalConsumed
            self.totalGoal = totalGoal
        }
    }
}

extension History.ViewModel {
    public enum HistoryError: Error {
        case invalidStartOrEnd
    }
}
