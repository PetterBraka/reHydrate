//
//  NotificationDelegateType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//

import Foundation
public protocol NotificationDelegateType: AnyObject {
    func userNotificationCenter(
        _ center: NotificationCenterType,
        didReceive response: NotificationResponse
    ) async
    
    func userNotificationCenter(
        _ center: NotificationCenterType,
        willPresent: DeliveredNotification
    ) async
    
    func userNotificationCenter(
        _ center: NotificationCenterType,
        openSettingsFor: DeliveredNotification?
    )
}
