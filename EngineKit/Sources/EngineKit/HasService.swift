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
import UserNotificationServiceInterface
import AppearanceServiceInterface
import DateServiceInterface
import CommunicationKitInterface
import PhoneCommsInterface
import NotificationCenterServiceInterface

public protocol HasService:
    HasAppGroup,
    HasLoggingService,
    HasDayManagerService,
    HasDrinkManagerService,
    HasConsumptionManagerService,
    HasDrinksService,
    HasDayService,
    HasLanguageService,
    HasUnitService,
    HasUserPreferenceService,
    HasUserNotificationService,
    HasAppearanceService,
    HasDateService,
    HasPhoneService,
    HasPhoneComms,
    HasNotificationCenter
{}
