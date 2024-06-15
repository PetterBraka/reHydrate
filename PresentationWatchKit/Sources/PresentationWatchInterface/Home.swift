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
        case didTapAddDrink(ViewModel.Container)
//        case didTapRemoveDrink(ViewModel.Drink) // TODO: Nice to have in the future.
    }
    
    public struct ViewModel {
        public let consumption: Double
        public let goal: Double
        public let unit: UnitVolume
        public let drinks: [ViewModel.Drink]
        
        public init(
            consumption: Double,
            goal: Double,
            unit: UnitVolume,
            drinks: [ViewModel.Drink]
        ) {
            self.consumption = consumption
            self.goal = goal
            self.unit = unit
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

extension Home.ViewModel: Equatable {}
extension Home.ViewModel.Drink: Equatable {}
