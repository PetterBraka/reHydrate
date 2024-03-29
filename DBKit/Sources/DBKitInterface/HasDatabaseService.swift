//
//  HasDatabaseService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/07/2023.
//

public protocol HasDayManagerService {
    var dayManager: DayManagerType { get set }
}

public protocol HasConsumptionManagerService {
    var consumptionManager: ConsumptionManagerType { get set }
}

public protocol HasDrinkManagerService {
    var drinkManager: DrinkManagerType { get set }
}
