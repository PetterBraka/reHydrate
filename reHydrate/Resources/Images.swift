//
//  Images.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import UIKit

extension Image {
    static let glass = Image("Glass")
    static let bottle = Image("Bottle")
    static let largeBottle = Image("Reusable Bottle")

    static func getGlass(with fill: Double) -> Image {
        switch fill {
        case 0:
            return Image("Glass")
        case 0.1 ... 0.3:
            return Image("Glass fill 25")
        case 0.3 ... 0.6:
            return Image("Glass fill 50")
        case 0.6 ... 0.8:
            return Image("Glass fill 75")
        default:
            return Image("Glass fill 100")
        }
    }

    static func getBottle(with fill: Double) -> Image {
        switch fill {
        case 0:
            return Image("Bottle")
        case 0.1 ... 0.3:
            return Image("Bottle fill 25")
        case 0.3 ... 0.6:
            return Image("Bottle fill 50")
        case 0.6 ... 0.8:
            return Image("Bottle fill 75")
        default:
            return Image("Bottle fill 100")
        }
    }

    static func getReusableBottle(with fill: Double) -> Image {
        switch fill {
        case 0:
            return Image("Reusable Bottle")
        case 0.1 ... 0.3:
            return Image("Reusable Bottle fill 25")
        case 0.3 ... 0.6:
            return Image("Reusable Bottle fill 50")
        case 0.6 ... 0.8:
            return Image("Reusable Bottle fill 75")
        default:
            return Image("Reusable Bottle fill 100")
        }
    }

    static let logo = Image("reHydrateLogo")

    static let circle = Image("circle")
    static let leftSelected = Image("LeftSelected")
    static let midSelected = Image("MidSelected")
    static let rightSelected = Image("RightSelected")

    static let waterDrop0 = Image("water.drop.0")
    static let waterDrop25 = Image("water.drop.25")
    static let waterDrop50 = Image("water.drop.50")
    static let waterDrop75 = Image("water.drop.75")
    static let waterDrop100 = Image("water.drop.100")

    static let waterDrop = Image("waterDrop")

    static let back = Image(systemName: "chevron.left.circle")
    static let open = Image(systemName: "chevron.forward")
    static let settings = Image(systemName: "gear.circle")
    static let calender = Image(systemName: "calendar.circle")

    static let darkMode = Image(systemName: "moon.circle.fill")
    static let lightMode = Image(systemName: "sun.max.circle.fill")

    static let plus = Image(systemName: "plus")
    static let minus = Image(systemName: "minus")

    static let remindersOn = Image(systemName: "bell.circle.fill")
    static let remindersOff = Image(systemName: "bell.slash.circle")
}

extension UIImage {
    static let cup = UIImage(named: "Cup")!
    static let bottle = UIImage(named: "Bottle")!
    static let largeBottle = UIImage(named: "Flask")!

    static let logo = UIImage(named: "reHydrateLogo")!

    static let circle = UIImage(named: "circle")!
    static let leftSelected = UIImage(named: "LeftSelected")!
    static let midSelected = UIImage(named: "MidSelected")!
    static let rightSelected = UIImage(named: "RightSelected")!

    static let waterDrop0 = UIImage(named: "water.drop.0")!
    static let waterDrop25 = UIImage(named: "water.drop.25")!
    static let waterDrop50 = UIImage(named: "water.drop.50")!
    static let waterDrop75 = UIImage(named: "water.drop.75")!
    static let waterDrop100 = UIImage(named: "water.drop.100")!

    static let waterDrop = UIImage(named: "waterDrop")!

    static let back = UIImage(systemName: "chevron.left.circle")!
    static let settings = UIImage(systemName: "gear.circle")!
    static let calender = UIImage(systemName: "calendar.circle")!
}
