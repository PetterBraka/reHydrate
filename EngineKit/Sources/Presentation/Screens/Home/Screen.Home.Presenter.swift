//
//  HomeViewModel.swift
//
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//

import HomePresentationInterface

public extension Screen.Home {
    typealias Engine = (
        AnyObject
    )
    typealias Router = (
        AnyObject
    )
    typealias Tracker = (
        AnyObject
    )
    
    final class HomePresenter: HomePresenterType {
        public func perform(action: Home.Action) {
            switch action {
            case .didTapHistory:
                <#code#>
            case .didTapSettings:
                <#code#>
            case let .didTapAddDrink(drink):
                <#code#>
            case let .didTapEditDrink(drink):
                <#code#>
            case let .didTapRemoveDrink(drink):
                <#code#>
            }
        }
    }
}
