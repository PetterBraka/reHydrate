//
//  UserNotificationService.swift
//
//
//  Created by Petter vang Brakalsvålet on 21/09/2023.
//

import Foundation
import LoggingService
import UserPreferenceServiceInterface
import DrinkServiceInterface
import UserNotificationServiceInterface
import DateServiceInterface

public final class UserNotificationService: UserNotificationServiceType {
    public typealias Engine = (
        HasLoggingService &
        HasUserPreferenceService &
        HasDrinksService &
        HasDateService
    )
    
    public private(set) var userNotificationCenter: UserNotificationCenterType
    
    private let reminders: [NotificationMessage]
    private let reminderCategory = "com.rehydrate.reminder"
    private let celebrations: [NotificationMessage]
    private let celebrationCategory = "com.rehydrate.celebration"
    
    private let engine: Engine
    
    public let minimumAllowedFrequency = 10
    private let calendarComponents: Set<Calendar.Component> = [.hour, .minute]
    
    public private(set) var isAuthorized: Bool = false
    public private(set) var isOn: Bool = false
    
    public init(engine: Engine,
                reminders: [NotificationMessage],
                celebrations: [NotificationMessage],
                userNotificationCenter: UserNotificationCenterType,
                didComplete: (() -> Void)?) {
        self.engine = engine
        self.reminders = reminders
        self.celebrations = celebrations
        self.userNotificationCenter = userNotificationCenter
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
        
        if await userNotificationCenter.pendingNotificationRequests().isEmpty == false {
            userNotificationCenter.removeAllPendingNotificationRequests()
        }
        
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
        userNotificationCenter.removeAllPendingNotificationRequests()
        storePreferences(enabled: false)
    }
    
    public func celebrate() async {
        let enabled: Bool = engine.userPreferenceService.get(for: .isOn) ?? false
        guard enabled else { return }
        
        let today = engine.dateService.now()
        
        if let lastCelebrationsDate: Date = engine.userPreferenceService.get(for: .lastCelebrationsDate),
           engine.dateService.isDate(lastCelebrationsDate, inSameDayAs: today) {
               return
        }
        userNotificationCenter.removeAllPendingNotificationRequests()
        
        do {
            guard let message = celebrations.randomElement() ?? celebrations.first
            else { throw NotificationError.missingCongratulations }
            
            let content = NotificationContent(
                title: message.title,
                subtitle: "",
                body: message.body,
                categoryIdentifier: reminderCategory,
                userInfo: [:]
            )
            
            let calendar = Calendar.current
            guard let date = calendar.date(byAdding: .minute, value: 1, to: today)
            else { throw NotificationError.invalidDate }
            let triggerComponents = calendar.dateComponents(calendarComponents, from: date)
            let trigger = NotificationTrigger(repeats: false, dateComponents: triggerComponents)
            
            try await userNotificationCenter.add(
                .init(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
            )
            try? engine.userPreferenceService.set(today, for: .lastCelebrationsDate)
        } catch {
            engine.logger.error("Failed to add celebration notification", error: error)
        }
    }
    
    public func getSettings() -> NotificationSettings {
        let enabled: Bool? = engine.userPreferenceService.get(for: .isOn)
        let frequency: Int? = engine.userPreferenceService.get(for: .frequency)
        let start: Date? = engine.userPreferenceService.get(for: .start)
        let stop: Date? = engine.userPreferenceService.get(for: .stop)
        
        return NotificationSettings(
            isOn: enabled ?? false,
            start: start,
            stop: stop,
            frequency: frequency
        )
    }
}

private extension UserNotificationService {
    func checkAuthorizationStatus() async throws {
        guard !isAuthorized 
        else { return }
        do {
            let granted = try await userNotificationCenter.requestAuthorization()
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
            try engine.userPreferenceService.set(enabled, for: .isOn)
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
            try engine.userPreferenceService.set(frequency, for: .frequency)
            try engine.userPreferenceService.set(start, for: .start)
            try engine.userPreferenceService.set(stop, for: .stop)
        } catch {
            engine.logger.error("couldn't store notification settings", error: error)
        }
    }
}

private extension UserNotificationService {
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
        let pendingRequests = await userNotificationCenter.pendingNotificationRequests()
        
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
        
        try await userNotificationCenter.add(.init(identifier: id,
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
            
            userNotificationCenter.setNotificationCategories([remindersCategory])
        } catch {
            engine.logger.error("Couldn't set notification categories", error: error)
        }
    }
}
