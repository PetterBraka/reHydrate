//
//  Notification+Extensions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let changedLanguage = Notification.Name("changedLanguage")
    static let addedSmallDrink = Notification.Name("addedSmallDrink")
    static let addedMediumDrink = Notification.Name("addedMediumDrink")
    static let addedLargeDrink = Notification.Name("addedLargeDrink")
    static let editDrink = Notification.Name("editDrink")
    static let savedDrink = Notification.Name("savedDrink")
}
