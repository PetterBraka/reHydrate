//
//  UserDefault+Extensions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/08/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    var lastVersion: DefaultsKey<Bool> { .init("version4.5.2", defaultValue: false) }
    var appleLanguages: DefaultsKey<[String]> { .init("AppleLanguages", defaultValue: [""]) }
    var darkMode: DefaultsKey<Bool> { .init("darkMode", defaultValue: false) }
    var metricUnits: DefaultsKey<Bool> { .init("metricUnits", defaultValue: false) }
    var startingTime: DefaultsKey<Date> { .init("startignTime", defaultValue: Date()) }
    var endingTime: DefaultsKey<Date> { .init("endingTime", defaultValue: Date()) }
    var reminders: DefaultsKey<Bool> { .init("reminders", defaultValue: false) }
    var reminderInterval: DefaultsKey<Int> { .init("reminderInterval", defaultValue: 30) }
    var smallDrinkOption: DefaultsKey<Double> { .init("smallDrinkOption", defaultValue: 300) }
    var mediumDrinkOption: DefaultsKey<Double> { .init("mediumDrinkOption", defaultValue: 500) }
    var largeDrinkOption: DefaultsKey<Double> { .init("largeDrinkOption", defaultValue: 750) }
}
