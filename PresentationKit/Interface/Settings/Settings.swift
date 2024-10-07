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
        case didAppear
        
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
    
    public struct ViewModel: Equatable {
        public let isLoading: Bool
        public let isDarkModeOn: Bool
        public let unitSystem: UnitSystem
        public let goal: Double
        public let notifications: NotificationSettings?
        public let error: Error?
        public let appVersion: String
        
        public init(
            isLoading: Bool,
            isDarkModeOn: Bool,
            unitSystem: UnitSystem,
            goal: Double,
            notifications: NotificationSettings?,
            appVersion: String,
            error: Error?
        ) {
            self.isLoading = isLoading
            self.isDarkModeOn = isDarkModeOn
            self.unitSystem = unitSystem
            self.goal = goal
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
    public struct NotificationSettings: Equatable {
        public let frequency: Int
        public let start: Date
        public let stop: Date
        
        public init(frequency: Int,
                    start: Date,
                    stop: Date) {
            self.frequency = frequency
            self.start = start
            self.stop = stop
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
