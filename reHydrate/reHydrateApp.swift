//
//  reHydrateApp.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

@main
struct reHydrateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(appDelegate.sceneFactory)
                .task { // TEMP Testing of HealthKit Reading
                    // date = 06/11/2023
                    let date = Date(timeIntervalSince1970: 1_699_258_440)
                    do {
                        let health = HealthKitPort()
                        if await health.shouldRequestAccess(for: [.water(.litre)]) {
                            try await health.requestAuth(toReadAndWrite: [.water(.litre)])
                        }
                        let calendar = Calendar.current
                        let start = calendar.startOfDay(for: date)
                        let end = calendar.endOfDay(for: date)!
                        health.read(.water(.litre), queryType: .sum(
                            start: start,
                            end: end,
                            intervalComponents: .init(day: 1),
                            completion: { result in
                                print("=== SUM ===")
                                print(result)
                                print("=== End ===")
                            })
                        )
                        health.read(.water(.litre), queryType: .sample(
                            start: start,
                            end: end,
                            completion: { result in
                                print("=== SAMPLES ===")
                                print(result)
                                print("=== End ===")
                            }))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        }
    }
}
