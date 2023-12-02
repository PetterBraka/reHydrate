//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 28/11/2023.
//

import Foundation
import LoggingService
import HistoryPresentationInterface
import UnitServiceInterface

extension Screen.History {
    public final class Presenter: HistoryPresenterType {
        public typealias ViewModel = History.ViewModel
        
        public typealias Engine = (
            HasLoggingService &
            HasUnitService
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
            viewModel = .init(data: [], chart: .bar, chartOption: ViewModel.ChartType.allCases,
                              range: .day, rangeOptions: ViewModel.ChartRange.allCases)
        }
        
        public func perform(action: History.Action) async {
            switch action {
            case .didTapBack:
                router.showHome()
            case .didSelectRange(let range):
                updateViewModel(range: range)
            case .didSelectChart(let chart):
                updateViewModel(chart: chart)
            }
        }
    }
}

private extension Screen.History.Presenter {
    func updateViewModel(data: [History.ViewModel.ChartData]? = nil,
                         chart: History.ViewModel.ChartType? = nil,
                         chartOption: [History.ViewModel.ChartType]? = nil,
                         range: History.ViewModel.ChartRange? = nil,
                         rangeOptions: [History.ViewModel.ChartRange]? = nil) {
        viewModel = .init(
            data: data ?? viewModel.data,
            chart: chart ?? viewModel.chart,
            chartOption: chartOption ?? viewModel.chartOption,
            range: range ?? viewModel.range,
            rangeOptions: rangeOptions ?? viewModel.rangeOptions
        )
    }
}
