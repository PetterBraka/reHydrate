//
//  UserDefault+Helper.swift
//  reHydrate
//
//  Created by Antoine Van Der Lee 24/08/21.
//  Taken from: https://www.avanderlee.com/swift/appstorage-explained/
//

import CoreInterfaceKit
import SwiftUI

public extension UserDefaults {
    static func getValue<Value>(for preference: Preference) -> Value? {
        UserDefaults.standard.value(forKey: preference.key) as? Value ?? preference.default as? Value
    }

    static func setValue<Value>(_ value: Value, for preference: Preference) {
        UserDefaults.standard.set(value, forKey: preference.key)
    }

    static func getBinding<Value>(for preference: Preference) -> Binding<Value?> {
        Binding {
            UserDefaults.getValue(for: preference)
        } set: { newValue in
            UserDefaults.setValue(newValue, for: preference)
        }
    }
}
