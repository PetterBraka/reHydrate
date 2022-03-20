//
//  UserDefault+Helper.swift
//  reHydrate
//
//  Created by Antoine Van Der Lee 24/08/21.
//  Taken from: https://www.avanderlee.com/swift/appstorage-explained/
//

import Combine
import SwiftUI
import SwiftyUserDefaults

extension DefaultsKeys {
    var currentLanguage: DefaultsKey<String> { .init("AppleLanguages", defaultValue: "en") }
    var isUsingMetric: DefaultsKey<Bool> { .init("metricUnits", defaultValue: true) }
    var isRemindersOn: DefaultsKey<Bool> { .init("reminders", defaultValue: false) }
    var remindersStart: DefaultsKey<Date> { .init("startignTime", defaultValue: DateComponents(calendar: .current, hour: 8, minute: 0).date ?? Date()) }
    var remindersEnd: DefaultsKey<Date> { .init("endingTime", defaultValue: DateComponents(calendar: .current, hour: 23, minute: 0).date ?? Date()) }
    var remindersInterval: DefaultsKey<Int> { .init("reminderInterval", defaultValue: 30) }
    var smallDrink: DefaultsKey<Double> { .init("smallDrinkOption", defaultValue: 300) }
    var mediumDrink: DefaultsKey<Double> { .init("mediumDrinkOption", defaultValue: 500) }
    var largeDrink: DefaultsKey<Double> { .init("largeDrinkOption", defaultValue: 750) }
    var isDarkMode: DefaultsKey<Bool> { .init("darkMode", defaultValue: false) }
    var hasReachedGoal: DefaultsKey<Bool> { .init("hasReachedGoal", defaultValue: false) }
}

final class Preferences {
    static let standard = Preferences(userDefaults: .standard)
    fileprivate let userDefaults: UserDefaults

    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    @AppStorage("AppleLanguages")
    var languages: String = "en"
    @AppStorage("CurrentLanguage")
    var currentLanguage: String = "en"
    @AppStorage("metricUnits")
    var isUsingMetric: Bool = true
    @AppStorage("reminders")
    var isRemindersOn: Bool = false
    @UserDefault("startignTime")
    var remindersStart: Date = DateComponents(calendar: .current, hour: 8, minute: 0).date ?? Date()
    @UserDefault("endingTime")
    var remindersEnd: Date = DateComponents(calendar: .current, hour: 23, minute: 0).date ?? Date()
    @AppStorage("reminderInterval")
    var remindersInterval: Int = 30
    @AppStorage("smallDrinkOption")
    var smallDrink: Double = 300
    @AppStorage("mediumDrinkOption")
    var mediumDrink: Double = 500
    @AppStorage("largeDrinkOption")
    var largeDrink: Double = 750
    @AppStorage("darkMode")
    var isDarkMode: Bool = false
    @AppStorage("hasReachedGoal")
    var hasReachedGoal: Bool = false
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
