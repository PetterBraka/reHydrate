//
//  NotificationManager.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 04/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import SwiftUI
import UserNotifications

// MARK: - Notifications

class NotificationManager {
    struct Reminder {
        var title = String()
        var body = String()
    }

    private let settingsRepository: SettingsRepository = .shared
    var language: Language { settingsRepository.language }
    var isMetric: Bool { settingsRepository.isMetric }
    var isRemindersOn: Bool { settingsRepository.isRemindersOn }
    var remindersStart: Date { settingsRepository.remindersStart }
    var remindersEnd: Date { settingsRepository.remindersEnd }
    var reminderFrequency: Int { settingsRepository.reminderFrequency }
    var smallDrink: Double { settingsRepository.smallDrink }
    var mediumDrink: Double { settingsRepository.mediumDrink }
    var largeDrink: Double { settingsRepository.largeDrink }
    var hasReachedGoal: Bool { settingsRepository.hasReachedGoal }

    static let shared = NotificationManager()

    let center = UNUserNotificationCenter.current()

    private var hasSetNotifications = false
    private var hasSetCongratsNotifications = false

    func requestAccess() async throws {
        try await center.requestAuthorization(options: [.alert, .sound])
    }

    func deleteReminders() {
        print("Deleting reminders")
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        hasSetNotifications = false
        hasSetCongratsNotifications = false
    }

    @MainActor
    func requestReminders(for day: Day) {
        Task {
            settingsRepository.hasReachedGoal = day.consumption >= day.goal
            guard isRemindersOn else { return }
            guard !hasReachedGoal else {
                deleteReminders()
                createCongratulation()
                return
            }
            center.getPendingNotificationRequests { pending in
                if pending.isEmpty {
                    self.setReminders()
                }
            }
        }
    }

    /**
     Will set a notification for every half hour between 7 am and 11pm.

     # Example #
     ```
     setReminders()
     ```
     */
    private func setReminders(forTomorrow _: Bool = false) {
        guard !hasSetNotifications else { return }
        guard remindersStart < remindersEnd else { return }
        hasSetNotifications = true
        print("Creating notifications")
        let time = Calendar.current.dateComponents([.hour, .minute],
                                                   from: remindersStart,
                                                   to: remindersEnd)
        let differenceInMunutes = (time.hour! * 60) + time.minute!
        let totalNotifications = Double(differenceInMunutes / reminderFrequency).rounded(.down)
        for index in 0 ... Int(totalNotifications) {
            guard let notificationDate = Calendar.current.date(byAdding: .minute,
                                                               value: reminderFrequency * index,
                                                               to: remindersStart) else { return }
            createNotification(for: notificationDate)
        }
    }

