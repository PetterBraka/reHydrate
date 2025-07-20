//
//  NotificationAction.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//

public struct NotificationAction: Hashable, Sendable {
    public let identifier: String
    public let title: String
    
    public init(identifier: String, title: String) {
        self.identifier = identifier
        self.title = title
    }
}
