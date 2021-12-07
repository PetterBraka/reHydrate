//
//  AppIcons+Helper.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 07/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import UIKit

enum Icon: String, CaseIterable {
    // Icons
    case whiteGray = "white-grey"
    case greyWhite = "grey-white"
    case blackWhite = "black-white"
    // Blue icons
    case whiteBlue = "white-blue"
    case blueWhite = "blue-white"
    case blackBlue = "black-blue"
    // Green icons
    case whiteGreen = "white-green"
    case greenWhite = "green-white"
    case blackGreen = "black-green"
    // Orange icons
    case whiteOrange = "white-orange"
    case orangeWhite = "orange-white"
    case blackOrange = "black-orange"
    // Pink icons
    case whitePink = "white-pink"
    case pinkWhite = "pink-white"
    case blackPink = "black-pink"
    // Purple icons
    case whitePurple = "white-purple"
    case purpleWhite = "purple-white"
    case blackPurple = "black-purple"
    // Red icons
    case whiteRed = "white-red"
    case redWhite = "red-white"
    case blackRed = "black-red"
    // Yellow icons
    case whiteYellow = "white-yellow"
    case yellowWhite = "yellow-white"
    case blackYellow = "black-yellow"
    // Rainbow icons
    case whiteRainbow = "white-rainbow"
    case rainbowWhite = "rainbow-white"
    case blackRainbow = "black-rainbow"
}

class IconHelper: ObservableObject {
    var iconNames: [Icon] = Icon.allCases
    
    @Published var currentIndex = 0
    
    init() {
        if let currentIcon = UIApplication.shared.alternateIconName {
            self.currentIndex = iconNames.firstIndex(of: Icon(rawValue: currentIcon) ?? .blackWhite) ?? 0
        }
    }
}
