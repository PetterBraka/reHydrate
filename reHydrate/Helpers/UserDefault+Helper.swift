//
//  UserDefault+Helper.swift
//  reHydrate
//
//  Created by Antoine Van Der Lee 24/08/21.
//  Taken from: https://www.avanderlee.com/swift/appstorage-explained/
//

import Combine
import SwiftUI

final class Preferences {
    static let standard = Preferences(userDefaults: .standard)
    fileprivate let userDefaults: UserDefaults

    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    @UserDefault("AppleLanguages")
    var languages: String = "en"
    @UserDefault("CurrentLanguage")
    var currentLanguage: String = "en"
    @UserDefault("metricUnits")
    var isUsingMetric: Bool = true
    @UserDefault("reminders")
    var isRemindersOn: Bool = false
    @UserDefault("startignTime")
    var remindersStart: Date = DateComponents(calendar: .current, hour: 8, minute: 0).date ?? Date()
    @UserDefault("endingTime")
    var remindersEnd: Date = DateComponents(calendar: .current, hour: 23, minute: 0).date ?? Date()
    @UserDefault("reminderInterval")
    var remindersInterval: Int = 30
    @UserDefault("smallDrinkOption")
    var smallDrink: Double = 300
    @UserDefault("mediumDrinkOption")
    var mediumDrink: Double = 500
    @UserDefault("largeDrinkOption")
    var largeDrink: Double = 750
    @UserDefault("darkMode")
    var isDarkMode: Bool = false
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value

    var wrappedValue: Value {
        // swiftlint:disable unused_setter_value
        get { fatalError("Wrapped value should not be used.") }
        set { fatalError("Wrapped value should not be used.") }
    }

    init(wrappedValue: Value, _ key: String) {
        defaultValue = wrappedValue
        self.key = key
    }

    public static subscript(
        _enclosingInstance instance: Preferences,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Preferences, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<Preferences, Self>
    ) -> Value {
        get {
            let container = instance.userDefaults
            let key = instance[keyPath: storageKeyPath].key
            let defaultValue = instance[keyPath: storageKeyPath].defaultValue
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            let container = instance.userDefaults
            let key = instance[keyPath: storageKeyPath].key
            container.set(newValue, forKey: key)
            instance.preferencesChangedSubject.send(wrappedKeyPath)
        }
    }
}

@propertyWrapper
struct Preference<Value>: DynamicProperty {
    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    private let preferences: Preferences

    init(_ keyPath: ReferenceWritableKeyPath<Preferences, Value>, preferences: Preferences = .standard) {
        self.keyPath = keyPath
        self.preferences = preferences
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }.map { _ in () }
            .eraseToAnyPublisher()
        preferencesObserver = .init(publisher: publisher)
    }

    var wrappedValue: Value {
        get { preferences[keyPath: keyPath] }
        nonmutating set { preferences[keyPath: keyPath] = newValue }
    }

    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

final class PublisherObservableObject: ObservableObject {
    var subscriber: AnyCancellable?

    init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}
