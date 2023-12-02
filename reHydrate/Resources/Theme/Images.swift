//
//  Images.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

extension Image {
    static let glass = Image("glass.fill.0")
    static let bottle = Image("bottle.fill.0")
    static let reusableBottle = Image("reusable.bottle.fill.0")

    static func getGlass(with fill: Double) -> Image {
        switch fill {
        case 0:
            return Image("glass.fill.0")
        case 0.1 ... 0.3:
            return Image("glass.fill.25")
        case 0.3 ... 0.6:
            return Image("glass.fill.50")
        case 0.6 ... 0.8:
            return Image("glass.fill.75")
        default:
            return Image("glass.fill.100")
        }
    }

    static func getBottle(with fill: Double) -> Image {
        switch fill {
        case 0:
            return Image("bottle.fill.0")
        case 0.1 ... 0.3:
            return Image("bottle.fill.25")
        case 0.3 ... 0.6:
            return Image("bottle.fill.50")
        case 0.6 ... 0.8:
            return Image("bottle.fill.75")
        default:
            return Image("bottle.fill.100")
        }
    }

    static func getReusableBottle(with fill: Double) -> Image {
        switch fill {
        case 0:
            return Image("reusable.bottle.fill.0")
        case 0.1 ... 0.3:
            return Image("reusable.bottle.fill.25")
        case 0.3 ... 0.6:
            return Image("reusable.bottle.fill.50")
        case 0.6 ... 0.8:
            return Image("reusable.bottle.fill.75")
        default:
            return Image("reusable.bottle.fill.100")
        }
    }

    static let logo = Image("reHydrateLogo")

    static let circle = Image("circle")
    static let leftSelected = Image("left.selected")
    static let midSelected = Image("mid.selected")
    static let rightSelected = Image("right.selected")

    static let waterDrop0 = Image("water.drop.0")
    static let waterDrop25 = Image("water.drop.25")
    static let waterDrop50 = Image("water.drop.50")
    static let waterDrop75 = Image("water.drop.75")
    static let waterDrop100 = Image("water.drop.100")

    static let waterDrop = Image("sf.water.drop")

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
}
