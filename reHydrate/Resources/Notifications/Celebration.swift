//
//  Celebration.swift
//
//
//  Created by Petter vang Brakalsvålet on 23/09/2023.
//

import Foundation

struct Celebration {
    static let all: [(title: String, body: String)] = [
        (congrats1Title, congrats1Body),
        (congrats2Title, congrats2Body),
        (congrats3Title, congrats3Body),
        (congrats4Title, congrats4Body),
        (congrats5Title, congrats5Body),
        (congrats6Title, congrats6Body),
        (congrats7Title, congrats7Body),
        (congrats8Title, congrats8Body),
        (congrats9Title, congrats9Body),
        (congrats10Title, congrats10Body),
        (congrats10Title, congrats10Body)
    ]
    
    static func random() -> (title: String, body: String) {
        all.randomElement() ?? (congrats1Title, congrats1Body)
    }
}

private extension Celebration {
    static let congrats1Title = NSLocalizedString(
        "notification.celebration.congrats1.Title",
        value: "Congratulations",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats1Body  = NSLocalizedString(
        "notification.celebration.congrats1.Body",
        value: "You made your goal!",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats2Title = NSLocalizedString(
        "notification.celebration.congrats2.Title",
        value: "Finally,",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats2Body  = NSLocalizedString(
        "notification.celebration.congrats2.Body",
        value: "You did it!",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats3Title = NSLocalizedString(
        "notification.celebration.congrats3.Title",
        value: "Congrats",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats3Body  = NSLocalizedString(
        "notification.celebration.congrats3.Body",
        value: "Another one for the records books!",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats4Title = NSLocalizedString(
        "notification.celebration.congrats4.Title",
        value: "Finally done",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats4Body  = NSLocalizedString(
        "notification.celebration.congrats4.Body",
        value: "You don't need to worry about it anymore!",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats5Title = NSLocalizedString(
        "notification.celebration.congrats5.Title",
        value: "Hey,",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats5Body  = NSLocalizedString(
        "notification.celebration.congrats5.Body",
        value: "Did you see what you did?!",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats6Title = NSLocalizedString(
        "notification.celebration.congrats6.Title",
        value: "Me again,",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats6Body  = NSLocalizedString(
        "notification.celebration.congrats6.Body",
        value: "Congratulations, you reached your goal!",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats7Title = NSLocalizedString(
        "notification.celebration.congrats7.Title",
        value: "Believe it or not, you did it!",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats7Body  = NSLocalizedString(
        "notification.celebration.congrats7.Body",
        value: "It's amazing!",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats8Title = NSLocalizedString(
        "notification.celebration.congrats8.Title",
        value: "You did it!",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats8Body  = NSLocalizedString(
        "notification.celebration.congrats8.Body",
        value: "I knew you would do it!",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats9Title = NSLocalizedString(
        "notification.celebration.congrats9.Title",
        value: "Look at that,",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats9Body  = NSLocalizedString(
        "notification.celebration.congrats9.Body",
        value: "You did it!",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats10Title = NSLocalizedString(
        "notification.celebration.congrats10.Title",
        value: "Well look at that,",
        comment: "Notification message sent when you complete your consumption goal"
    )
    
    static let congrats10Body  = NSLocalizedString(
        "notification.celebration.congrats10.Body",
        value: "You reached your goal!",
        comment: "Notification message sent when you complete your consumption goal"
    )
}
