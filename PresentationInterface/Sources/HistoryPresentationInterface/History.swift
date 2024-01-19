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
        case didSelectChart(ViewModel.ChartType)
        case didChangeHighlightedMonthTo(Date)
        case didTap(Date)
    }
    
    public struct ViewModel {
        public let isLoading: Bool
        public let startDate: String
        public let endDate: String
        public let data: [ViewModel.ChartData]
        public let chart: ChartType
        public let chartOption: [ChartType]
        
        public let dateRange: ClosedRange<Date>
        public let highlightedDates: [Date]
        public let weekdayStart: Weekday
        public let highlightedMonth: Date
        
        public let error: HistoryError?
        
        public init(isLoading: Bool, startDate: String, endDate: String, data: [ViewModel.ChartData], chart: ChartType, chartOption: [ChartType], dateRange: ClosedRange<Date>, highlightedDates: [Date], weekdayStart: Weekday, highlightedMonth: Date, error: HistoryError?) {
            self.isLoading = isLoading
            self.startDate = startDate
            self.endDate = endDate
            self.data = data
            self.chart = chart
            self.chartOption = chartOption
            self.dateRange = dateRange
            self.highlightedDates = highlightedDates
            self.weekdayStart = weekdayStart
            self.highlightedMonth = highlightedMonth
            self.error = error
        }
    }
}

extension History.ViewModel {
    public enum ChartType: CaseIterable {
        case bar
        case line
        case plot
    }
}

extension History.ViewModel {
    public struct ChartData {
        public let date: String
        public let consumed: Double?
        public let goal: Double?
        
        public init(date: String, consumed: Double?, goal: Double?) {
            self.date = date
            self.consumed = consumed
            self.goal = goal
        }
    }
}

extension History.ViewModel {
    public enum Weekday {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
}

extension History.ViewModel {
    public enum HistoryError: Error {
        case invalidStartOrEnd
    }
}
