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
        case didSelectRange(ViewModel.ChartRange)
        case didSelectChart(ViewModel.ChartType)
    }
    
    public struct ViewModel {
        public let data: [ChartData]
        public let chart: ChartType
        public let chartOption: [ChartType]
        public let range: ChartRange
        public let rangeOptions: [ChartRange]
        
        public init(data: [ChartData], chart: ChartType, chartOption: [ChartType], range: ChartRange, rangeOptions: [ChartRange]) {
            self.data = data
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
        
        case day
        case month
        case quarter
        case year
        case all
        
        public var formatter: DateFormatter {
            let formatter = DateFormatter()
            switch self {
            case .day:
                formatter.dateFormat = "EEE"
            case .month, .quarter, .year:
                formatter.dateFormat = "MMM"
            case .all:
                formatter.dateFormat = "MM/YY"
            }
            return formatter
        }
    }
}

extension History.ViewModel {
    public struct ChartData {
        public let date: Date
        public let value: Double
        
        public init(date: Date, value: Double) {
            self.date = date
            self.value = value
        }
    }
}
