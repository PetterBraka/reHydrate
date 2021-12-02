//
//  reHydrateApp.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import SwiftyUserDefaults

@main
struct reHydrateApp: App {
    @Preference(\.isDarkMode) var isDarkMode
    
    init(){
        UITableView.appearance().backgroundColor = .background
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
