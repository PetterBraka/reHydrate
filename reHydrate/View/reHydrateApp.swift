//
//  reHydrateApp.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

// swiftlint:disable all
@main
struct reHydrateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Preference(\.isDarkMode) private var isDarkMode
    @Environment(\.scenePhase) private var scenePhase

    init() {
        UITableView.appearance().backgroundColor = .background
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(IconHelper())
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        print("App is now active")
                    case .background:
                        print("Going into the background")
                        appDelegate.scheduleAppRefresh()
                    default:
                        print("App is now in an unknonw state")
                    }
                }
        }
    }
}
