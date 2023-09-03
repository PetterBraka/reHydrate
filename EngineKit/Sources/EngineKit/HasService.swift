//
//  HasService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import LoggingService
import DayServiceInterface
import DrinkServiceInterface
import LanguageServiceInterface
import DatabaseServiceInterface
import UnitServiceInterface
import UserPreferenceServiceInterface

public protocol HasService:
    HasLoggingService,
    HasDatabaseService,
    HasDayManagerService,
    HasConsumptionManagerService,
    HasDrinksService,
    HasDayService,
    HasLanguageService,
    HasUnitService,
    HasUserPreferenceService
{}
