//
//  HasDatabaseService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/07/2023.
//

public protocol HasDayManagerService: Sendable {
    var dayManager: DayManagerType { get set }
}

public protocol HasConsumptionManagerService: Sendable {
    var consumptionManager: ConsumptionManagerType { get set }
}

public protocol HasDrinkManagerService: Sendable {
    var drinkManager: DrinkManagerType { get set }
}
