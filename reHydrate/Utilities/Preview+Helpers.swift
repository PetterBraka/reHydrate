//
//  Preview+Helpers.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/10/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import UserNotifications
import EngineKit

extension Engine {
    static let mock: HasService = Engine(
        reminders: [.init(title: "Test", body: "Test")],
        celebrations: [.init(title: "Test", body: "Test")],
        notificationCenter: UNUserNotificationCenter.current()
    )
}
