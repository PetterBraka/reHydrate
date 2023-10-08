//
//  HasDatabaseService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/07/2023.
//

public protocol HasDatabaseService {
    var database: DatabaseType { get set }
}

public protocol HasDayManagerService {
    var dayManager: DayManagerType { get set }
}

public protocol HasConsumptionManagerService {
    var consumptionManager: ConsumptionManagerType { get set }
}

public protocol HasContainerManagerService {
    var containerManager: ContainerManagerType { get set }
}

public protocol HasDrinkManagerService {
    var drinkManager: DrinkManagerType { get set }
}
