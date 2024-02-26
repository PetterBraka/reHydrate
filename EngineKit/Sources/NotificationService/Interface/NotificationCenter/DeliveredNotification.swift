//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//

import Foundation

public struct DeliveredNotification {
    public let date: Date
    public let request: NotificationRequest
    
    public init(date: Date, request: NotificationRequest) {
        self.date = date
        self.request = request
    }
}
