//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//

public struct NotificationContent: Sendable {
    public let title: String
    public let subtitle: String
    public let body: String
    public let userInfo: [AnyHashableAndSendable: any Sendable]
    public let categoryIdentifier: String
    
    public init(title: String, subtitle: String, body: String, categoryIdentifier: String, userInfo: [AnyHashableAndSendable: any Sendable]) {
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.categoryIdentifier = categoryIdentifier
        self.userInfo = userInfo
    }
}
