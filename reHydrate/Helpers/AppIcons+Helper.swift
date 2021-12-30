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
    case whiteGray = "whiteGrey"
    case greyWhite = "greyWhite"
    case blackWhite = "blackWhite"
    // Blue icons
    case whiteBlue = "whiteBlue"
    case blueWhite = "blueWhite"
    case blackBlue = "blackBlue"
    // Green icons
    case whiteGreen = "whiteGreen"
    case greenWhite = "greenWhite"
    case blackGreen = "blackGreen"
    // Orange icons
    case whiteOrange = "whiteOrange"
    case orangeWhite = "orangeWhite"
    case blackOrange = "blackOrange"
    // LexiPink
    case whiteLexiPink = "whitelexipink"
    case lexiPinkWhite = "lexipinkwhite"
    case blackLexiPink = "blacklexipink"
    // Pink icons
    case whitePink = "whitePink"
    case pinkWhite = "pinkWhite"
    case blackPink = "blackPink"
    // Purple icons
    case whitePurple = "whitePurple"
    case purpleWhite = "purpleWhite"
    case blackPurple = "blackPurple"
    // Red icons
    case whiteRed = "whiteRed"
    case redWhite = "redWhite"
    case blackRed = "blackRed"
    // Yellow icons
    case whiteYellow = "whiteYellow"
    case yellowWhite = "yellowWhite"
    case blackYellow = "blackYellow"
    // Rainbow icons
    case whiteRainbow = "whiteRainbow"
    case rainbowWhite = "rainbowWhite"
    case blackRainbow = "blackRainbow"
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
