//
//  HasService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import LoggingService
import DBKitInterface
import DayServiceInterface
import DrinkServiceInterface
import LanguageServiceInterface
import PortsInterface
import UnitServiceInterface
import UserPreferenceServiceInterface
import NotificationServiceInterface
import AppearanceServiceInterface
import DateServiceInterface
import CommunicationKitInterface
import PhoneCommsInterface

public protocol HasService:
    HasLoggingService,
    HasDayManagerService,
    HasDrinkManagerService,
    HasConsumptionManagerService,
    HasDrinksService,
    HasDayService,
    HasLanguageService,
    HasUnitService,
    HasUserPreferenceService,
    HasNotificationService,
    HasAppearanceService,
    HasDateService,
    HasPhoneService,
    HasPhoneComms
{}
