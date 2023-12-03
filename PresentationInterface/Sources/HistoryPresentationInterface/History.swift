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
        case didSetStart(Date)
        case didSetEnd(Date)
        case didSelectChart(ViewModel.ChartType)
    }
    
    public struct ViewModel {
        public let isLoading: Bool
        public let startDate: String
        public let endDate: String
        public let data: [ViewModel.ChartData]
        public let chart: ChartType
        public let chartOption: [ChartType]
        public let error: HistoryError?
        
        public init(isLoading: Bool, startDate: String, endDate: String, data: [ChartData], chart: ChartType, chartOption: [ChartType], error: HistoryError?) {
            self.isLoading = isLoading
            self.startDate = startDate
            self.endDate = endDate
            self.data = data
            self.chart = chart
            self.chartOption = chartOption
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
    public enum HistoryError: Error {
        case invalidStartOrEnd
    }
}
