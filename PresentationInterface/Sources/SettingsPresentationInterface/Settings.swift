//
//  Settings.swift
//  
//
//  Created by Petter vang Brakalsvålet on 17/06/2023.
//

import Foundation

public enum Settings {
    public enum Update {
        case viewModel
    }
    
    public enum Action {
        case didTapBack
        case didSetDarkMode(Bool)
        case didSetUnitSystem(ViewModel.UnitSystem)
        case didSetReminders(Bool)
        case didTapEditAppIcon
        
        case didTapIncrementGoal
        case didTapDecrementGoal
        case didTapIncrementFrequency
        case didTapDecrementFrequency
        case didTapCredits
        case didTapContactMe
        case didTapPrivacy
        case didTapDeveloperInstagram
    }
    
    public struct ViewModel {
        public let unitSystem: UnitSystem
        public let goal: Double
        public let drinks: [ViewModel.Drink]
        
        public init(unitSystem: UnitSystem, goal: Double, drinks: [ViewModel.Drink]) {
            self.unitSystem = unitSystem
            self.goal = goal
            self.drinks = drinks
        }
    }
}

extension Settings.ViewModel {
    public enum UnitSystem {
        case imperial
        case metric
    }
}

extension Settings.ViewModel {
    public struct Drink: Identifiable {
        public let id: UUID
        
        public let container: Container
        public var size: Double
        
        public init(id: UUID = UUID(),
                    size: Double,
                    container: Container) {
            self.id = id
            self.container = container
            self.size = size
        }
    }
    
    public enum Container: Hashable {
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
