//
//  HomeViewModel.swift
//
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//

import HomePresentationInterface

public extension Screen.Home {
    final class HomePresenter: HomePresenterType {
        typealias Engine = (
            AnyObject
        )
        typealias Router = (
            HomeRoutable
        )
        typealias Tracker = (
            AnyObject
        )
        
        private let engine: Engine
        private let router: Router
        private let tracker: Tracker
        
        init(engine: Engine,
             router: Router,
             tracker: Tracker) {
            self.engine = engine
            self.router = router
            self.tracker = tracker
        }
        
        public func perform(action: Home.Action) {
            switch action {
            case .didTapHistory:
                router.showHistory()
            case .didTapSettings:
                router.showSettings()
            case let .didTapAddDrink(drink):
                <#code#>
            case let .didTapEditDrink(drink):
                router.showEdit(drink: drink)
            case let .didTapRemoveDrink(drink):
                <#code#>
            }
        }
    }
}
