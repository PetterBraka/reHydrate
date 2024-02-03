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
import PortsInterface
import UnitServiceInterface
import UserPreferenceServiceInterface
import NotificationServiceInterface
import AppearanceServiceInterface
import DateServiceInterface

public protocol HasService:
    HasLoggingService,
    HasDrinksService,
    HasDayService,
    HasLanguageService,
    HasUnitService,
    HasUserPreferenceService,
    HasNotificationService,
    HasAppearanceService,
    HasDateService
{}
