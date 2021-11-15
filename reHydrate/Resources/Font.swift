//
//  Font.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

extension Font {
    static let largeHeader = Font.custom("AmericanTypewriter", size: 50)
    static let largeHeaderBold = Font.custom("AmericanTypewriter-Bold", size: 50)
    
    static let largeTitle = Font.custom("AmericanTypewriter", size: 30)
    static let largeTitleBold = Font.custom("AmericanTypewriter-Bold", size: 30)
    
    static let title = Font.custom("AmericanTypewriter", size: 20)
    static let titleBold = Font.custom("AmericanTypewriter-Bold", size: 20)
    
    static let body = Font.custom("AmericanTypewriter", size: 15)
    static let bodyBold = Font.custom("AmericanTypewriter-Bold", size: 15)
    
    static let subTitle = Font.custom("AmericanTypewriter", size: 10)
    static let subTitleBold = Font.custom("AmericanTypewriter-Bold", size: 10)
}

extension UIFont {
    static let largeHeader = UIFont(name: "AmericanTypewriter", size: 50)
    static let largeHeaderBold = UIFont(name: "AmericanTypewriter-Bold", size: 50)
    
    static let largeTitle = UIFont(name: "AmericanTypewriter", size: 30)
    static let largeTitleBold = UIFont(name: "AmericanTypewriter-Bold", size: 30)
    
    static let title = UIFont(name: "AmericanTypewriter", size: 20)
    static let titleBold = UIFont(name: "AmericanTypewriter-Bold", size: 20)
    
    static let body = UIFont(name: "AmericanTypewriter", size: 15)
    static let bodyBold = UIFont(name: "AmericanTypewriter-Bold", size: 15)
    
    static let subTitle = UIFont(name: "AmericanTypewriter", size: 10)
    static let subTitleBold = UIFont(name: "AmericanTypewriter-Bold", size: 10)
}
