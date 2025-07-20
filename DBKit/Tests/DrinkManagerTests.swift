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
    var sut: DrinkManagerType
    
    init() {
        let logger = LoggerService(subsystem: "com.braka.test")
        let container = Database.createContainer(
            path: nil,
            inMemory: true,
            schema: .init([DrinkEntity.self])
        )
        self.sut = DrinkManager(container: container, logger: logger)
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
    }
    
    @Test
    func deleteDrink() async throws {
        let drinks = try await preloadDefaults()
        
        try await sut.delete(drinks[0])
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetch("small")
        }
        #expect(try await sut.fetchAll().count == 2)
    }
    
    @Test
    func deleteDrink_whenEmpty() async throws {
        try await #require(throws: DatabaseError.noElementFound) {
            try await sut.delete(.init(id: "", size: 0, container: ""))
        }
    }
    
    @Test
    func deleteDrinkContainer() async throws {
        try await preloadDefaults()
        
        try await sut.deleteDrink(container: "medium")
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetch("medium")
        }
        #expect(try await sut.fetchAll().count == 2)
    }
    
    @Test
    func deleteAll_whenEmpty() async throws {
        try await sut.deleteAll()
    }
    
    @Test
    func deleteAll() async throws {
        try await preloadDefaults()
        
        try await sut.deleteAll()
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetchAll()
        }
    }
    
    @Test
    func fetchContainer_whenEmpty() async throws {
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetch("small")
        }
    }
    
    @Test
    func fetchContainer() async throws {
        let drinks = try await preloadDefaults()
        
        let foundDrink = try await sut.fetch("small")
        #expect(foundDrink == drinks[0])
    }
    
    @Test
    func fetchAll_whenEmpty() async throws {
        try await #require(throws: DatabaseError.noElementFound) {
            _ = try await sut.fetchAll()
        }
    }
    
    @Test
    func fetchAll() async throws {
        let drinks = try await preloadDefaults()
        
        let foundDrinks = try await sut.fetchAll()
        
        #expect(foundDrinks.count == 3)
        #expect(foundDrinks == drinks)
    }
    
    // MARK: - Helpers
    
    @discardableResult
    func preloadDefaults() async throws -> [DrinkModel] {
        try await [
            sut.createNewDrink(size: 300, container: "small"),
            sut.createNewDrink(size: 500, container: "medium"),
            sut.createNewDrink(size: 750, container: "large")
        ]
    }
}
