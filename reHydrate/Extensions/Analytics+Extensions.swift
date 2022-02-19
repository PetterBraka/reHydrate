//
//  Analytics+Extensions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/01/2022.
//  Copyright © 2022 Petter vang Brakalsvålet. All rights reserved.
//

import FirebaseAnalytics
import Foundation

extension Analytics {
    enum Event {
        case startUp
        case addDrink
        case removeDrink

        func getName() -> String {
            switch self {
            case .startUp:
                return "Start_up"
            case .addDrink:
                return "Add_drink"
            case .removeDrink:
                return "Remove_drink"
            }
        }

        func getParameters() -> [String: Any] {
            switch self {
            case .startUp:
                return ["Started": "Yes"]
            case .addDrink:
                return ["Added_drink": "Yes"]
            case .removeDrink:
                return ["Removed_drink": "Yes"]
            }
        }
    }

    static func track(event: Event) {
        logEvent(event.getName(), parameters: event.getParameters())
    }
}
