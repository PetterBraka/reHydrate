//
//  File.swift
//
//
//  Created by Petter vang Brakalsvålet on 21/09/2023.
//

import Foundation
import UserNotifications
import NotificationServiceInterface
import UserPreferenceServiceInterface
import LoggingService

public final class NotificationService: NotificationServiceType {
    typealias Engine = (
        HasLoggingService &
        HasUserPreferenceService
    )
    
    private let notificationCenter: NotificationCenterType
    private let notificationOptions: UNAuthorizationOptions
    
    private let engine: Engine
    private let preferenceKeyIsOn = "notification-is-enabled"
    private let preferenceKeyFrequency = "notification-frequency"
    private let preferenceKeyStart = "notification-start"
    private let preferenceKeyStop = "notification-stop"
    
    public private(set) var isAuthorized: Bool = false
    public private(set) var isOn: Bool = false
    
    init(engine: Engine,
         notificationCenter: NotificationCenterType,
         reminders: [NotificationMessage],
         celebrations: [NotificationMessage]) {
        self.engine = engine
        self.notificationCenter = notificationCenter
        self.reminders = reminders
        self.celebrations = celebrations
        checkUserPreference()
    }
    
    public func enable(
        withFrequency frequency: Int,
        start: Date,
        stop: Date
    ) async -> Result<Void, NotificationError> {
        storePreferences(enabled: true, frequency: frequency, start: start, stop: stop)
        
        do {
            try await checkAuthorizationStatus()
        } catch {
            return .failure(.unauthorized)
        }
    }
    
    public func disable() {
        notificationCenter.removeAllPendingNotificationRequests()
        storePreferences(enabled: false)
    }
}


private extension NotificationService {
    func checkUserPreference() {
        let enabled: Bool? = engine.userPreferenceService.get(for: preferenceKeyIsOn)
        let frequency: Int? = engine.userPreferenceService.get(for: preferenceKeyFrequency)
        let start: Date? = engine.userPreferenceService.get(for: preferenceKeyStart)
        let stop: Date? = engine.userPreferenceService.get(for: preferenceKeyStop)
        
        Task { [weak self] in
            if let enabled, enabled == true, let frequency, let start, let stop {
                _ = await self?.enable(withFrequency: frequency, start: start, stop: stop)
            } else {
                self?.disable()
            }
        }
    }
    
    func checkAuthorizationStatus() async throws {
        guard !isAuthorized else { return }
        do {
            let granted = try await notificationCenter.requestAuthorization(options: notificationOptions)
            isAuthorized = granted
            
            if granted == false {
                throw NotificationError.unauthorized
            }
        } catch {
            throw NotificationError.unauthorized
        }
    }
    
    func storePreferences(enabled: Bool) {
        do {
            try engine.userPreferenceService.set(enabled, for: preferenceKeyIsOn)
        } catch {
            engine.logger.error("couldn't store notification settings", error: error)
        }
    }
    
    func storePreferences(enabled: Bool,
                          frequency: Int?,
                          start: Date?,
                          stop: Date?) {
        storePreferences(enabled: enabled)
        do {
            try engine.userPreferenceService.set(frequency, for: preferenceKeyFrequency)
            try engine.userPreferenceService.set(start, for: preferenceKeyStart)
            try engine.userPreferenceService.set(stop, for: preferenceKeyStop)
        } catch {
            engine.logger.error("couldn't store notification settings", error: error)
        }
    }
}

