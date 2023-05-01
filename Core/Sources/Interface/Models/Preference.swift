//
//  Preference.swift
//
//
//  Created by Petter vang Brakalsvålet on 30/04/2023.
//

import Foundation

public enum Preference {
    case appleLanguages
    case currentLanguage
    case metricUnits
    case reminders
    case startignTime
    case endingTime
    case reminderInterval
    case smallDrinkOption
    case mediumDrinkOption
    case largeDrinkOption
    case darkMode
    case hasReachedGoal
    case reachedGoalOnDate

    public var `default`: Any? {
        switch self {
        case .appleLanguages:
            return "en"
        case .currentLanguage:
            return "en"
        case .metricUnits:
            return true
        case .reminders:
            return false
        case .startignTime:
            return DateComponents(calendar: .current, hour: 8, minute: 0).date ?? Date()
        case .endingTime:
            return DateComponents(calendar: .current, hour: 23, minute: 0).date ?? Date()
        case .reminderInterval:
            return 30
        case .smallDrinkOption:
            return 300
        case .mediumDrinkOption:
            return 500
        case .largeDrinkOption:
            return 750
        case .darkMode:
            return false
        case .hasReachedGoal:
            return false
        case .reachedGoalOnDate:
            return nil
        }
    }

    public var key: String {
        switch self {
        case .appleLanguages:
            return "AppleLanguages"
        case .currentLanguage:
            return "CurrentLanguage"
        case .metricUnits:
            return "metricUnits"
        case .reminders:
            return "reminders"
        case .startignTime:
            return "startignTime"
        case .endingTime:
            return "endingTime"
        case .reminderInterval:
            return "reminderInterval"
        case .smallDrinkOption:
            return "smallDrinkOption"
        case .mediumDrinkOption:
            return "mediumDrinkOption"
        case .largeDrinkOption:
            return "largeDrinkOption"
        case .darkMode:
            return "darkMode"
        case .hasReachedGoal:
            return "hasReachedGoal"
        case .reachedGoalOnDate:
            return "reachedGoalOnDate"
        }
    }
}
