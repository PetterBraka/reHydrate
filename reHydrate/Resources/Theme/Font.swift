//
//  Font.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

fileprivate let typewriter = "AmericanTypewriter"

extension Font {
    enum Theme {
        static let extraLargeTitle2 = Font.custom(typewriter, size: 50, relativeTo: .largeTitle)
        static let extraLargeTitle = Font.custom(typewriter, size: 40, relativeTo: .largeTitle)
        static let title = Font.custom(typewriter, size: 30, relativeTo: .title3)
        static let title2 = Font.custom(typewriter, size: 25, relativeTo: .title2)
        static let title3 = Font.custom(typewriter, size: 20, relativeTo: .title)
        static let body = Font.custom(typewriter, size: 18, relativeTo: .body)
        static let callout = Font.custom(typewriter, size: 15, relativeTo: .callout)
        static let caption = Font.custom(typewriter, size: 10, relativeTo: .caption)
    }
}

extension UIFont {
    enum Theme {
        static let extraLargeTitle2 = UIFontMetrics(forTextStyle: .extraLargeTitle2).scaledFont(for: UIFont(name: typewriter, size: 50)!)
        static let extraLargeTitle = UIFontMetrics(forTextStyle: .extraLargeTitle).scaledFont(for: UIFont(name: typewriter, size: 40)!)
        static let title3 = UIFontMetrics(forTextStyle: .title3).scaledFont(for: UIFont(name: typewriter, size: 30)!)
        static let title2 = UIFontMetrics(forTextStyle: .title2).scaledFont(for: UIFont(name: typewriter, size: 25)!)
        static let title = UIFontMetrics(forTextStyle: .title1).scaledFont(for: UIFont(name: typewriter, size: 20)!)
        static let body = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: typewriter, size: 18)!)
        static let callout = UIFontMetrics(forTextStyle: .callout).scaledFont(for: UIFont(name: typewriter, size: 15)!)
        static let caption = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: UIFont(name: typewriter, size: 10)!)
    }
}
