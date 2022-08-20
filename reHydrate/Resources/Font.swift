//
//  Font.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

extension Font {
    static let brandLargeHeader = Font.custom("AmericanTypewriter", size: 50)
    static let brandExtraLargeTitle = Font.custom("AmericanTypewriter", size: 30)
    static let brandLargeTitle = Font.custom("AmericanTypewriter", size: 25)
    static let brandTitle = Font.custom("AmericanTypewriter", size: 20)
    static let brandBody = Font.custom("AmericanTypewriter", size: 15)
    static let brandSubTitle = Font.custom("AmericanTypewriter", size: 10)
}

extension UIFont {
    static let brandLargeHeader = UIFont(name: "AmericanTypewriter", size: 50)
    static let brandLargeHeaderBold = UIFont(name: "AmericanTypewriter-Bold", size: 50)

    static let brandLargeTitle = UIFont(name: "AmericanTypewriter", size: 30)
    static let brandLargeTitleBold = UIFont(name: "AmericanTypewriter-Bold", size: 30)

    static let brandTitle = UIFont(name: "AmericanTypewriter", size: 20)
    static let brandTitleBold = UIFont(name: "AmericanTypewriter-Bold", size: 20)

    static let brandBody = UIFont(name: "AmericanTypewriter", size: 15)
    static let brandBodyBold = UIFont(name: "AmericanTypewriter-Bold", size: 15)

    static let brandsubTitle = UIFont(name: "AmericanTypewriter", size: 10)
    static let brandSubTitleBold = UIFont(name: "AmericanTypewriter-Bold", size: 10)
}
