//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//

public struct NotificationRequest {
    public let identifier: String
    public let content: NotificationContent
    public let trigger: NotificationTrigger?
    
    public init(identifier: String, content: NotificationContent, trigger: NotificationTrigger?) {
        self.identifier = identifier
        self.content = content
        self.trigger = trigger
    }
}
