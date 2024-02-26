//
//  TrustedUrl.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//

import Foundation

public enum TrustedUrl {
    case privacy
    case license
    case merchandise
    case developerInstagram
    
    public var url: URL? {
        switch self {
        case .privacy:
            URL(string: "https://github.com/PetterBraka/reHydrate/blob/master/Privacy-Policy.md")
        case .license:
            URL(string:"https://github.com/PetterBraka/reHydrate/blob/master/LICENSE")
        case .developerInstagram:
            URL(string:"https://www.instagram.com/braka.coding/")
        case .merchandise:
            URL(string:"https://www.redbubble.com/people/petter-braka/shop")
        }
    }
}
