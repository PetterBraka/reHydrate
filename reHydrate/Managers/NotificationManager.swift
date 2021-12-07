//
//  NotificationManager.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 04/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import Combine
import UserNotifications

// MARK: - Notifications

class NotificationManager {
    struct Reminder {
        var title = String()
        var body  = String()
    }
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @Preference(\.remindersStart) private var remindersStart
    @Preference(\.remindersEnd) private var remindersEnd
    @Preference(\.remindersInterval) private var reminderFrequency
    @Preference(\.smallDrink) private var smallDrink
    @Preference(\.mediumDrink) private var mediumDrink
    @Preference(\.largeDrink) private var largeDrink
    @Preference(\.isUsingMetric) private var isMetric
    
    static let shared = NotificationManager()
    
    let center = UNUserNotificationCenter.current()
    
    func requestAccess() -> AnyPublisher<Void, Error> {
        Future { [unowned self] promise in
            self.center.requestAuthorization(options: [.alert, .sound]) { _, error in
                guard let error = error else {
                    promise(.success(()))
                    return
                }
                promise(.failure(error))
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func deleteReminders() {
        print("Deleting reminders")
        self.center.removeAllDeliveredNotifications()
        self.center.removeAllPendingNotificationRequests()
    }
    
    /**
     Will set a notification for every half hour between 7 am and 11pm.
     
     # Example #
     ```
     setReminders()
     ```
     */
    func setReminders(){
        deleteReminders()
        print("Created notifications")
        let difference = Calendar.current.dateComponents([.hour, .minute],
                                                         from: remindersStart,
                                                         to: remindersEnd)
        let differenceInMunutes = (difference.hour! * 60) + difference.minute!
        let totalNotifications = Double(differenceInMunutes / reminderFrequency).rounded(.down)
        var unit = String()
        var small  = String()
        var medium = String()
        var large  = String()
        if isMetric {
            small = String(format: "%.0f", Measurement(value: smallDrink, unit: UnitVolume.milliliters).value)
            medium = String(format: "%.0f", Measurement(value: mediumDrink, unit: UnitVolume.milliliters).value)
            large = String(format: "%.0f", Measurement(value: largeDrink, unit: UnitVolume.milliliters).value)
            unit = "ml"
        } else {
            small = String(format: "%.2f", Measurement(value: smallDrink, unit: UnitVolume.milliliters).converted(to: .fluidOunces).value)
            medium = String(format: "%.2f", Measurement(value: mediumDrink, unit: UnitVolume.milliliters).converted(to: .fluidOunces).value)
            large = String(format: "%.2f", Measurement(value: largeDrink, unit: UnitVolume.milliliters).converted(to: .fluidOunces).value)
            unit = "fl oz"
        }
        for index in 0...Int(totalNotifications) {
            if let notificationDate = Calendar.current.date(byAdding: .minute,
                                                            value: reminderFrequency * index,
                                                            to: remindersStart) {
                createNotification(for: notificationDate, with: small, unit, medium, large)
        }
        }
    }
    
    private func createNotification(for date: Date,
                                    with small: String,
                                    _ unit: String,
                                    _ medium: String,
                                    _ large: String) {
        let notification = getReminder()
//        let smallDrinkAction = UNNotificationAction(identifier: "small",
//                                                    title: "\(NSLocalizedString("Add", comment: "")) \(small)\(unit)",
//                                                    options: UNNotificationActionOptions(rawValue: 0))
//        let mediumDrinkAction = UNNotificationAction(identifier: "medium",
//                                                     title: "\(NSLocalizedString("Add", comment: "")) \(medium)\(unit)",
//                                                     options: UNNotificationActionOptions(rawValue: 0))
//        let largeDrinkAction = UNNotificationAction(identifier: "large",
//                                                    title: "\(NSLocalizedString("Add", comment: "")) \(large)\(unit)",
//                                                    options: UNNotificationActionOptions(rawValue: 0))
//        let category = UNNotificationCategory(identifier: notification.categoryIdentifier,
//                                              actions: [smallDrinkAction, mediumDrinkAction, largeDrinkAction],
//                                              intentIdentifiers: [],
//                                              options: .customDismissAction)
        let date = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: notification,
                                            trigger: trigger)
        
        self.center.add(request, withCompletionHandler: nil)
//        self.center.setNotificationCategories([category])
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
    private func getReminder()-> UNMutableNotificationContent{
        let reminder: [Reminder] = [
            Reminder(title: Localizable.Notification.reminder1Title.local(language),
                     body:  Localizable.Notification.reminder1Body.local(language)),
            Reminder(title: Localizable.Notification.reminder2Title.local(language),
                     body:  Localizable.Notification.reminder2Body.local(language)),
            Reminder(title: Localizable.Notification.reminder3Title.local(language),
                     body:  Localizable.Notification.reminder3Body.local(language)),
            Reminder(title: Localizable.Notification.reminder4Title.local(language),
                     body:  Localizable.Notification.reminder4Body.local(language)),
            Reminder(title: Localizable.Notification.reminder5Title.local(language),
                     body:  Localizable.Notification.reminder5Body.local(language)),
            Reminder(title: Localizable.Notification.reminder6Title.local(language),
                     body:  Localizable.Notification.reminder6Body.local(language)),
            Reminder(title: Localizable.Notification.reminder7Title.local(language),
                     body:  Localizable.Notification.reminder7Body.local(language)),
            Reminder(title: Localizable.Notification.reminder8Title.local(language),
                     body:  Localizable.Notification.reminder8Body.local(language)),
            Reminder(title: Localizable.Notification.reminder9Title.local(language),
                     body:  Localizable.Notification.reminder9Body.local(language)),
            Reminder(title: Localizable.Notification.reminder10Title.local(language),
                     body:  Localizable.Notification.reminder10Body.local(language)),
            Reminder(title: Localizable.Notification.reminder11Title.local(language),
                     body:  Localizable.Notification.reminder11Body.local(language)),
            Reminder(title: Localizable.Notification.reminder12Title.local(language),
                     body:  Localizable.Notification.reminder12Body.local(language))]
        let randomIndex = Int.random(in: 0...reminder.count - 1)
        let notification = UNMutableNotificationContent()
        notification.title = reminder[randomIndex].title
        notification.body  = reminder[randomIndex].body
        notification.categoryIdentifier = "water reminder"
        notification.sound  = .default
        return notification
    }
    
    private func getCongratulation()-> UNMutableNotificationContent{
        let reminder: [Reminder] = [
            Reminder(title: Localizable.Notification.congrats1Title.local(language),
                     body:  Localizable.Notification.congrats1Body.local(language)),
            Reminder(title: Localizable.Notification.congrats2Title.local(language),
                     body:  Localizable.Notification.congrats2Body.local(language)),
            Reminder(title: Localizable.Notification.congrats3Title.local(language),
                     body:  Localizable.Notification.congrats3Body.local(language)),
            Reminder(title: Localizable.Notification.congrats4Title.local(language),
                     body:  Localizable.Notification.congrats4Body.local(language)),
            Reminder(title: Localizable.Notification.congrats5Title.local(language),
                     body:  Localizable.Notification.congrats5Body.local(language)),
            Reminder(title: Localizable.Notification.congrats6Title.local(language),
                     body:  Localizable.Notification.congrats6Body.local(language)),
            Reminder(title: Localizable.Notification.congrats7Title.local(language),
                     body:  Localizable.Notification.congrats7Body.local(language)),
            Reminder(title: Localizable.Notification.congrats8Title.local(language),
                     body:  Localizable.Notification.congrats8Body.local(language)),
            Reminder(title: Localizable.Notification.congrats9Title.local(language),
                     body:  Localizable.Notification.congrats9Body.local(language)),
            Reminder(title: Localizable.Notification.congrats10Title.local(language),
                     body:  Localizable.Notification.congrats10Body.local(language))]
        let randomIndex = Int.random(in: 0...reminder.count - 1)
        let notification = UNMutableNotificationContent()
        notification.title = reminder[randomIndex].title
        notification.body  = reminder[randomIndex].body
        notification.categoryIdentifier = "congratulations"
        notification.sound  = .default
        return notification
    }
}
