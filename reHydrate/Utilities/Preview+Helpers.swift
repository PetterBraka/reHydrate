//
//  Preview+Helpers.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/10/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import UserNotifications
import EngineKit
import LoggingService
import PortsInterface

extension Engine {
    typealias EngineType = (
        HasService &
        HasAppInfo &
        HasPorts
    )
    
    static let mock: EngineType = Engine(
        appGroup: "com.mock",
        appVersion: "1.0.0",
        logger: LoggingService(subsystem: "com.mock"),
        dayManager: DayManager(database: DatabaseStub()),
        drinkManager: DrinkManager(database: DatabaseStub()),
        consumptionManager: ConsumptionManager(database: DatabaseStub()),
        reminders: [.init(title: "Test", body: "Test")],
        celebrations: [.init(title: "Test", body: "Test")],
        notificationCenter: UNUserNotificationCenter.current(), 
        openUrlService: OpenUrlPort(),
        alternateIconsService: AlternateIconsServicePort(),
        appearancePort: AppearanceServicePort(),
        healthService: HealthKitPort()
    )
}
