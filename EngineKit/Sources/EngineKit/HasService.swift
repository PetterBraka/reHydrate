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

public protocol HasService:
    HasConsumptionService,
    HasDrinksService,
    HasLanguageService,
    HasDatabaseService,
    HasDayManagerService
{}
