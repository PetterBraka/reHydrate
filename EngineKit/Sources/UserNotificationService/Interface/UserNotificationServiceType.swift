//
//  UserNotificationServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 21/09/2023.
//

import Foundation

public protocol UserNotificationServiceType {
    var minimumAllowedFrequency: Int { get }
    
    func enable(withFrequency: Int, start: Date, stop: Date) async -> Result<Void, NotificationError>
    func disable()
    func getSettings() -> NotificationSettings
}
