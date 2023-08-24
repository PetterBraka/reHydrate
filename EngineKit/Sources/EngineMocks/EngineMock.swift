//
//  EngineMocks.swift
//
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import EngineKit
import DayServiceInterface
import DayServiceMocks
import DrinkServiceInterface
import DrinkServiceMocks
import LanguageServiceInterface
import LanguageServiceMocks
import DatabaseServiceInterface
import DatabaseServiceMocks
import UnitServiceInterface
import UnitServiceMocks

public final class EngineMocks {
    public init() {}
    
    public var database: DatabaseType = DatabaseStub()
    public var dayManager: DayManagerType = DayManagerStub()
    public var consumptionManager: ConsumptionManagerType = ConsumptionManagerStub()
    
    public var dayService: DayServiceType = DayServiceStub()
    public var drinksService: DrinkServiceType = DrinkServiceStub()
    public var languageService: LanguageServiceType = LanguageServiceStub()
    public var unitService: UnitServiceType = UnitServiceStub()
}

extension EngineMocks: HasService {}
