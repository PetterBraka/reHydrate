//
//  LocalizationHelper.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

enum Language: String {
    case english = "en"
    case norwegian = "nb"
    case icelandic = "is"
    case german = "de"
}

class LocalizationHelper {
    static let shared = LocalizationHelper()

    private init() {}

    @Preference(\.currentLanguage) private var currentLanguage

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
