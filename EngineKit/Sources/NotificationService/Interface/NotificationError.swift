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
}
