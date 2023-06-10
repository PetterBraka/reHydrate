//
//  NotificationName.swift
//
//
//  Created by Petter vang Brakalsvålet on 23/04/2023.
//

import Foundation

public extension Notification.Name {
    static let changedLanguage = Notification.Name("changedLanguage")
    static let addedSmallDrink = Notification.Name("addedSmallDrink")
    static let addedMediumDrink = Notification.Name("addedMediumDrink")
    static let addedLargeDrink = Notification.Name("addedLargeDrink")
    static let editDrink = Notification.Name("editDrink")
    static let savedDrink = Notification.Name("savedDrink")
}
