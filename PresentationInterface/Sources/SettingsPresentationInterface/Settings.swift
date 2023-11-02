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
        case didSetRemindersStart(Date)
        case didSetRemindersStop(Date)
        case didTapIncrementFrequency
        case didTapDecrementFrequency
        case didTapCredits
        case didTapContactMe
        case didTapPrivacy
        case didTapDeveloperInstagram
        case didTapMerchandise
        
        case didOpenSettings
        case dismissAlert
    }
    
    public struct ViewModel {
        public let isLoading: Bool
        public let unitSystem: UnitSystem
        public let goal: Double
        public let drinks: [ViewModel.Drink]
        public let notifications: NotificationSettings
        public let error: Error?
        public let appVersion: String
        
        public init(
            isLoading: Bool,
            unitSystem: UnitSystem,
            goal: Double,
            drinks: [ViewModel.Drink],
            notifications: NotificationSettings,
            appVersion: String,
            error: Error?
        ) {
            self.isLoading = isLoading
            self.unitSystem = unitSystem
            self.goal = goal
            self.drinks = drinks
            self.notifications = notifications
            self.appVersion = appVersion
            self.error = error
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
    
extension Settings.ViewModel {
    public struct NotificationSettings {
        public let isOn: Bool
        public let frequency: Int
        public let start: Date
        public let startRange: ClosedRange<Date>
        public let stop: Date
        public let stopRange: ClosedRange<Date>
        
        public init(isOn: Bool,
                    frequency: Int,
                    start: Date,
                    startRange: ClosedRange<Date>,
                    stop: Date,
                    stopRange: ClosedRange<Date>) {
            self.isOn = isOn
            self.frequency = frequency
            self.start = start
            self.startRange = startRange
            self.stop = stop
            self.stopRange = stopRange
        }
    }
}

extension Settings.ViewModel {
    public enum Error {
        // Generic
        case somethingWentWrong
        // Notification errors
        case unauthorized
        case invalidStart
        case invalidStop
        case invalidDates
        case lowFrequency
        case missingReminders
        // Open URL erros
        case cantOpenUrl
    }
}
