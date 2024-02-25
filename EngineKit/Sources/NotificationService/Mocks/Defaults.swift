//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 25/02/2024.
//

import Foundation
import NotificationServiceInterface

extension Int {
    static let `default` = 0
}

extension NotificationSettings {
    static let `default` = NotificationSettings(isOn: false, start: nil, stop: nil, frequency: nil)
}

extension Result where Success == Bool, Failure == Error {
    static let `default` = Result<Bool, Error>.success(false)
}

extension Result where Success == Void, Failure == NotificationError {
    static let `default` = Result<Success, Failure>.success(Void())
}

extension Set where Element == NotificationCategory {
    static let `default` = Set<NotificationCategory>()
}

extension Array where Element == NotificationRequest {
    static let `default` = [NotificationRequest]()
}
extension Array where Element == DeliveredNotification {
    static let `default` = [DeliveredNotification]()
}
