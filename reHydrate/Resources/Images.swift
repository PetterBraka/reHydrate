//
//  Images.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import SwiftUI

extension Image {
    static let cup = Image("Cup")
    static let bottle = Image("Bottle")
    static let largeBottle = Image("Flask")
    
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
    
    // Icons
    static let whiteGray = Image("white-grey")
    static let greyWhite = Image("grey-white")
    static let blackWhite = Image("black-white")
    
    // Blue icons
    static let whiteBlue = Image("white-blue")
    static let blueWhite = Image("blue-white")
    static let blackBlue = Image("black-blue")
    
    static let whiteGreen = Image("white-green")
    static let greenWhite = Image("green-white")
    static let blackGreen = Image("black-green")
    static let whiteOrange = Image("white-orange")
    static let orangeWhite = Image("orange-white")
    static let blackOrange = Image("black-orange")
    static let whitePink = Image("white-pink")
    static let pinkWhite = Image("pink-white")
    static let blackPink = Image("black-pink")
    static let whitePurple = Image("white-purple")
    static let purpleWhite = Image("purple-white")
    static let blackPurple = Image("black-purple")
    static let whiteRed = Image("white-red")
    static let redWhite = Image("red-white")
    static let blackRed = Image("black-red")
    static let whiteYellow = Image("white-yellow")
    static let yellowWhite = Image("yellow-white")
    static let blackYellow = Image("black-yellow")
    static let whiteRainbow = Image("white-rainbow")
    static let rainbowWhite = Image("rainbow-white")
    static let blackRainbow = Image("black-rainbow")
    
    static let icons: [Image] = [.whiteGray, .greyWhite, .blackWhite,
                                 .whiteBlue, .blueWhite, .blackBlue,
                                 .whiteGreen, .greenWhite, .blackGreen,
                                 .whiteOrange, .orangeWhite, .blackOrange,
                                 .whitePink, .pinkWhite, .blackPink,
                                 .whitePurple, .purpleWhite, .blackPurple,
                                 .whiteRed, .redWhite, .blackRed,
                                 .whiteYellow, .yellowWhite, .blackYellow,
                                 .whiteRainbow, .rainbowWhite, .blackRainbow]
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
