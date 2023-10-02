//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//

public struct NotificationContent {
    public let title: String
    public let subtitle: String
    public let body: String
    public let userInfo: [AnyHashable : Any]
    public let categoryIdentifier: String
    
    public init(title: String, subtitle: String, body: String, categoryIdentifier: String, userInfo: [AnyHashable : Any]) {
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.categoryIdentifier = categoryIdentifier
        self.userInfo = userInfo
    }
}
