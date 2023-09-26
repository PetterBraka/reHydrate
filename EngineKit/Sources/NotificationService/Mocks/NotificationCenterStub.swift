//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 26/09/2023.
//

import Foundation
import UserNotifications
import NotificationServiceInterface

protocol NotificationCenterStubbing {
    var requestAuthorization: Result<Bool, Error> { get }
    var notificationCategories: Set<UNNotificationCategory> { get }
    var pendingRequests: [UNNotificationRequest] { get }
    var addRequest: Result<Void, Error> { get }
    var deliveredNotifications: [UNNotification] { get}
    var pendingNotificationRequests: [UNNotificationRequest] { get }
    var badgeCount: Int { get }
}

final class NotificationCenterStub: NotificationCenterStubbing {
    var requestAuthorization: Result<Bool, Error> = .success(true)
    var notificationCategories: Set<UNNotificationCategory> = .init()
    var pendingRequests: [UNNotificationRequest] = []
    var addRequest: Result<Void, Error> = .success(Void())
    var deliveredNotifications: [UNNotification] = []
    var pendingNotificationRequests: [UNNotificationRequest] = []
    var badgeCount: Int = 0
    
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        switch requestAuthorization {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func setNotificationCategories(_ categories: Set<UNNotificationCategory>) {
        for category in categories {
            notificationCategories.insert(category)
        }
    }
    
    func notificationCategories() async -> Set<UNNotificationCategory> {
        notificationCategories
    }
    
    func add(_ request: UNNotificationRequest) async throws {
        switch addRequest {
        case .success:
            break
        case .failure(let failure):
            throw failure
        }
        pendingRequests.append(request)
    }
    
    func pendingNotificationRequests() async -> [UNNotificationRequest] {
        pendingNotificationRequests
    }
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        for identifier in identifiers {
            pendingRequests.removeAll(where: { $0.identifier == identifier })
        }
    }
    
    func removeAllPendingNotificationRequests() {
        pendingRequests.removeAll()
    }
    
    func deliveredNotifications() async -> [UNNotification] {
        deliveredNotifications
    }
    
    func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
        for identifier in identifiers {
            deliveredNotifications.removeAll(where: { $0.request.identifier == identifier})
        }
    }
    
    func removeAllDeliveredNotifications() {
        deliveredNotifications.removeAll()
    }
    
    func setBadgeCount(_ newBadgeCount: Int) async throws {
        badgeCount = newBadgeCount
    }
}
