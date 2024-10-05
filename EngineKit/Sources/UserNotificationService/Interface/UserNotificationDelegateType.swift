//
//  NotificationDelegateType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//

import Foundation
public protocol UserNotificationDelegateType: AnyObject {
    func userNotificationCenter(
        _ center: UserNotificationCenterType,
        didReceive response: NotificationResponse
    ) async
    
    func userNotificationCenter(
        _ center: UserNotificationCenterType,
        willPresent: DeliveredNotification
    ) async
    
    func userNotificationCenter(
        _ center: UserNotificationCenterType,
        openSettingsFor: DeliveredNotification?
    )
}
