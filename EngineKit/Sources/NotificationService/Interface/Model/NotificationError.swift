//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 25/09/2023.
//

import Foundation

public enum NotificationError: Error {
    case unauthorized
    case invalidDate
    case missingDateComponents
    case missingReminders
    case missingCongratulations
    case frequencyTooLow
    case alreadySet(at: DateComponents)
}

extension NotificationError: Equatable {
    public static func == (lhs: NotificationError,
                           rhs: NotificationError) -> Bool {
        return switch (lhs, rhs) {
        case (.alreadySet(let lhsDate), .alreadySet(let rhsDate)):
            lhsDate == rhsDate
        case (.unauthorized, .unauthorized),
            (.invalidDate, .invalidDate),
            (.missingDateComponents, .missingDateComponents),
            (.missingReminders, .missingReminders),
            (.missingCongratulations, .missingCongratulations),
            (.frequencyTooLow, .frequencyTooLow):
            true
        case (.alreadySet, .unauthorized),
            (.alreadySet, .invalidDate),
            (.alreadySet, .missingDateComponents),
            (.alreadySet, .missingReminders),
            (.alreadySet, .missingCongratulations),
            (.alreadySet, .frequencyTooLow),
            (.frequencyTooLow, .unauthorized),
            (.frequencyTooLow, .invalidDate),
            (.frequencyTooLow, .missingDateComponents),
            (.frequencyTooLow, .missingReminders),
            (.frequencyTooLow, .missingCongratulations),
            (.frequencyTooLow, .alreadySet),
            (.missingCongratulations, .unauthorized),
            (.missingCongratulations, .invalidDate),
            (.missingCongratulations, .missingDateComponents),
            (.missingCongratulations, .missingReminders),
            (.missingCongratulations, .frequencyTooLow),
            (.missingCongratulations, .alreadySet),
            (.missingReminders, .unauthorized),
            (.missingReminders, .invalidDate),
            (.missingReminders, .missingDateComponents),
            (.missingReminders, .missingCongratulations),
            (.missingReminders, .frequencyTooLow),
            (.missingReminders, .alreadySet),
            (.missingDateComponents, .unauthorized),
            (.missingDateComponents, .invalidDate),
            (.missingDateComponents, .missingReminders),
            (.missingDateComponents, .missingCongratulations),
            (.missingDateComponents, .frequencyTooLow),
            (.missingDateComponents, .alreadySet),
            (.invalidDate, .unauthorized),
            (.invalidDate, .missingDateComponents),
            (.invalidDate, .missingReminders),
            (.invalidDate, .missingCongratulations),
            (.invalidDate, .frequencyTooLow),
            (.invalidDate, .alreadySet),
            (.unauthorized, .invalidDate),
            (.unauthorized, .missingDateComponents),
            (.unauthorized, .missingReminders),
            (.unauthorized, .missingCongratulations),
            (.unauthorized, .frequencyTooLow),
            (.unauthorized, .alreadySet):
            false
        }
    }
}