    private func createNotification(for date: Date) {
        let notification = getReminder()
        let date = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: notification,
                                            trigger: trigger)
        center.add(request, withCompletionHandler: nil)
        center.setNotificationCategories([getActions()])
    }

    private func getActions() -> UNNotificationCategory {
        var unit = String()
        var small = String()
        var medium = String()
        var large = String()
        if isMetric {
            small = String(format: "%.0f", Measurement(value: smallDrink, unit: UnitVolume.milliliters).value)
            medium = String(format: "%.0f", Measurement(value: mediumDrink, unit: UnitVolume.milliliters).value)
            large = String(format: "%.0f", Measurement(value: largeDrink, unit: UnitVolume.milliliters).value)
            unit = "ml"
        } else {
            small = String(format: "%.2f", Measurement(value: smallDrink, unit: UnitVolume.milliliters)
                .converted(to: .fluidOunces).value)
            medium = String(format: "%.2f", Measurement(value: mediumDrink, unit: UnitVolume.milliliters)
                .converted(to: .fluidOunces).value)
            large = String(format: "%.2f", Measurement(value: largeDrink, unit: UnitVolume.milliliters)
                .converted(to: .fluidOunces).value)
            unit = "fl oz"
        }
        let smallDrinkAction = UNNotificationAction(identifier: "small",
                                                    title: "\(Localizable.add.local(language)) \(small)\(unit)",
                                                    options: .foreground)
        let mediumDrinkAction = UNNotificationAction(identifier: "medium",
                                                     title: "\(Localizable.add.local(language)) \(medium)\(unit)",
                                                     options: .foreground)
        let largeDrinkAction = UNNotificationAction(identifier: "large",
                                                    title: "\(Localizable.add.local(language)) \(large)\(unit)",
                                                    options: .foreground)
        return UNNotificationCategory(identifier: "water reminder",
                                      actions: [smallDrinkAction, mediumDrinkAction, largeDrinkAction],
                                      intentIdentifiers: [],
                                      options: .customDismissAction)
    }

    private func createCongratulation() {
        guard isRemindersOn else { return }
        let notfication = getCongratulation()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: notfication,
                                            trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print(error)
            } else {
                print("Added congrats message")
            }
        }
        settingsRepository.reachedGoalOnDate = Date()
    }

    /**
     Will return a random **UNMutableNotificationContent** a notifcation message.

     # Notes: #
     1. This will pick out a message randomly so you could get the same message twice.

     # Example #
     ```
     let notification = getReminder()
     ```
     */
    private func getReminder() -> UNMutableNotificationContent {
        let reminder: [Reminder] = [
            Reminder(title: Localizable.Notification.reminder1Title.local(language),
                     body: Localizable.Notification.reminder1Body.local(language)),
            Reminder(title: Localizable.Notification.reminder2Title.local(language),
                     body: Localizable.Notification.reminder2Body.local(language)),
            Reminder(title: Localizable.Notification.reminder3Title.local(language),
                     body: Localizable.Notification.reminder3Body.local(language)),
            Reminder(title: Localizable.Notification.reminder4Title.local(language),
                     body: Localizable.Notification.reminder4Body.local(language)),
            Reminder(title: Localizable.Notification.reminder5Title.local(language),
                     body: Localizable.Notification.reminder5Body.local(language)),
            Reminder(title: Localizable.Notification.reminder6Title.local(language),
                     body: Localizable.Notification.reminder6Body.local(language)),
            Reminder(title: Localizable.Notification.reminder7Title.local(language),
                     body: Localizable.Notification.reminder7Body.local(language)),
            Reminder(title: Localizable.Notification.reminder8Title.local(language),
                     body: Localizable.Notification.reminder8Body.local(language)),
            Reminder(title: Localizable.Notification.reminder9Title.local(language),
                     body: Localizable.Notification.reminder9Body.local(language)),
            Reminder(title: Localizable.Notification.reminder10Title.local(language),
                     body: Localizable.Notification.reminder10Body.local(language)),
            Reminder(title: Localizable.Notification.reminder11Title.local(language),
                     body: Localizable.Notification.reminder11Body.local(language)),
            Reminder(title: Localizable.Notification.reminder12Title.local(language),
                     body: Localizable.Notification.reminder12Body.local(language))
        ]
        let randomIndex = Int.random(in: 0 ... reminder.count - 1)
        let notification = UNMutableNotificationContent()
        notification.title = reminder[randomIndex].title
        notification.body = reminder[randomIndex].body
        notification.categoryIdentifier = "water reminder"
        notification.sound = .default
        return notification
    }

    private func getCongratulation() -> UNMutableNotificationContent {
        let reminder: [Reminder] = [
            Reminder(title: Localizable.Notification.congrats1Title.local(language),
                     body: Localizable.Notification.congrats1Body.local(language)),
            Reminder(title: Localizable.Notification.congrats2Title.local(language),
                     body: Localizable.Notification.congrats2Body.local(language)),
            Reminder(title: Localizable.Notification.congrats3Title.local(language),
                     body: Localizable.Notification.congrats3Body.local(language)),
            Reminder(title: Localizable.Notification.congrats4Title.local(language),
                     body: Localizable.Notification.congrats4Body.local(language)),
            Reminder(title: Localizable.Notification.congrats5Title.local(language),
                     body: Localizable.Notification.congrats5Body.local(language)),
            Reminder(title: Localizable.Notification.congrats6Title.local(language),
                     body: Localizable.Notification.congrats6Body.local(language)),
            Reminder(title: Localizable.Notification.congrats7Title.local(language),
                     body: Localizable.Notification.congrats7Body.local(language)),
            Reminder(title: Localizable.Notification.congrats8Title.local(language),
                     body: Localizable.Notification.congrats8Body.local(language)),
            Reminder(title: Localizable.Notification.congrats9Title.local(language),
                     body: Localizable.Notification.congrats9Body.local(language)),
            Reminder(title: Localizable.Notification.congrats10Title.local(language),
                     body: Localizable.Notification.congrats10Body.local(language))
        ]
        let randomIndex = Int.random(in: 0 ... reminder.count - 1)
        let notification = UNMutableNotificationContent()
        notification.title = reminder[randomIndex].title
        notification.body = reminder[randomIndex].body
        notification.categoryIdentifier = "congratulations"
        notification.sound = .default
        return notification
    }
}
