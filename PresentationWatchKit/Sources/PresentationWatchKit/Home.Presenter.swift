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

extension Screen.Home {
    public final class Presenter: HomePresenterType {
        public typealias ViewModel = Home.ViewModel
        public typealias Engine = (
            HasLoggingService &
            HasUnitService
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
            viewModel = ViewModel(dateTitle: formatter.string(from: Date()),
                                  consumption: 0,
                                  goal: 0,
                                  smallUnit: .milliliters,
                                  largeUnit: .liters,
                                  drinks: [])
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
