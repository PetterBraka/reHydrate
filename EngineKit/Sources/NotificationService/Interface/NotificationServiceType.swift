//
//  NotificationServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 21/09/2023.
//

import Foundation
import UserNotifications

public protocol NotificationServiceType {
    var isOn: Bool { get }
    func enable(
        withFrequency: Int,
        startTime: String,
        stopTime: String
    ) async -> Result<Void, NotificationError>
    
    func disable()
}
