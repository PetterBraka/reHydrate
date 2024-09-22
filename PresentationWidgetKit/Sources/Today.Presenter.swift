//
//  Today.Presenter.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/09/2024.
//

import Foundation
import PresentationWidgetKitInterface

extension Screen.Today {
    public final class Presenter: TodayPresenter {
        private let key = "today-widget"
        private let appGroup: String
        
        public init(appGroup: String) {
            self.appGroup = appGroup
        }
        
        public func getViewModel() -> Today.ViewModel {
            guard let jsonData = UserDefaults(suiteName: appGroup)?.data(forKey: key)
            else {
                return .init(date: .now, endOfDay: .now, consumed: 0, goal: 0, symbol: "No data")
            }
            guard let data = try? JSONDecoder().decode(WidgetData.self, from: jsonData)
            else {
                return Today.ViewModel(
                    date: .now,
                    endOfDay: .now,
                    consumed: 0,
                    goal: 0,
                    symbol: UnitVolume.liters.symbol
                )
            }
            
            
            return Today.ViewModel(
                date: data.date,
                endOfDay: data.endOfDay,
                consumed: data.consumed,
                goal: data.goal,
                symbol: data.symbol
            )
        }
    }
}

private struct WidgetData: Codable {
    let date: Date
    let endOfDay: Date
    let consumed: Double
    let goal: Double
    let symbol: String
}
