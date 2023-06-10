//
//  reHydrateApp.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreKit
import SwiftUI

// swiftlint:disable all
@main
struct reHydrateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let settingsRepository: SettingsRepository = MainAssembler.resolve()
    private var isDarkMode: Bool { settingsRepository.isDarkMode }

    init() {
//        UITableView.appearance().backgroundColor = .background
//        UICollectionView.appearance().backgroundColor = .background
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(IconHelper())
        }
    }
}

// swiftlint:enable all
