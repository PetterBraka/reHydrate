//
//  RealDBTests.swift
//  DBKit
//
//  Created by Petter vang Brakalsvålet on 20/07/2025.
//


import Testing
@testable import DBKit
import DBKitInterface
import DBKitMocks
import LoggingKit
import Foundation

@Suite("RealDBTests")
struct RealDBTests {
    var dayManager: DayManagerType
    var drinkManager: DrinkManagerType
    var consumptionManager: ConsumptionManagerType
    
    init() {
        let logger = LoggerService(subsystem: "com.braka.test")
        let container = Database.createContainer(
            path: FileManager().temporaryDirectory,
            schema: .init([DayEntity.self, DrinkEntity.self, ConsumptionEntity.self])
        )
        
        self.dayManager = DayManager(container: container, logger: logger)
        self.drinkManager = DrinkManager(container: container, logger: logger)
        self.consumptionManager = ConsumptionManager(container: container, logger: logger)
    }
    
    @Test()
    func test_dayManager() async throws {
        let entry = try await dayManager.createNewDay(date: .now, goal: 2)
        let foundEntries = try await dayManager.fetchAll()
        #expect(foundEntries.count == 1)
        try await dayManager.delete([entry])
    }
    
    @Test()
    func test_drinkManager() async throws {
        let entry = try await drinkManager.createNewDrink(size: 200, container: "testing")
        let foundEntries = try await drinkManager.fetchAll()
        #expect(foundEntries.count == 1)
        try await drinkManager.delete(entry)
    }
    
    @Test()
    func test_consumptionManager() async throws {
        let entry = try await consumptionManager.createEntry(date: .now, consumed: 200)
        let foundEntries = try await consumptionManager.fetchAll()
        #expect(foundEntries.count == 1)
        try await consumptionManager.delete(entry)
    }
}
