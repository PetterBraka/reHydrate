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
        case didSelectRange(ViewModel.ChartRange)
        case didSelectChart(ViewModel.ChartType)
    }
    
    public struct ViewModel {
        public let isLoading: Bool
        public let days: [ViewModel.Day]
        public let dates: [Date]
        public let chart: ChartType
        public let chartOption: [ChartType]
        public let range: ChartRange
        public let rangeOptions: [ChartRange]
        
        public init(isLoading: Bool, days: [ViewModel.Day], dates: [Date], chart: ChartType, chartOption: [ChartType], range: ChartRange, rangeOptions: [ChartRange]) {
            self.isLoading = isLoading
            self.days = days
            self.dates = dates
            self.chart = chart
            self.chartOption = chartOption
            self.range = range
            self.rangeOptions = rangeOptions
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
    public enum ChartRange: String, Identifiable, CaseIterable {
        public var id: String { rawValue }
        
        case week
        case month
        case quarter
        case year
        
        public var formatter: DateFormatter {
            let formatter = DateFormatter()
            switch self {
            case .week:
                formatter.dateFormat = "EEE"
            case .month:
                formatter.dateFormat = "DD/MM/YY"
            case .quarter, .year:
                formatter.dateFormat = "MM/YY"
            }
            return formatter
        }
    }
}

extension History.ViewModel {
    public struct Day {
        public let date: Date
        public let consumed: Double
        public let goal: Double
        
        public init(date: Date, consumed: Double, goal: Double) {
            self.date = date
            self.consumed = consumed
            self.goal = goal
        }
    }
}
