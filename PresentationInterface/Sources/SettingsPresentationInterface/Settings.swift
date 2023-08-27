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
        case didTapDarkModeToggle
        case didSetUnitSystem(ViewModel.UnitSystem)
        case didTapRemindersToggle
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
        public var unitSystem: UnitSystem
        public var goal: Double
        
        public init(unitSystem: UnitSystem, goal: Double) {
            self.unitSystem = unitSystem
            self.goal = goal
        }
    }
}

extension Settings.ViewModel {
    public enum UnitSystem {
        case imperial
        case metric
    }
}
