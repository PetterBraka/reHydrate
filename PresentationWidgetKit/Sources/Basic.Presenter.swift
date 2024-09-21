//
//  Basic.Presenter.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/09/2024.
//

import Foundation
import LoggingService
import DayServiceInterface
import DateServiceInterface
import UnitServiceInterface
import PresentationWidgetKitInterface
import UserPreferenceServiceInterface

extension Screen.Basic {
    public final class Presenter: BasicPresenter {
        public typealias Engine = (
            HasLoggingService &
            HasUnitService &
            HasDayService &
            HasDateService
        )
        
        private let engine: Engine
        
        public init(engine: Engine) {
            self.engine = engine
        }
        
        public func getViewModel() async -> Basic.ViewModel {
            let (unit, symbol) = getUnitSystem()
            let day = await engine.dayService.getToday()
            let consumed = engine.unitService.convert(day.consumed, from: .litres, to: unit)
            let goal = engine.unitService.convert(day.goal, from: .litres, to: unit)
            
            return Basic.ViewModel(
                date: day.date,
                consumed: consumed,
                goal: goal,
                symbol: symbol
            )
        }
        
        public func getEndOfDayViewModel() async -> Basic.ViewModel {
            let (unit, symbol) = getUnitSystem()
            let endOfDay = engine.dateService.getEnd(of: engine.dateService.now())
            
            let day = await engine.dayService.getToday()
            let goal = engine.unitService.convert(day.goal, from: .litres, to: unit)
            
            return Basic.ViewModel(
                date: endOfDay,
                consumed: 0,
                goal: goal,
                symbol: symbol
            )
        }
        
        private func getUnitSystem() -> (unit: UnitModel, symbol: String) {
            let unitSystem = engine.unitService.getUnitSystem()
            let unit = unitSystem == .metric ? UnitModel.litres : UnitModel.pint
            let symbol = unitSystem == .metric ? UnitVolume.liters.symbol : UnitVolume.imperialPints.symbol
            
            return (unit, symbol)
        }
    }
}
