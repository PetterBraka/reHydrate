//
//  DrinkManagerTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import Testing
@testable import DBKit
import DBKitInterface
import DBKitMocks
import LoggingKit

@Suite("DrinkManager")
struct DrinkManagerTests {
    var spy: DatabaseSpy<DrinkModel, Database>
    var sut: DrinkManagerType
    
    init() {
        let logger = LoggerService(subsystem: "com.braka.test")
        self.spy = DatabaseSpy(
            realObject: Database(
                appGroup: "group.com.testing.DBKit",
                inMemory: true,
                schema: .init([DrinkModel.self]),
                logger: logger
            )
        )
        self.sut = DrinkManager(database: spy, logger: logger)
    }

    @Test
    func createNewDayAndFetchDay_success() async throws {
        let givenSize: Double = 200
        let givenContainer = "small"
        let drink = try await sut.createNewDrink(size: givenSize, container: givenContainer)
        #expect(drink.size == givenSize)
        #expect(drink.container == givenContainer)
        
        let foundDrink = try await sut.fetch(givenContainer)
        #expect(drink == foundDrink)
        let log = await spy.getMethodNamesLog()
        #expect(log == [.insert, .save, .read])
    }
    
    @Test
    func deleteDrink() async throws {
        let drinks = try await preloadDefaults()
        
        try await sut.delete(drinks[0])
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetch("small")
        }
        
        let log = await spy.getMethodNamesLog()
        #expect(log == [.delete, .save, .read])
    }
    
    @Test
    func deleteDrinkContainer() async throws {
        try await preloadDefaults()
        
        try await sut.deleteDrink(container: "medium")
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetch("medium")
        }
        
        let log = await spy.getMethodNamesLog()
        #expect(log == [.read, .delete, .save, .read])
    }
    
    @Test
    func editDrink() async throws {
        let drinks = try await preloadDefaults()
        let drink = try #require(drinks.first)
        #expect(drink.size == 300)
        
        let editedDrink = try await sut.edit(size: 400, of: drink.container)
        #expect(editedDrink.size == 400)
        
        let fetchUpdatedDrink = try await sut.fetch(drink.container)
        #expect(fetchUpdatedDrink.size == 400)
        
        let log = await spy.getMethodNamesLog()
        #expect(log == [.read, .save, .read])
    }
    
    @Test
    func deleteAll_whenEmpty() async throws {
        try await sut.deleteAll()
        
        let log = await spy.getMethodNamesLog()
        #expect(log == [.read, .save])
    }
    
    @Test
    func deleteAll() async throws {
        try await preloadDefaults()
        
        try await sut.deleteAll()
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetchAll()
        }
        
        let log = await spy.getMethodNamesLog()
        #expect(log == [.read, .delete, .delete, .delete, .save, .read])
    }
    
    @Test
    func fetchContainer_whenEmpty() async throws {
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetch("small")
        }
        
        let log = await spy.getMethodNamesLog()
        #expect(log == [.read])
    }
    
    @Test
    func fetchContainer() async throws {
        let drinks = try await preloadDefaults()
        
        let foundDrink = try await sut.fetch("small")
        #expect(foundDrink == drinks[0])
        
        let log = await spy.getMethodNamesLog()
        #expect(log == [.read])
    }
    
    @Test
    func fetchAll_whenEmpty() async throws {
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetchAll()
        }
        
        let log = await spy.getMethodNamesLog()
        #expect(log == [.read])
    }
    
    @Test
    func fetchAll() async throws {
        let drinks = try await preloadDefaults()
        
        let foundDrinks = try await sut.fetchAll()
        
        #expect(foundDrinks.count == 3)
        #expect(foundDrinks == drinks)
        
        let log = await spy.getMethodNamesLog()
        #expect(log == [.read])
    }
    
    // MARK: - Helpers
    
    @discardableResult
    func preloadDefaults() async throws -> [DrinkModel] {
        let drinks = try await [
            sut.createNewDrink(size: 300, container: "small"),
            sut.createNewDrink(size: 500, container: "medium"),
            sut.createNewDrink(size: 750, container: "large")
        ]
        await spy.resetMethodNameLog()
        return drinks
    }
}
