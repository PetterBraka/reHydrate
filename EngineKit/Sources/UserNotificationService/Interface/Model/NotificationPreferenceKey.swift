//
//  Untitled.swift
//  EngineKit
//
//  Created by Petter vang Brakalsvålet on 06/10/2024.
//

import UserPreferenceServiceInterface

extension PreferenceKey {
    public static let isOn = PreferenceKey("notification-is-enabled")
    public static let frequency = PreferenceKey("notification-frequency")
    public static let start = PreferenceKey("notification-start")
    public static let stop = PreferenceKey("notification-stop")
    public static let lastCelebrationsDate = PreferenceKey("notification-last-celebrations-date")
}
