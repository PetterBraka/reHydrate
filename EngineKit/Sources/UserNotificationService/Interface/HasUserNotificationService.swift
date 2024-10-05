//
//  HasUserNotificationService.swift
//
//
//  Created by Petter vang Brakalsvålet on 28/09/2023.
//

public protocol HasUserNotificationService {
    var userNotificationService: UserNotificationServiceType { get set }
    var notificationDelegate: UserNotificationDelegateType { get set }
}
