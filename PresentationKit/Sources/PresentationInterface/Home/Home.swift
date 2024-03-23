//
//  Home.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation

public enum Home {
    public enum Update {
        case viewModel
    }

    public enum Action {
        case didAppear
        case didTapHistory
        case didTapSettings
        case didTapAddDrink(ViewModel.Drink)
        case didTapEditDrink(ViewModel.Drink)
        case didTapRemoveDrink(ViewModel.Drink)
    }
    
    public struct ViewModel: Equatable {
        public let dateTitle: String
        public let consumption: Double
        public let goal: Double
        public let smallUnit: UnitVolume
        public let largeUnit: UnitVolume
        public let drinks: [ViewModel.Drink]
        
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

        public var fill: Double {
            size / Double(container.max)
        }

        public init(id: String = UUID().uuidString,
                    size: Double,
                    container: Container) {
            self.id = id
            self.container = container
            self.size = size
        }
    }

    enum Container: Hashable {
        case small
        case medium
        case large

        public var max: Int {
            switch self {
            case .small: return 400
            case .medium: return 700
            case .large: return 1200
            }
        }

        public var min: Int {
            switch self {
            case .small: return 100
            case .medium: return 300
            case .large: return 500
            }
        }
    }
}

extension Home.ViewModel.Drink: Equatable {}
