//
//  SettingsRepository.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 11/06/2022.
//  Copyright © 2022 Petter vang Brakalsvålet. All rights reserved.
//

import CoreKit
import SwiftUI

class SettingsRepository: ObservableObject {
    @AppStorage("language") var language = LocalizationHelper.shared.language
    @Preference(\.isDarkMode) var isDarkMode
    @Preference(\.isUsingMetric) var isMetric
    @Preference(\.isRemindersOn) var isRemindersOn
    @Preference(\.remindersStart) var remindersStart
    @Preference(\.remindersEnd) var remindersEnd
    @Preference(\.remindersInterval) var reminderFrequency
    @Preference(\.smallDrink) var smallDrink
    @Preference(\.mediumDrink) var mediumDrink
    @Preference(\.largeDrink) var largeDrink
    @Preference(\.hasReachedGoal) var hasReachedGoal
    @Preference(\.reachedGoalOnDate) var reachedGoalOnDate
}
