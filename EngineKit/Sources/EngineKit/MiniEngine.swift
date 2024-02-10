//
//  File.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//

import Foundation
import LoggingService
import UnitServiceInterface
import UnitService
import UserPreferenceServiceInterface
import UserPreferenceService
import DateServiceInterface
import DateService
import DrinkServiceInterface
import DrinkService

// The Mini engine is intended for app extensions (Watch & Widgets)
public final class MiniEngine {
    private let sharedDefaults: UserDefaults
    private let subsystem: String
    
    public init(
        appGroup: String,
        subsystem: String
    ) {
        self.subsystem = subsystem
        
        guard let sharedDefaults = UserDefaults(suiteName: appGroup)
        else {
            fatalError("Shared UserDefaults couldn't be setup")
        }
        self.sharedDefaults = sharedDefaults
    }
    
    public lazy var logger: LoggingService = LoggingService(subsystem: subsystem)
    public lazy var userPreferenceService: UserPreferenceServiceType = UserPreferenceService(defaults: sharedDefaults)
    public lazy var unitService: UnitServiceType = UnitService(engine: self)
    public lazy var dateService: DateServiceType = DateService()
}

extension MiniEngine: 
    HasLoggingService,
    HasUnitService,
    HasUserPreferenceService,
    HasDateService
{}
