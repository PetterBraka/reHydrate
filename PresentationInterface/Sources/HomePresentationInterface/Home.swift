//
//  Home.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation

public enum Home {
    public enum Update {
        case setDate(Date)
        case setConsumption(Double)
        case setGoal(Double)
        case setUnit(small: UnitVolume, large: UnitVolume)
    }

    public enum Action {
        case addDrink(ViewModel.Container)
    }

    public struct ViewModel {}
}

public extension Home.ViewModel {
    struct Drink: Identifiable {
        public let id: UUID

        public let container: Container
        public var size: Double

        public var fill: Double {
            size / Double(container.max)
        }

        public init(id: UUID = UUID(),
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
