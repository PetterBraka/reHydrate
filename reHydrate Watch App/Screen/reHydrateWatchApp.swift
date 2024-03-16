//
//  reHydrateWatchApp.swift
//  reHydrate Watch App
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

@main
struct reHydrateWatchApp_Watch_AppApp: App {
    let factory = SceneFactory.shared
    
    var body: some Scene {
        WindowGroup {
            factory.makeHomeView()
        }
    }
}
