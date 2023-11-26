//
//  Preview+Helpers.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/10/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import UserNotifications
import EngineKit
import PortsInterface

extension Engine {
    typealias EngineType = (
        HasService &
        HasAppInfo &
        HasPorts
    )
    
    static let mock: EngineType = Engine(
        appVersion: "1.0.0",
        reminders: [.init(title: "Test", body: "Test")],
        celebrations: [.init(title: "Test", body: "Test")],
        notificationCenter: UNUserNotificationCenter.current(), 
        openUrlService: OpenUrlPort(),
        alternateIconsService: AlternateIconsServicePort(),
        appearancePort: AppearanceServicePort(),
        healthService: HealthKitPort()
    )
}
