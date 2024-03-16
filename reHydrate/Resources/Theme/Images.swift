////
////  Images.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

extension Image {
    // SF images
    static let back = Image(systemName: "chevron.left")
    static let open = Image(systemName: "chevron.forward")
    static let settings = Image(systemName: "gear.circle")
    static let calendar = Image(systemName: "calendar.circle")

    static let darkMode = Image(systemName: "moon.circle.fill")
    static let lightMode = Image(systemName: "sun.max.circle.fill")

    static let plus = Image(systemName: "plus")
    static let minus = Image(systemName: "minus")

    static let remindersOn = Image(systemName: "bell.circle.fill")
    static let remindersOff = Image(systemName: "bell.slash.circle")
    static let ellipsis = Image(systemName: "ellipsis.circle.fill")
}
