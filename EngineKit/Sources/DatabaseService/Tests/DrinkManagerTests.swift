//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import XCTest
import TestHelper
@testable import DatabaseService
import DatabaseServiceInterface
import DatabaseServiceMocks

final class DrinkManagerTests: XCTestCase {
    var database = Database(logger: .init(subsystem: "DrinkManagerTests"))
    var spy: DatabaseSpy<DrinkModel>!
    var sut: DrinkManagerType!
    
    override func setUp() {
        self.spy = DatabaseSpy(realObject: database)
        self.sut = DrinkManager(database: spy)
    }
    
    override func tearDown() async throws {
        try await sut.deleteAll()
        let db = try XCTUnwrap(database.db)
        XCTAssertTrue(db.isClosed)
    }
    
    func test_createNewDrink_success() async throws {
        let givenSize: Double = 200
        let givenContainer = "small"
        let drink = try await sut.createNewDrink(size: givenSize, container: givenContainer)
        assert(drink, expectedSize: givenSize, expectedContainer: givenContainer)
        XCTAssertEqual(spy.methodLogNames, [.write])
    }
    
    func test_createNewDayAndFetchDay_success() async throws {
        let givenSize: Double = 200
        let givenContainer = "small"
        let drink = try await sut.createNewDrink(size: givenSize, container: givenContainer)
        assert(drink, expectedSize: givenSize, expectedContainer: givenContainer)
        let foundDrink = try await sut.fetch(givenContainer)
        assert(drink, foundDrink)
        XCTAssertEqual(spy.methodLogNames, [.write, .readMatchingOrderByLimit])
    }
    
    func test_deleteDrink() async throws {
        let drinks = try await preloadDefaults()
        
        try await sut.delete(drinks[0])
        do {
            _ = try await sut.fetch("small")
            XCTFail("Expected to not find any drink")
        } catch {
            guard let dbError = error as? DatabaseError else {
                XCTFail("Expected database error not \(error)")
                return
            }
            XCTAssertEqual(dbError, .noElementFound)
        }
    }
    
    func test_deleteDrinkContainer() async throws {
        try await preloadDefaults()
        
        try await sut.deleteDrink(container: "medium")
        do {
            _ = try await sut.fetch("medium")
            XCTFail("Expected to not find any drink")
        } catch {
            guard let dbError = error as? DatabaseError else {
                XCTFail("Expected database error not \(error)")
                return
            }
            XCTAssertEqual(dbError, .noElementFound)
        }
    }
    
    func test_deleteAll_whenEmpty() async throws {
        try await sut.deleteAll()
    }
    
    func test_deleteAll() async throws {
        try await preloadDefaults()
        
        try await sut.deleteAll()
        let foundDrink = try await sut.fetchAll()
        XCTAssertEqual(foundDrink.count, 0)
    }
    
    func test_fetchContainer_whenEmpty() async throws {
        do {
            _ = try await sut.fetch("small")
            XCTFail("Expected to not find any drink")
        } catch {
            guard let dbError = error as? DatabaseError else {
                XCTFail("Expected database error not \(error)")
                return
            }
            XCTAssertEqual(dbError, .noElementFound)
        }
    }
    
    func test_fetchContainer() async throws {
        let drinks = try await preloadDefaults()
        
        let foundDrink = try await sut.fetch("small")
        assert(foundDrink, drinks[0])
    }
    
    func test_fetchAll_whenEmpty() async throws {
        let foundDrinks = try await sut.fetchAll()
        
        XCTAssertEqual(foundDrinks.count, 0)
        XCTAssertEqual(foundDrinks, [])
    }
    
    func test_fetchAll() async throws {
        let drinks = try await preloadDefaults()
        
        let foundDrinks = try await sut.fetchAll()
        
        XCTAssertEqual(foundDrinks.count, drinks.count)
        XCTAssertEqual(foundDrinks, drinks)
    }
}

extension DrinkManagerTests {
    func assert(_ givenDrink: DrinkModel,
                expectedSize: Double, expectedContainer: String,
                file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(givenDrink.size, expectedSize, file: file, line: line)
        XCTAssertEqual(givenDrink.container, expectedContainer, file: file, line: line)
    }
    
    func assert(_ givenDrink: DrinkModel, _ expectedDrink: DrinkModel,
                file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(givenDrink.size, expectedDrink.size, file: file, line: line)
        XCTAssertEqual(givenDrink.container, expectedDrink.container, file: file, line: line)
    }
}

extension DrinkManagerTests {
    @discardableResult
    func preloadDefaults(file: StaticString = #file, line: UInt = #line) async throws -> [DrinkModel] {
        try await [
            sut.createNewDrink(size: 300, container: "small"),
            sut.createNewDrink(size: 500, container: "medium"),
            sut.createNewDrink(size: 750, container: "large")
        ]
    }
}
