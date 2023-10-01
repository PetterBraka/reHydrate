//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 01/10/2023.
//

import UserNotifications

public extension Array where Element == UNNotificationRequest {
    func containsRequest(
        at dateComponents: DateComponents,
        withAccuracy minutes: Int,
        using calendarComponents: Set<Calendar.Component>
    ) -> Bool {
        compactMap { request -> DateComponents? in
            guard let date = request.trigger?.date else { return nil }
            return Calendar.current.dateComponents(calendarComponents, from: date)
        }.contains { pendingRequest in
            pendingRequest.comparedTo(dateComponents, minutes)
        }
    }
}
