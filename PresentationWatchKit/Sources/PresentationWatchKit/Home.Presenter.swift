//
//  HomeScreenType.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//

import Foundation
import LoggingService
import PresentationWatchInterface
import DrinkServiceInterface
import UnitServiceInterface
import DayServiceInterface

extension Screen.Home {
    public final class Presenter: HomePresenterType {
        public typealias ViewModel = Home.ViewModel
        public typealias Engine = (
            HasLoggingService &
            HasUnitService &
            HasDayService
        )
        
        private let engine: Engine
        
        public weak var scene: HomeSceneType?
        public private(set) var viewModel: ViewModel {
            didSet { scene?.perform(update: .viewModel) }
        }
        
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE - dd MMM"
            return formatter
        }()
        
        public init(engine: Engine) {
            self.engine = engine
            viewModel = ViewModel(consumption: 0, goal: 0, unit: .liters, drinks: [])
            
            let unit = getUnit()
            updateViewModel(
                unit: unit
            )
        }
        
        public func perform(action: Home.Action) async {
            switch action {
            case .didAppear:
                print("didAppear")
            case .didTapAddDrink(let drink):
                print("didTapAddDrink \(drink.container.rawValue)")
            }
        }
        
        public func sync(didComplete: (() -> Void)?) {
            print("sync")
        }
    }
}

private extension Screen.Home.Presenter {
    func updateViewModel(
        consumption: Double? = nil,
        goal: Double? = nil,
        unit: UnitVolume? = nil,
        drinks: [Home.ViewModel.Drink]? = nil
    ) {
        viewModel = .init(
            consumption: consumption ?? viewModel.consumption,
            goal: goal ?? viewModel.goal,
            unit: unit ?? viewModel.unit,
            drinks: drinks ?? viewModel.drinks
        )
    }
}

// MARK: Units
private extension Screen.Home.Presenter {
    func getUnit() -> UnitVolume {
        let unitSystem = engine.unitService.getUnitSystem()
        return unitSystem == .metric ? .liters : .imperialPints
    }
}

// MARK: Day
private extension Screen.Home.Presenter {
}
