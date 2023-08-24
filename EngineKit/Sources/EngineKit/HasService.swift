//
//  HasService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import DayServiceInterface
import DrinkServiceInterface
import LanguageServiceInterface
import DatabaseServiceInterface
import UnitServiceInterface
import UserPreferenceServiceInterface

public protocol HasService:
    HasDatabaseService,
    HasDayManagerService,
    HasConsumptionManagerService,
    HasDrinksService,
    HasDayService,
    HasLanguageService,
    HasUnitService,
    HasUserPreferenceService
{}
