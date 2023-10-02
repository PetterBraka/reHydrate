//
//  NotificationCategory.swift
//
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//

public struct NotificationCategory: Hashable {
    public let identifier: String
    public let actions: [NotificationAction]
    public let intentIdentifiers: [String]
    
    public init(identifier: String, actions: [NotificationAction], intentIdentifiers: [String]) {
        self.identifier = identifier
        self.actions = actions
        self.intentIdentifiers = intentIdentifiers
    }
}
