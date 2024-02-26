//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//

import NotificationServiceInterface

public protocol NotificationDelegateStubbing {}

public final class NotificationDelegateStub: NotificationDelegateStubbing {
    public init() {}
}

extension NotificationDelegateStub: NotificationDelegateType {
    public func userNotificationCenter(_ center: NotificationCenterType, didReceive response: NotificationResponse) async {}
    
    public func userNotificationCenter(_ center: NotificationCenterType, willPresent: DeliveredNotification) async {}
    
    public func userNotificationCenter(_ center: NotificationCenterType, openSettingsFor: DeliveredNotification?) {}
}
