//
//  Reminder.swift
//  
//
//  Created by Petter vang Brakalsvålet on 23/09/2023.
//

import Foundation

struct Reminder {
    static let all: [(title: String, body: String)] = [
        (reminder1Title, reminder1Body),
        (reminder2Title, reminder2Body),
        (reminder3Title, reminder3Body),
        (reminder4Title, reminder4Body),
        (reminder5Title, reminder5Body),
        (reminder6Title, reminder6Body),
        (reminder7Title, reminder7Body),
        (reminder8Title, reminder8Body),
        (reminder9Title, reminder9Body),
        (reminder10Title, reminder10Body),
        (reminder10Title, reminder10Body),
        (reminder11Title, reminder11Body),
        (reminder12Title, reminder12Body),
        (reminder12Title, reminder12Body)
    ]
    
    static func random() -> (title: String, body: String) {
        all.randomElement() ?? (reminder1Title, reminder1Body)
    }
}

private extension Reminder {
    static let reminder1Title = LocalizedString(
        "notification.reminder.reminder1.Title",
        value: "You should have some water.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder1Body = LocalizedString(
        "notification.reminder.reminder1.Body",
        value: "It has been a long time since you had some water, why don't you have some.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder2Title = LocalizedString(
        "notification.reminder.reminder2.Title",
        value: "Hi, have you heard about the Sahara?",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder2Body = LocalizedString(
        "notification.reminder.reminder2.Body",
        value: "I suggest not having that as an idol. Have some water.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder3Title = LocalizedString(
        "notification.reminder.reminder3.Title",
        value: "Water - what is that?",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder3Body = LocalizedString(
        "notification.reminder.reminder3.Body",
        value: "Have you remembered to drink water? I suggest that you have some.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder4Title = LocalizedString(
        "notification.reminder.reminder4.Title",
        value: "Hey, would you mind if i asked you a question?",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder4Body = LocalizedString(
        "notification.reminder.reminder4.Body",
        value: "Wouldn't it be great to have some water?",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder5Title = LocalizedString(
        "notification.reminder.reminder5.Title",
        value: "What about some water?",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder5Body = LocalizedString(
        "notification.reminder.reminder5.Body",
        value: "Hey, maybe you should give your brain something to run on?",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder6Title = LocalizedString(
        "notification.reminder.reminder6.Title",
        value: "Just a little reminder.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder6Body = LocalizedString(
        "notification.reminder.reminder6.Body",
        value: "There is a thing called water; maybe you should have some.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder7Title = LocalizedString(
        "notification.reminder.reminder7.Title",
        value: "I know you don't like it.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder7Body = LocalizedString(
        "notification.reminder.reminder7.Body",
        value: "But have some water - it's not going to hurt you.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder8Title = LocalizedString(
        "notification.reminder.reminder8.Title",
        value: "What is blue and refreshing?",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder8Body = LocalizedString(
        "notification.reminder.reminder8.Body",
        value: "Water. It’s water. Drink some.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder9Title = LocalizedString(
        "notification.reminder.reminder9.Title",
        value: "Have some water.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder9Body = LocalizedString(
        "notification.reminder.reminder9.Body",
        value: "You need to hydrate. Have some water.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder10Title = LocalizedString(
        "notification.reminder.reminder10.Title",
        value: "Why aren't you thirsty by now.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder10Body = LocalizedString(
        "notification.reminder.reminder10.Body",
        value: "You should have some water.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder11Title = LocalizedString(
        "notification.reminder.reminder11.Title",
        value: "Hello there.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder11Body = LocalizedString(
        "notification.reminder.reminder11.Body",
        value: "General Kenobi, would you like some water?",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder12Title = LocalizedString(
        "notification.reminder.reminder12.Title",
        value: "Hey there, me again.",
        comment: "Notification message sent to remind you to drink more water"
    )
    
    static let reminder12Body = LocalizedString(
        "notification.reminder.reminder12.Body",
        value: "I think you should have some water.",
        comment: "Notification message sent to remind you to drink more water"
    )
}
