//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 26/09/2023.
//

import Foundation
import NotificationServiceInterface

public protocol NotificationCenterStubbing {
    var requestAuthorization: Result<Bool, Error> { get }
    var notificationCategories: Set<NotificationCategory> { get }
    var pendingRequests: [NotificationRequest] { get }
    var addRequest: Result<Void, Error> { get }
    var deliveredNotifications: [DeliveredNotification] { get}
    var badgeCount: Int { get }
}

public final class NotificationCenterStub: NotificationCenterStubbing {
    public var requestAuthorization: Result<Bool, Error> = .success(true)
    public var notificationCategories: Set<NotificationCategory> = .init()
    public var pendingRequests: [NotificationRequest] = []
    public var addRequest: Result<Void, Error> = .success(Void())
    public var deliveredNotifications: [DeliveredNotification] = []
    public var badgeCount: Int = 0
    
    public init() {}
}
extension NotificationCenterStub: NotificationCenterType {
    public func requestAuthorization() async throws -> Bool {
        switch requestAuthorization {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    public func setNotificationCategories(_ categories: Set<NotificationCategory>) {
        for category in categories {
            notificationCategories.insert(category)
        }
    }
    
    public func notificationCategories() async -> Set<NotificationCategory> {
        notificationCategories
    }
    
    public func add(_ request: NotificationRequest) async throws {
        switch addRequest {
        case .success:
            break
        case .failure(let failure):
            throw failure
        }
        pendingRequests.append(request)
    }
    
    public func pendingNotificationRequests() async -> [NotificationRequest] {
        pendingRequests
    }
    
    public func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        for identifier in identifiers {
            pendingRequests.removeAll(where: { $0.identifier == identifier })
        }
    }
    
    public func removeAllPendingNotificationRequests() {
        pendingRequests.removeAll()
    }
    
    public func deliveredNotifications() async -> [DeliveredNotification] {
        deliveredNotifications
    }
    
    public func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
        for identifier in identifiers {
            deliveredNotifications.removeAll(where: { $0.request.identifier == identifier})
        }
    }
    
    public func removeAllDeliveredNotifications() {
        deliveredNotifications.removeAll()
    }
    
    public func setBadgeCount(_ newBadgeCount: Int) async throws {
        badgeCount = newBadgeCount
    }
}
