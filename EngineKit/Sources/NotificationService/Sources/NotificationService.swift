//
//  NotificationService.swift
//
//
//  Created by Petter vang Brakalsvålet on 21/09/2023.
//

import Foundation
import LoggingService
import UserPreferenceServiceInterface
import DrinkServiceInterface
import NotificationServiceInterface
import DateServiceInterface

public final class NotificationService: NotificationServiceType {
    public typealias Engine = (
        HasLoggingService &
        HasUserPreferenceService &
        HasDrinksService &
        HasDateService
    )
    
    public private(set) var notificationCenter: NotificationCenterType
    
    private let reminders: [NotificationMessage]
    private let reminderCategory = "com.rehydrate.reminder"
    private let celebrations: [NotificationMessage]
    private let celebrationCategory = "com.rehydrate.celebration"
    
    private let engine: Engine
    private let preferenceKeyIsOn = "notification-is-enabled"
    private let preferenceKeyFrequency = "notification-frequency"
    private let preferenceKeyStart = "notification-start"
    private let preferenceKeyStop = "notification-stop"
    
    public let minimumAllowedFrequency = 10
    private let calendarComponents: Set<Calendar.Component> = [.hour, .minute]
    
    public private(set) var isAuthorized: Bool = false
    public private(set) var isOn: Bool = false
    
    public init(engine: Engine,
                reminders: [NotificationMessage],
                celebrations: [NotificationMessage],
                notificationCenter: NotificationCenterType,
                didComplete: (() -> Void)?) {
        self.engine = engine
        self.reminders = reminders
        self.celebrations = celebrations
        self.notificationCenter = notificationCenter
        checkUserPreference(complete: didComplete)
    }
    
    func checkUserPreference(complete: (() -> Void)?) {
        let settings = getSettings()
        
        Task { [weak self] in
            if settings.isOn == true,
               let frequency = settings.frequency,
               let start = settings.start,
               let stop = settings.stop {
                _ = await self?.enable(withFrequency: frequency, start: start, stop: stop)
            } else {
                self?.disable()
            }
            complete?()
        }
    }
    
    public func enable(
        withFrequency frequency: Int,
        start: Date,
        stop: Date
    ) async -> Result<Void, NotificationError> {
        guard frequency >= minimumAllowedFrequency
        else { return .failure(.frequencyTooLow) }
        
        storePreferences(enabled: true, frequency: frequency, start: start, stop: stop)
        
        do {
            try await checkAuthorizationStatus()
        } catch {
            return .failure(.unauthorized)
        }
        
        await addNotifications(startDate: start, stopDate: stop, frequency: frequency)
        return .success(Void())
    }
    
    public func disable() {
        notificationCenter.removeAllPendingNotificationRequests()
        storePreferences(enabled: false)
    }
    
    public func getSettings() -> NotificationSettings {
        let enabled: Bool? = engine.userPreferenceService.get(for: preferenceKeyIsOn)
        let frequency: Int? = engine.userPreferenceService.get(for: preferenceKeyFrequency)
        let start: Date? = engine.userPreferenceService.get(for: preferenceKeyStart)
        let stop: Date? = engine.userPreferenceService.get(for: preferenceKeyStop)
        
        return NotificationSettings(
            isOn: enabled ?? false,
            start: start,
            stop: stop,
            frequency: frequency
        )
    }
}

private extension NotificationService {
    func checkAuthorizationStatus() async throws {
        guard !isAuthorized 
        else { return }
        do {
            let granted = try await notificationCenter.requestAuthorization()
            isAuthorized = granted
            
            if granted == false {
                throw NotificationError.unauthorized
            }
            
            await setNotificationActions()
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

private extension NotificationService {
    func getNextDate(from startDate: Date, using frequency: Int, stopDate: Date) -> Date? {
        let calendar = Calendar.current
        
        let stopHour = calendar.component(.hour, from: stopDate)
        let stopMinute = calendar.component(.minute, from: stopDate)
        
        guard let date = calendar.date(byAdding: .minute,
                                       value: frequency,
                                       to: startDate)
        else { return nil }
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let startDay = calendar.component(.day, from: startDate)
        let day = calendar.component(.day, from: date)
        
        let startMonth = calendar.component(.month, from: startDate)
        let month = calendar.component(.month, from: date)
        
        let startYear = calendar.component(.year, from: startDate)
        let year = calendar.component(.year, from: date)
        
        if hour > stopHour {
            return nil
        }
        if hour == stopHour, minute > stopMinute {
            return nil
        } else {
            if startYear != year ||
                startMonth != month ||
                startDay != day {
                return nil
            } else {
                return date
            }
        }
    }
    
    func addNotifications(startDate: Date, stopDate: Date, frequency: Int) async {
        var date = startDate
        var shouldContinue = true
        let pendingRequests = await notificationCenter.pendingNotificationRequests()
        
        while shouldContinue {
            let triggerComponents = Calendar.current
                .dateComponents(calendarComponents, from: date)
            
            do {
                guard !pendingRequests.containsRequest(
                    at: triggerComponents,
                    withAccuracy: minimumAllowedFrequency,
                    using: calendarComponents
                )
                else { throw NotificationError.alreadySet(at: triggerComponents) }
                
                try await addNotification(for: triggerComponents)
            } catch {
                if let notificationError = error as? NotificationError,
                   notificationError == .alreadySet(at: triggerComponents) {} else {
                    engine.logger.error("Couldn't set notifications", error: error)
                }
            }
            guard let triggerDate = getNextDate(from: date,
                                                using: frequency,
                                                stopDate: stopDate)
            else {
                shouldContinue = false
                continue
            }
            date = triggerDate
        }
    }
    
    func addNotification(for dateComponents: DateComponents) async throws {
        let id = UUID().uuidString
        
        guard let message = reminders.randomElement() ?? reminders.first
        else { throw NotificationError.missingReminders }
        
        let content = NotificationContent(
            title: message.title,
            subtitle: "",
            body: message.body,
            categoryIdentifier: reminderCategory,
            userInfo: [:]
        )
        
        let trigger = NotificationTrigger(
            repeats: true,
            dateComponents: dateComponents
        )
        
        try await notificationCenter.add(.init(identifier: id,
                                               content: content,
                                               trigger: trigger))
    }
    
    func setNotificationActions() async {
        do {
            let drinks = try await engine.drinksService.getSaved()
            let remindersActions = drinks.map {
                NotificationAction(
                    identifier: $0.container.rawValue,
                    title: "\($0.container.rawValue) (\($0.size.formatted(.number)))"
                )
            }
            let remindersCategory = NotificationCategory(
                identifier: reminderCategory,
                actions: remindersActions,
                intentIdentifiers: remindersActions.map(\.identifier)
            )
            
            notificationCenter.setNotificationCategories([remindersCategory])
        } catch {
            engine.logger.error("Couldn't set notification categories", error: error)
        }
    }
}
