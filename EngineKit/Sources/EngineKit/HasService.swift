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
import NotificationServiceInterface

public protocol HasService:
    HasLoggingService,
    HasDatabaseService,
    HasDayManagerService,
    HasContainerManagerService,
    HasConsumptionManagerService,
    HasDrinksService,
    HasDayService,
    HasLanguageService,
    HasUnitService,
    HasUserPreferenceService,
    HasNotificationService
{}
