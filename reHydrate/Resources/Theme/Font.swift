//
//  Font.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

extension Font {
    private static let font = "AmericanTypewriter"
    static let brandLargeHeader = Font.custom(font,
                                              size: 50,
                                              relativeTo: .largeTitle)
    static let brandTitle3 = Font.custom(font,
                                         size: 30,
                                         relativeTo: .title3)
    static let brandTitle2 = Font.custom(font,
                                         size: 25,
                                         relativeTo: .title2)
    static let brandTitle = Font.custom(font,
                                        size: 20,
                                        relativeTo: .title)
    static let brandBody = Font.custom(font,
                                       size: 15,
                                       relativeTo: .body)
    static let brandCaption = Font.custom(font,
                                          size: 10,
                                          relativeTo: .caption)
    
    static let extraLargeTitle2 = Font.custom(
        UIFont.preferredFont(forTextStyle: .extraLargeTitle2).fontName,
        size: 50,
        relativeTo: .largeTitle
    )
    
    static let extraLargeTitle = Font.custom(
        UIFont.preferredFont(forTextStyle: .extraLargeTitle).fontName,
        size: 40,
        relativeTo: .largeTitle
    )
}
