//
//  LocalizationHelper.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreInterfaceKit
import Foundation

class LocalizationHelper {
    static let shared = LocalizationHelper()

    private init() {}

    private var currentLanguage: String {
        get {
            UserDefaults.getValue(for: Preference.currentLanguage) ??
                Preference.currentLanguage.default as? String ?? ""
        }
        set {
            UserDefaults.setValue(newValue, for: Preference.currentLanguage)
        }
    }

    var language: Language {
        get {
            Language(rawValue: currentLanguage) ?? .english
        } set {
            if newValue != language {
                currentLanguage = newValue.rawValue
                NotificationCenter.default.post(name: .changedLanguage, object: nil)
            }
        }
    }
}
