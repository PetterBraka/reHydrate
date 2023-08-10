//
//  HasDatabaseService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/07/2023.
//

public protocol HasDatabaseService {
    var database: DatabaseType { get }
}

public protocol HasDayManagerService {
    var dayManager: DayManagerType { get }
}

public protocol HasConsumptionManagerService {
    var consumptionManager: ConsumptionManagerType { get }
}
