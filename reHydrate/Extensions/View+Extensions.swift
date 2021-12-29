//
//  View+Extensions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 29/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

enum WebSite: String {
    case privacy = "https://github.com/PetterBraka/reHydrate/blob/master/Privacy-Policy.md"
    case license = "https://github.com/PetterBraka/reHydrate/blob/master/LICENSE"
    case devInsta = "https://www.instagram.com/braka.coding/"
    case email = "mailto:Petter.braka@gmail.com?subject=reHydrate feedback&body=Hello I have an issue..."
}

extension View {
    func openLink(to webSite: WebSite) {
        if let webSite = webSite.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: webSite),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
