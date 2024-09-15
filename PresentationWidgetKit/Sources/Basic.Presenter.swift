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
        
        public func getViewModel() -> Basic.ViewModel {
            let (unit, symbol) = getUnitSystem()
            guard let day = engine.dayService.getSharedToday()
            else {
                engine.logger.info("No shared day found")
                return .init(date: .now, consumed: 0, goal: 2, symbol: symbol)
            }
            let consumed = engine.unitService.convert(day.consumed, from: .litres, to: unit)
            let goal = engine.unitService.convert(day.goal, from: .litres, to: unit)
            
            return Basic.ViewModel(
                date: day.date,
                consumed: consumed,
                goal: goal,
                symbol: symbol
            )
        }
        
        public func getEndOfDayViewModel() -> Basic.ViewModel {
            let (unit, symbol) = getUnitSystem()
            let endOfDay = engine.dateService.getEnd(of: engine.dateService.now())
            
            guard let day = engine.dayService.getSharedToday()
            else {
                engine.logger.info("No shared day found")
                return .init(date: .now, consumed: 0, goal: 2, symbol: symbol)
            }
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
