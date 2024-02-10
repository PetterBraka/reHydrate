//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//

import Foundation

public enum Home {
    public enum Update {
        case viewModel
    }
    
    public enum Action {
        case didAppear
        case didTapAddDrink(ViewModel.Drink)
//        case didTapRemoveDrink(ViewModel.Drink) // TODO: Nice to have in the future.
    }
    
    public struct ViewModel {
        public var dateTitle: String
        public var consumption: Double
        public var goal: Double
        public var smallUnit: UnitVolume
        public var largeUnit: UnitVolume
        public var drinks: [ViewModel.Drink]
        
        public init(
            dateTitle: String,
            consumption: Double,
            goal: Double,
            smallUnit: UnitVolume,
            largeUnit: UnitVolume,
            drinks: [ViewModel.Drink]
        ) {
            self.dateTitle = dateTitle
            self.consumption = consumption
            self.goal = goal
            self.smallUnit = smallUnit
            self.largeUnit = largeUnit
            self.drinks = drinks
        }
    }
}

public extension Home.ViewModel {
    struct Drink: Identifiable {
        public let id: String
        
        public let container: Container
        public var size: Double
        
        public init(id: String = UUID().uuidString,
                    size: Double,
                    container: Container) {
            self.id = id
            self.container = container
            self.size = size
        }
    }
    
    enum Container: String, Hashable {
        case small
        case medium
        case large
    }
}

extension Home.ViewModel.Drink: Equatable {}
