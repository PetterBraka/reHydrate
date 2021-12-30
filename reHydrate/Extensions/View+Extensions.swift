//
//  View+Extensions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 29/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

enum WebSite {
    case privacy
    case license
    case devInsta
    case contactMe
    case helpTranslate
    case merch

    func getURL() -> String {
        switch self {
        case .privacy:
            return "https://github.com/PetterBraka/reHydrate/blob/master/Privacy-Policy.md"
        case .license:
            return "https://github.com/PetterBraka/reHydrate/blob/master/LICENSE"
        case .devInsta:
            return "https://www.instagram.com/braka.coding/"
        case .contactMe:
            return "mailto:Petter.braka@gmail.com" +
                "?subject=reHydrate feedback" +
                "&body=Hello I have an issue..."
        case .helpTranslate:
            return "mailto:Petter.braka@gmail.com" +
                "?subject=reHydrate translation" +
                "&body=Hello I would like to help translate your app"
        case .merch:
            return "https://www.redbubble.com/people/petter-braka/shop" +
                "?artistUserName=petter-braka" +
                "&asc=u&iaCode=all-departments" +
                "&sortOrder=relevant#profile"
        }
    }
}

extension View {
    func openLink(to webSite: WebSite) {
        if let webSite = webSite.getURL().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: webSite),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func openLink(to webSite: String) {
        if let webSite = webSite.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: webSite),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
